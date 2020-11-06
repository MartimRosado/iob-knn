KNN_DIR:=.
include core.mk

sim:
	make -C $(SIM_DIR) run SIMULATOR=$(SIMULATOR)

sim-clean:
	make -C $(SIM_DIR) clean
