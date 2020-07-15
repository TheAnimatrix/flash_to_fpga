setMode -bscan
setCable -p auto
Identify -inferir
identifyMPM
attachflash -position 1 -bpi "28F128J3D"
assignfiletoattachedflash -position 1 -file [mcs_target_directory]
Program -p 1 -dataWidth 8 -rs1 NONE -rs0 NONE -bpionly -e -v -loadfpga
quit