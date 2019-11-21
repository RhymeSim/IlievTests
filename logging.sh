function get_time() {
  report_time=$(printf "[%s]" $(date "+%Y%m%d %H:%M:%S"))
  echo "${report_time}"
}


function log() {
  if [[ -n "$1" ]]; then var_value=$1; else echo 'log function need at least one argument'; exit; fi
  if [[ -n "$2" ]]; then var_name=$(printf "%20s =" "$2"); else var_name=''; fi
  if [[ -n "$3" ]]; then var_desc="($3)"; else var_desc=''; fi

  report_time=$(get_time)

  echo "${report_time} ${var_name} ${var_value} ${var_desc}"
}
