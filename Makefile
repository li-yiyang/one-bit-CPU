BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

TOP=cpu
TOP_PNR=${TOP}_pnr

all: ${TOP}.fs

# Generate Bit Stream
${TOP}.fs: ${TOP_PNR}.json
	gowin_pack -d ${FAMILY} -o ${TOP}.fs ${TOP_PNR}.json

# Place and Route
${TOP_PNR}.json: ${TOP}.json
	nextpnr-gowin --json ${TOP}.json --freq 27 --write ${TOP_PNR}.json \
								--device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Synthesize
${TOP}.json: *.v
	yosys -p "$(foreach f, $(wildcard *.v), read_verilog $(f);) \
						synth_gowin -top ${TOP} -json ${TOP}.json"


.PHONY: load clean

# Program Device
load: ${TOP}.fs
	openFPGALoader -b ${BOARD} ${TOP}.fs -f

# Clean Up
clean:
	rm ${TOP}.json
	rm ${TOP_PNR}.json
	rm ${TOP}.fs
