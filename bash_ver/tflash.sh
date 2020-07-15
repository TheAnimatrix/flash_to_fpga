mcs_file=""
windows='false'

#colors
LIME_YELLOW=$(tput setaf 190)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)

help() {
  printf "\n"
  echo "${LIME_YELLOW}TFLASH USAGE:${NORMAL}"
  echo "shell script to flash provided .mcs(rom) file to Spartan 3A FPGA"
  echo "arguement list:"
  echo "${CYAN}-m,${NORMAL} [Required] provide rom file to be flashed"
  echo "${CYAN}-w,${NORMAL} [Optional] windows compatible paths"
}

#-b, bit file
#-t, mcs(rom) target directory
#-h, help
#-m, mcs(rom) name optional
while getopts 'm:hw' flag; do
  case "${flag}" in
    m) mcs_file="${OPTARG}" ;;
    w) windows='true';;
    *) help
       exit 1 ;;
  esac
done

if [ "$mcs_file" == "" ]
then
echo "${RED}ROM FILE NAME NOT PROVIDED ${NORMAL}"
help
exit 1
fi

#convert relative path to absolute
if [ "${mcs_file:0:1}" == "." ]
then
mcs_file="$(cd "$(dirname "$mcs_file")"; pwd)/$(basename "$mcs_file")"
fi


echo "${LIME_YELLOW}FILE:${NORMAL} $mcs_file"

#check if bitfile exists, error if it doesn't
if [ ! -f "$mcs_file" ]
then
  printf "\n"
  echo "${RED}$mcs_file, mcs file provided doesn't exist${NORMAL}"
  help
  exit 1
fi

#all checks completed
#proceed to logic
#generate impact command file
echo "${LIME_YELLOW}generating prom flash file${NORMAL}"
if [ ! -d generated ]
then
mkdir generated;
fi
printf "\n"
sed "s+\[mcs_target_file\]+\"$mcs_file\"+g" dependencies/flash_rom.cmd > generated/flash_rom.cmd 
#convert linux paths to windows
if [ $windows == 'true' ]
then
echo "override"
sed -i 's#/c/#C:\\#g' generated/flash_rom.cmd
sed -i 's#/#\\#g' generated/flash_rom.cmd
fi
# flash prom
echo "${LIME_YELLOW}programming flash using provided file${NORMAL}"
impact -batch $PWD/generated/flash_rom.cmd
exit 1;
