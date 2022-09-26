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
# Modify these as necessary
if [ -d "$LSF_ENVDIR/../.." ]; then
  lsf_top=$(cd "$LSF_ENVDIR/../.."; pwd)
elif [ -d "$LSF_ENVDIR/.." ]; then
  lsf_top=$(cd "$LSF_ENVDIR/.."; pwd)
fi

#
# minutes between crontab runs
lsf_frequency=10
#######################################################################################
# ID for LSF Standard
#######################################################################################
swidtag="e4c6c80d606f4f09bbfb0b7541749634"
#######################################################################################
#
. ${LSF_ENVDIR}/profile.lsf

tmp_str=`badmin showstatus | grep Cores | cut -f 2 -d ":"`
numCores=`echo $tmp_str | cut -f 1 -d "/"`
numMaxCores=`echo $tmp_str | cut -f 2 -d "/"`
the_date=`date -Imin`
the_date_plus=`date -Imin -d "+$lsf_frequency minutes"`

swlog_location="${lsf_top}/properties/${swidtag}"

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
  <SubType>Peak Cores</SubType>
  <Value>$numMaxCores</Value>
  <Period>
    <StartTime>$the_date</StartTime>
    <EndTime>$the_date_plus</EndTime>
  </Period>
</Metric>" >> "$swlog_location".slmtag

################################################
#check to roll over the logs
################################################

fsize=`stat --format=%s "$swlog_location".slmtag`
numlogs=`ls -l | grep "$swidtag"_ | cut -d"_" -f2 | cut -d"." -f1 | sort -r | head -1`
if [ $fsize > 999999 ]; then
  if [ $numlogs > 0 ]; then
    for (( i=${numlogs}; i>0; i-- )) ; do
      mv "$swlog_location"_$i".slmtag"  "$swlog_location"_$(( i+1 ))".slmtag"
    done
  fi
  cp "$swlog_location".slmtag "$swlog_location"_1.slmtag
fi

