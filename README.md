EASY FLASH TO FPGA
===================

**LINUX VERSION**
see /bash_ver

two scripts exist -> **trom.sh**  
                  -> **tflash.sh**
                  
HOW TO USE
---
    1. run bash_ver/trom.sh -h from cmd to see usage, trom.sh is used to create rom file
    2. run bash_ver/tflash.sh -h from cmd to see usage, tflash.sh is used to flash rom file
    3. the script creates additional files in a .\generated folder so for easier use keep all the cloned files in a separate folder

trom.sh -> used to create .mcs (rom) file  
tflash.sh -> used to flash mcs to fpga (Spartan3A DSP Only, change options in /dependencies)

**WINDOWS VERSION**
**run flash_to_fpga.bat -h to see options**

Simple batch script that enables direct prom file generation and flashing to device with the Xilinx iMPACT tool.  
device specific configurations can be performed in .\dependencies folder  
**support currently exists only for the Spartan 3A DSP.**

**for this to run, you'll need to add impact.exe to your PATH (or) insert the absolute path for impact in flash_to_fpga.bat**

HOW TO USE
---
    1. Clone repository to folder that doesn't require administrative access
    2. run flash_to_fpga.bat -h from cmd to see available options
    3. the script creates additional files in a .\generated folder so for easier use keep all the cloned files in a separate folder
