# IOb-KNN

The IObundle KNN core includes a configurable hardware accelerator for the KNN machine learning algorithm.
It is written in Verilog and includes a C software driver. The user may change the size of the module to fit in its own FPGAs balancing the compromise between desired performance and space available. The IP is currently supported for use in FPGAs.

## Clone the repository

``git clone --recursive git@github.com:MartimRosado/iob-soc-knn.git``

Access to Github by *ssh* is mandatory so that submodules can be updated.


## The core configuration file: core.mk

The module configuration is the core.mk file residing at the repository
root. Edit the core.mk file at will.

## Simulation

The following commands will run locally if the simulator selected by the
SIMULATOR variable is installed and listed in the LOCAL\_SIM\_LIST
variable. Otherwise they will run by ssh on the server selected by the
SIM_SERVER variable.

To simulate:
```
make [sim]
```

Parameters can be passed in the command line overriding those in the system.mk file. For example:
```
make [sim] INIT_MEM=0 RUN_DDR=1
```

To clean the simulation directory:
```
make sim-clean
```

To visualise simulation waveforms:
```
make sim-waves
```
The above command assumes simulation had been previously run with the VCD variable set to 1. Otherwise an error issued.

## FPGA

The following commands will run locally if the FPGA_SERVER is set to localhost.  Otherwise they will run by ssh on the server
selected by the FPGA_SERVER variable.

To compile the FPGA:
```
make fpga [FPGA_SERVER=[pudim-flan.iobundle.com|localhost]]
```

To clean FPGA files:
```
make fpga-clean
```

## Documentation

The following commands assume a full installation of Latex is
present. Otherwise install it. The texlive-full Linux package is recommended.
Default document is ug (User Guide).

To compile the chosen document type:
```
make document [DOC_TYPE=[ug|pb]]
```

To clean the chosen document type:
```
make doc-clean [DOC_TYPE=[ug|pb]]
```

To clean the chosen document pdf file:
```
make doc-pdfclean [DOC_TYPE=[ug|pb]]
```


## Cleaning

The following command will clean the selected directories for simulation, FPGA compilation and board run: 
```
make clean
```