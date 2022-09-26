#/bin/bash
########################################################################################
# Install this script as a crontab to log usage info for LSF Standard
# the crontab frequency should be often enough to capture accurage usage
# if the cluster is static then once an hour is sufficient
# if the cluster is dynamic (on cloud) with hosts frequently joining/leaving, then 5mins
#
# set up logrotate to roll this over weekly or monthly
#
# Modify these as necessary
########################################################################################
log_location=/tmp/lsfusage.log

########################################################################################
. ${LSF_ENVDIR}/profile.lsf

tmp_str=`badmin showstatus | grep Cores | cut -f 2 -d ":"`
numCores=`echo $tmp_str | cut -f 1 -d "/"`
numMaxCores=`echo $tmp_str | cut -f 2 -d "/"`
the_date=`date -Imin`

echo $the_date Cores $numCores MaxCores $numMaxCores >> $log_location

