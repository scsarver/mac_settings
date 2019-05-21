

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
  underline)
      echo "4"
      ;;
  blinking)
      echo "5"
      ;;
  reverse)
      echo "7"
      ;;
  invisible)
      echo "8"
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
      echo $"Usage: get_ansi_color_code {black|dark_gray|red|light_red|green|light_green|brown|orange|yellow|blue|Light_blue|purple|light_purple|cyan|light_cyan|light_gray|white|bold|dim|underline|blining|reverse|invisible|no_color|normal|reset}"
esac
}
