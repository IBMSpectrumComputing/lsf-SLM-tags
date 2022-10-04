#/bin/sh
########################################################################################
# This script creates .slmtag log data
#
# Install this script as a crontab to log usage info
# the crontab frequency should be often enough to capture accurage usage
# if the cluster is static then once an hour is sufficient
# if the cluster is dynamic (on cloud) with hosts frequently joining/leaving, then 5mins
########################################################################################
#

########################################################################################
# This function rolls the log files if the current log file exceeds the given size.
########################################################################################
function rollLogs {
	filepath=$1
	filename=$2
	fileext=$3
	rollsize=$4
	
	################################################
	#check to roll over the logs
	################################################
	if [ -f "$filepath/$filename".slmtag ]; then
		fsize=`stat --format=%s "$filepath/$filename$fileext"`
	else
		fsize=0
	fi
	
	numlogs=`ls -l $filepath | grep "$filename"_ | cut -d"_" -f2 | cut -d"." -f1 | sort -n -r | head -1`

	if [ $fsize -gt $rollsize ]; then
	  if [ $numlogs > 0 ]; then
		for (( i=${numlogs}; i>0; i-- )) ; do
		  mv "$filepath/$filename"_$i$fileext  "$filepath/$filename"_$(( i+1 ))$fileext
		done
	  fi
	  
	  mv "$filepath/$filename"$fileext "$filepath/$filename"_1$fileext
	fi
}

# check that xmllint is installed
if ! command -v xmllint &> /dev/null
then
    echo "This script requires xmllint. Please install this app."
    exit 1
fi


# set lsf_top to where the properties/version directories are found.
if [ -d "$LSF_ENVDIR/../../properties" ]; then
  lsf_top=$(cd "$LSF_ENVDIR/../.."; pwd)
elif [ -d "$LSF_ENVDIR/../properties" ]; then
  lsf_top=$(cd "$LSF_ENVDIR/.."; pwd)
fi

# check we have the swidtag files
if [ ! -d $lsf_top/properties/version ]
then
	echo "Unable to find LSF properties/version directory."
	echo "Make sure the LSF_ENVDIR environment variable is defined."
	echo "Has profile.lsf been run?"
	exit 1
fi

# minutes between crontab runs
lsf_frequency=10

#######################################################################################
# get the product name and tag pairs from the *.swidtag files in properties/version.
#######################################################################################
for f in $lsf_top/properties/version/*.swidtag; do 
	# command to get product name from swidtag file
	productName=$(xmllint --xpath 'string(//*/@name)' $f $1)
	
	# command to get swidtag from swidtag file
	swidtag=$(xmllint --xpath 'string(//*//@persistentId)' $f $1)
	
	swlog_location="$lsf_top/properties/$swidtag"
	swlog_path="$lsf_top/properties"
	
	rollLogs $swlog_path $swidtag ".slmtag" 999999
	
	# get date of logging 
	the_date=`date -Imin`
	the_date_plus=`date -Imin -d "+$lsf_frequency minutes"`
	
	# are we counting servers or users? Search for "SERVERS" in the uppercased product name.
	PRODUCTNAME=${productName^^}
	if [[ "$PRODUCTNAME" == *"SERVERS"* ]]; then
		# record # of Current Cores, Maximum Cores, Current Servers, and Maximum Servers
		tmpStr=`badmin showstatus | grep Cores | cut -f 2 -d ":"`
		numCores=`echo $tmpStr | cut -f 1 -d "/"`
		numMaxCores=`echo $tmpStr | cut -f 2 -d "/"`
		numServers=`echo $tmpStr | cut -f1 -d"/"`
		numMaxServers=`echo $tmpStr | cut -f2 -d"/"`
		echo "<SchemaVersion>2.1.1</SchemaVersion>
<Product>
<ProductName>LSF Standard 10.1</ProductName>
  <PersistentId>$swidtag</PersistentId>
  <InstanceId>$lsf_top/properties/version</InstanceId>
</Product>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Current Cores</SubType>
  <Value>$numCores</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Maximum Cores</SubType>
  <Value>$numMaxCores</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Current Servers</SubType>
  <Value>$numServers</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Maximum Servers</SubType>
  <Value>$numMaxServers</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>">> "$swlog_location".slmtag
	else
		# record # of Current Users & Active Users
		numUsers=`badmin showstatus | grep "of users" | cut -f2 -d":" | sed 's/ //g'`
		numActiveUsers=`badmin showstatus | grep "active users" | cut -f2 -d":" | sed 's/ //g'`
		echo "<SchemaVersion>2.1.1</SchemaVersion>
<Product>
<ProductName>LSF Standard 10.1</ProductName>
  <PersistentId>$swidtag</PersistentId>
  <InstanceId>$lsf_top/properties/version</InstanceId>
</Product>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Current Users</SubType>
  <Value>$numUsers</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>
<Metric logTime=\""$the_date"\">
<Type>RESOURCE_VALUE_UNIT</Type>
  <SubType>Active Users</SubType>
  <Value>$numActiveUsers</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>">> "$swlog_location".slmtag
	fi
	
done

echo Done
exit 0
