mcs_name="generated/out.mcs"
bitfile=""
mcs_target_directory=$PWD
windows='false';


#colors
LIME_YELLOW=$(tput setaf 190)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)

help() {
  printf "\n"
  echo "${LIME_YELLOW}TROM USAGE:${NORMAL}"
  echo "arguement list:"
  echo "${CYAN}-b,${NORMAL} [Required] provide your complete bit file absolute path [x:\folder\example.bit]"
  echo "${CYAN}-t,${NORMAL} [Optional] directory where you want your generated rom to be stored in (. for current directory, default)"
  echo "${CYAN}-m,${NORMAL} [Optional] name of generated rom file, default is out.mcs"
  echo "${CYAN}-w,${NORMAL} [Optional] windows compatible paths"
}

#-b, bit file
#-t, mcs(rom) target directory
#-h, help
#-m, mcs(rom) name optional
while getopts 'b:t:m:hw' flag; do
  case "${flag}" in
    b) bitfile="${OPTARG}";;
    t) mcs_target_directory="${OPTARG}" ;;
    m) mcs_name="${OPTARG}" ;;
    w) windows='true';;
    *) help
       exit 1 ;;
  esac
done


#convert relative path to absolute
if [ "${mcs_target_directory:0:1}" == "." ]
then
mcs_target_directory="$(cd "$(dirname "$mcs_target_directory")"; pwd)/$(basename "$mcs_target_directory")"
fi

#convert relative path to absolute
if [ "${bitfile:0:1}" == "." ]
then
bitfile="$(cd "$(dirname "$bitfile")"; pwd)/$(basename "$bitfile")"
fi

#check if target directory exists, error if it doesn't
if [ ! -d "$mcs_target_directory" ]
then
  printf "\n"
  echo "${RED}$mcs_target_directory, invalid target directory${NORMAL}"
  help
  exit 1
fi

echo "${LIME_YELLOW}BITFILE:${NORMAL} $bitfile"
echo "${LIME_YELLOW}ROM_TARGET:${NORMAL} $mcs_target_directory"
echo "${LIME_YELLOW}ROM_NAME:${NORMAL} $mcs_name"

#check if bitfile exists, error if it doesn't
if [ ! -f "$bitfile" ]
then
  printf "\n"
  echo "${RED}$bitfile, bit file provided doesn't exist${NORMAL}"
  help
  exit 1
fi


#all checks completed
#proceed to logic
echo "${LIME_YELLOW}generating prom arguement file${NORMAL}"
if [ ! -d generated ]
then
mkdir generated;
fi
sed "s+\[mcs_name\]+\"$mcs_name\"+g; s+\[mcs_target_directory\]+\"$mcs_target_directory\"+g; s+\[flash_bit_file\]+\"$bitfile\"+g" dependencies/generate_prom.cmd > generated/generated_prom.cmd 
#windows path conversion if $windows
if [ $windows == 'true' ]
then
echo "override"
sed -i 's#/c/#C:\\#g' generated/generated_prom.cmd
sed -i 's#/#\\#g' generated/generated_prom.cmd
fi

printf "\n"
echo "${LIME_YELLOW}prom args file generated to $PWD\generated\generated_prom.cmd${NORMAL}"
impact -batch $PWD/generated/generated_prom.cmd
#generated prom

exit 1;
