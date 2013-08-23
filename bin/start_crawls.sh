#!/bin/bash
# Program: 
#        This program is used to ....
# History:
#        08/23/2013		Leo Bi		First release

# my testing
# sh start_crawls.sh -u www.baidu.com -t 2
# sh start_crawls.sh -u http://www.jinan.gov.cn/ -t 1 -p gov -o mytest
# sh start_crawls.sh -u http://www.jinan.gov.cn/ -t 2 -p gov -o mytest
# sh start_crawls.sh -u https://raw.github.com/bml3i/pure-timer/master/test.html -t 1


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

# getopts
while getopts ":o:p:t:u:" Option
do
  case $Option in
    o ) outputfilename=${OPTARG} ;;
    p ) patternstring=${OPTARG} ;;
    t ) tier=${OPTARG} ;;
    u ) url=${OPTARG} ;;
    * ) ;;
  esac
done

# check url
if [ -z "${url}" ]; then
  echo -e "Error: url is required."
  exit 0
fi

# check tier, use default_tier if it is not provided
if ! [ -z "${tier}" ] && echo "${arr_tier[@]}" | grep -w "${tier}" &>/dev/null; then
  let tier=${tier}
else
  if [ -z "${tier}" ]; then
	  echo "Tier param is not provided, then use default value ${default_tier}."
    let tier=${default_tier}
  else
    echo -e "Error: tier should be 1~3 (default value: 1)."
    exit 0
  fi
fi

# check outputfilename & outputfile
if [ -z "${outputfilename}" ]; then
  outputfile=${anteater_output_path}/${pid}.out
else
  outputfile=${anteater_output_path}/${outputfilename}.out
fi


# iterate tiers
tier_idx=1
while ((${tier_idx}<=${tier}))
do
  echo "current tier index: " ${tier_idx}
  temp_output_filename="${pid}_${tier_idx}"
  
  if [ 1 -eq ${tier_idx} ]; then
    echo "extracting ${url} ..."
    sh ${anteater_bin_path}/extract_urls.sh -u ${url} -o ${temp_output_filename} -p ${patternstring}
  fi
  
  if [ 1 -lt ${tier_idx} ]; then
    let source_file_idx=${tier_idx}-1
    source_filename="${anteater_output_path}/${pid}_${source_file_idx}.out"

    if [ -f ${source_filename} ]; then
      while IFS= read -r line; do
        echo "extracting ${line} ..."
        sh ${anteater_bin_path}/extract_urls.sh -u ${line} -o ${temp_output_filename} -p ${patternstring}
        done < "${source_filename}"
	fi
  fi
  
  let tier_idx=${tier_idx}+1
done

# get unique sorted URLs and write them to a file 
all_temp_output_files_pattern="${anteater_output_path}/${pid}_*.out"
cat ${all_temp_output_files_pattern} | sort -u >> ${outputfile}
rm -rf ${all_temp_output_files_pattern}


echo "Completed!"
exit 0