#/bin/bash
########################################################################################
# Install this script as a crontab to log usage info for LSF Suite
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

tmp_str=`badmin showstatus | grep Servers | cut -f2 -d":"`
numServers=`echo $tmp_str | cut -f1 -d"/"`
numMaxServers=`echo $tmp_str | cut -f2 -d"/"`
numUsers=`badmin showstatus | grep "active users" | cut -f2 -d":"`
the_date=`date -Imin`

echo $the_date Servers $numServers MaxServers $numMaxServers Users $numUsers >> $log_location

