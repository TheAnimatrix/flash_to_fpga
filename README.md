EASY FLASH TO FPGA
===================

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
