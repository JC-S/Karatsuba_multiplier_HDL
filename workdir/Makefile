VCS = /eda/synopsys/vcs-mx/O-2018.09-SP1/bin/vcs
VERDI = /eda/synopsys/verdi/Verdi_O-2018.09-SP2/bin/verdi
FLIST = ../filelist/karat_mult_recursion.flist

export VCS_HOME = /eda/synopsys/vcs-mx/O-2018.09-SP1
export VERDI_HOME = /eda/synopsys/verdi/Verdi_O-2018.09-SP2
export KM_PRJ_DIR = $(shell pwd)/..

all: vcs run

vcs:
	${VCS} -full64 +v2k -sverilog -fsdb -f ${FLIST} -debug_access+all +memcbk 

run:
	./simv

verdi:
	${VERDI} -sv -f ${FLIST} &

vpd2fsdb:
	${VERDI_HOME}/bin/vpd2fsdb wave.vpd
clean:
	rm simv* wave* -fr
