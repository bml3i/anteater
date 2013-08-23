#!/bin/bash
# Program: 
#        This program is used to extract website's root URLs from target page for further use. 
# History:
#        08/23/2013		Leo Bi		First release

# my testing
# sh extract_urls.sh -u https://raw.github.com/bml3i/pure-timer/master/test.html 

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


# getopts
while getopts ":o:u:p:" Option
do
  case $Option in
    o ) outputfilename=${OPTARG} ;;
    u ) url=${OPTARG} ;;
    p ) patternstring=${OPTARG} ;;
    * ) ;;
  esac
done

# check url
if [ -z "${url}" ]; then
  echo -e "Error: Url is required."
  exit 0
fi

# check outputfilename & outputfile
if [ -z "${outputfilename}" ]; then
  outputfile=${anteater_output_path}/${pid}.out
else
  outputfile=${anteater_output_path}/${outputfilename}.out
fi

# backups
# curl -s ${url} | grep "[http|https]://" | tr "'" '\n' | tr ' ><(),=?"|' '\n\n\n\n\n\n\n\n\n\n\n\n' | grep "[http|https]://www" | grep "${patternstring}" | sed 's/\([http|https]:\/\/[^\/]*\)\/.*/\1/' | sort -u >> ${outputfile}

# grab domain URLs and write them to a file
curl -s ${url} | grep "[http|https]://" | tr "'" '\n' | tr ' ><(),=?"|' '\n\n\n\n\n\n\n\n\n\n\n\n' | grep "[http|https]://www" | grep "${patternstring}" | sed 's/\([http|https]:\/\/[^\/]*\)\/.*/\1/' | sort -u >> ${outputfile}

exit 0
