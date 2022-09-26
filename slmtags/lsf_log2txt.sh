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

tmpStr=`badmin showstatus | grep Cores | cut -f 2 -d ":"`
numCores=`echo $tmpStr | cut -f 1 -d "/"`
numMaxCores=`echo $tmpStr | cut -f 2 -d "/"`
numServers=`echo $tmpStr | cut -f1 -d"/"`
numMaxServers=`echo $tmpStr | cut -f2 -d"/"`
numUsers=`badmin showstatus | grep "of users" | cut -f2 -d":"`
numActiveUsers=`badmin showstatus | grep "active users" | cut -f2 -d":"`
the_date=`date -Imin`

echo Servers $numServers  MaxServers $numMaxServers  Users $numUsers  ActiveUsers $numActiveUsers Cores $numCores  MaxCores $numMaxCores Date $the_date >> $log_location

echo Done
