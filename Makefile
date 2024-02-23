BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

TOP=cpu
TOP_PNR=${TOP}_pnr

SIM=cpu_test
SRC=$(filter-out ${SIM}.v,$(wildcard *.v))

all: ${TOP}.fs

# Generate Bit Stream
${TOP}.fs: ${TOP_PNR}.json
	gowin_pack -d ${FAMILY} -o ${TOP}.fs ${TOP_PNR}.json

# Place and Route
${TOP_PNR}.json: ${TOP}.json
	nextpnr-gowin --json ${TOP}.json --freq 27 --write ${TOP_PNR}.json \
								--device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Synthesize
${TOP}.json: ${SRC}
	yosys -p "$(foreach f, ${SRC}, read_verilog $(f);) \
						synth_gowin -top ${TOP} -json ${TOP}.json"

# Simulation
${SIM}.o: ${SIM}.v ${SRC}
	iverilog -o ${SIM}.o -s ${SIM} *.v

simulation: ${SIM}.o
	vvp ${SIM}.o
	gtkwave ${SIM}.vcd

.PHONY: load clean simulation

# Program Device
load: ${TOP}.fs
	openFPGALoader -b ${BOARD} ${TOP}.fs -f

# Clean Up
clean:
	rm ${TOP}.json
	rm ${TOP_PNR}.json
	rm ${TOP}.fs
	rm ${SIM}.o
	rm ${SIM}.vcd
