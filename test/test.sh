#!/bin/bash
VODAM="10.127.209.180"

METHOD="$1"
usage ()
{
    echo "usage: $0 <POST|DELETE|GET>"
    echo "$0 GET"
}

if [ ${#@} == 0 ]; then
   usage
   exit 1
fi
CURL="curl -k -X $METHOD https://$VODAM:7001/v1/assetworkflows/vod-wf1/assets"
if [ $METHOD == "POST" ];then
   CURL="$CURL -H 'Content-type: application/json' -d @test2.json" 
else
   CURL="$CURL/IRIS_DLVY0020237847006192"
fi

eval $CURL|python -mjson.tool
#`$CURL|python -mjson.tool`
