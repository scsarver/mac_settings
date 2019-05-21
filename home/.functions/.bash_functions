

# Investigate xcol : https://ownyourbits.com/2017/01/23/colorize-your-stdout-with-xcol/

function setstyle {
  echo "$(get_ansi_code_prefix)$(get_ansi_code $1)$(get_ansi_code_suffix)"
}

function endstyle {
  echo "$(get_ansi_code_prefix)$(get_ansi_code reset)$(get_ansi_code_suffix)"
}

function get_ansi_code_prefix {
  echo "\033["
}

function get_ansi_code_suffix {
  echo "m"
}

function get_ansi_code {
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# http://ascii-table.com/ansi-escape-sequences-vt-100.php
# tput may be a better way to do this:  https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux/20983251#20983251
case "$1" in
  black)
      echo "0;30"
      ;;
  dark_gray)
      echo "1;30"
      ;;
  red)
      echo "0;31"
      ;;
  light_red)
      echo "1;31"
      ;;
  green)
      echo "0;32"
      ;;
  light_green)
      echo "1;32"
      ;;
  brown)
      echo "0;33"
      ;;
  orange)
      echo "0;33"
      ;;
  yellow)
      echo "1;33"
      ;;
  blue)
      echo "0;34"
      ;;
  Light_blue)
      echo "1;34"
      ;;
  purple)
      echo "0;35"
      ;;
  light_purple)
      echo "  1;35"
      ;;
  cyan)
      echo "0;36"
      ;;
  light_cyan)
      echo "1;36"
      ;;
  light_gray)
      echo "0;37"
      ;;
  white)
      echo "1;37"
      ;;
  bold)
      echo "1"
      ;;
  dim)
      echo "2"
      ;;
  italic)
      echo "3"
      ;;
  underline)
      echo "4"
      ;;
  blinking)
      echo "5"
      ;;
  blinking_fast)
      echo "6"
      ;;
  reverse)
      echo "7"
      ;;
  invisible)
      echo "8"
      ;;
  strikethrough)
      echo "9"
      ;;
  no_color)
      echo "0"
      ;;
  normal)
      echo "0"
      ;;
  reset)
      echo "0"
      ;;
  *)
      echo $"Usage: get_ansi_color_code {black|dark_gray|red|light_red|green|light_green|brown|orange|yellow|blue|Light_blue|purple|light_purple|cyan|light_cyan|light_gray|white|bold|dim|italic|underline|blining|reverse|invisible|no_color|normal|reset}"
esac
}



cecho(){

    # Regular Colors
    Black='\033[0;30m'        # Black
    Red='\033[0;31m'          # Red
    Green='\033[0;32m'        # Green
    Yellow='\033[0;33m'       # Yellow
    Blue='\033[0;34m'         # Blue
    Purple='\033[0;35m'       # Purple
    Cyan='\033[0;36m'         # Cyan
    White='\033[0;37m'        # White

    # Bold
    BBlack='\033[1;30m'       # Black
    BRed='\033[1;31m'         # Red
    BGreen='\033[1;32m'       # Green
    BYellow='\033[1;33m'      # Yellow
    BBlue='\033[1;34m'        # Blue
    BPurple='\033[1;35m'      # Purple
    BCyan='\033[1;36m'        # Cyan
    BWhite='\033[1;37m'       # White

    # Underline
    UBlack='\033[4;30m'       # Black
    URed='\033[4;31m'         # Red
    UGreen='\033[4;32m'       # Green
    UYellow='\033[4;33m'      # Yellow
    UBlue='\033[4;34m'        # Blue
    UPurple='\033[4;35m'      # Purple
    UCyan='\033[4;36m'        # Cyan
    UWhite='\033[4;37m'       # White

    # Background
    On_Black='\033[40m'       # Black
    On_Red='\033[41m'         # Red
    On_Green='\033[42m'       # Green
    On_Yellow='\033[43m'      # Yellow
    On_Blue='\033[44m'        # Blue
    On_Purple='\033[45m'      # Purple
    On_Cyan='\033[46m'        # Cyan
    On_White='\033[47m'       # White

    # High Intensity
    IBlack='\033[0;90m'       # Black
    IRed='\033[0;91m'         # Red
    IGreen='\033[0;92m'       # Green
    IYellow='\033[0;93m'      # Yellow
    IBlue='\033[0;94m'        # Blue
    IPurple='\033[0;95m'      # Purple
    ICyan='\033[0;96m'        # Cyan
    IWhite='\033[0;97m'       # White

    # Bold High Intensity
    BIBlack='\033[1;90m'      # Black
    BIRed='\033[1;91m'        # Red
    BIGreen='\033[1;92m'      # Green
    BIYellow='\033[1;93m'     # Yellow
    BIBlue='\033[1;94m'       # Blue
    BIPurple='\033[1;95m'     # Purple
    BICyan='\033[1;96m'       # Cyan
    BIWhite='\033[1;97m'      # White

    # High Intensity backgrounds
    On_IBlack='\033[0;100m'   # Black
    On_IRed='\033[0;101m'     # Red
    On_IGreen='\033[0;102m'   # Green
    On_IYellow='\033[0;103m'  # Yellow
    On_IBlue='\033[0;104m'    # Blue
    On_IPurple='\033[0;105m'  # Purple
    On_ICyan='\033[0;106m'    # Cyan
    On_IWhite='\033[0;107m'   # White

    NC='\033[0m' # No Color
    # Reset
    Color_Off='\033[0m'       # Text Reset

    printf "${!1}${2} ${NC}\n"
}

# Iterate throu and display in colors
# for (( i = 0; i < 8; i++ )); do
#     for (( j = 0; j < 8; j++ )); do
#         printf "$(tput setab $i)$(tput setaf $j)(b=$i, f=$j)$(tput sgr0)\n"
#     done
# done;

# for i in {30..49};do echo -e "\033[$i;7mReversed color code $i\033[0m Hello world!";done


# https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
# Spinner i.e. like a hourglass
# sp='/-\|'
# printf ' '
# while true; do
#     printf '\b%.1s' "$sp"
#     sp=${sp#?}${sp%???}
# done

# sp="/-\|"
# sc=0
# spin() {
#    printf "\b${sp:sc++:1}"
#    ((sc==${#sp})) && sc=0
# }
# endspin() {
#    printf "\r%s\n" "$@"
# }
#
# until work_done; do
#    spin
#    some_work ...
# done
# endspin
