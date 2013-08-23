#!/bin/bash
# Program: 
#        This program is used to ....
# History:
#        08/23/2013		Leo Bi		First release

# check environment variable first
if [ -z "${ANTEATER_HOME}" ]; then 
  echo -e "Error: Please set environment variable 'ANTEATER_HOME' first."
  exit 0
fi

# set variables
anteater_bin_path=${ANTEATER_HOME}/bin
anteater_output_path=${ANTEATER_HOME}/out
anteater_logs_path=${ANTEATER_HOME}/logs
pid=$$
default_tier=1
arr_tier=({1..3})



temp_files=${anteater_output_path}/51465_*.out

cat ${temp_files} | sort -u


# sh ${anteater_bin_path}/extract_urls.sh -u ${url}

echo "Completed!"
exit 0