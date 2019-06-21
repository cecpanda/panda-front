# @(#) A.11.19.00 Date: 01/12/11 PHSS_41810 $
# **********************************************************************
# *                                                                    * 
# *        HIGH AVAILABILITY PACKAGE CONTROL SCRIPT (template)         * 
# *                                                                    *
# *       Note: This file MUST be edited before it can be used.        *
# *                                                                    *
# **********************************************************************

# The environment variables PACKAGE, NODE, SG_PACKAGE, 
# SG_NODE and SG_SCRIPT_LOG_FILE are set by Serviceguard 
# at the time the control script is executed.
# Do not set these environment variables yourself!
# The package may fail to start or halt if the values for
# these environment variables are altered.

# NOTE: Starting from 11.17, all environment variables set by 
# Serviceguard implicitly at the time the control script is
# executed will contain the prefix "SG_". Do not set any variable
# with the defined prefix, or the control script may not
# function as it should.

. ${SGCONFFILE:=/etc/cmcluster.conf}

# UNCOMMENT the variables as you set them.

# Set PATH to reference the appropriate directories.
PATH=$SGSBIN:/usr/bin:/usr/sbin:/etc:/bin

# VOLUME GROUP ACTIVATION: 
# Specify the method of activation for volume groups.
# Leave the default (VGCHANGE="vgchange -a e") if you want volume
# groups activated in exclusive mode. This assumes the volume groups have
# been initialized with 'vgchange -c y' at the time of creation.
#
# Uncomment the first line (VGCHANGE="vgchange -a e -q n"), and comment 
# out the default, if you want to activate volume groups in exclusive mode
# and ignore the disk quorum requirement. Since the disk quorum ensures 
# the integrity of the LVM configuration, it is normally not advisable
# to override the quorum.
#
# Uncomment the second line (VGCHANGE="vgchange -a e -q n -s"), and comment 
# out the default, if you want to activate volume groups in exclusive mode,
# ignore the disk quorum requirement, and disable the mirror 
# resynchronization. Note it is normally not advisable to override the 
# quorum.
#
# Uncomment the third line (VGCHANGE="vgchange -a s"), and comment
# out the default, if you want volume groups activated in shared mode. 
# This assumes the volume groups have already been marked as sharable
# and a part of a Serviceguard cluster with 'vgchange -c y -S y'.
#
# Uncomment the fourth line (VGCHANGE="vgchange -a s -q n"), and comment 
# out the default, if you want to activate volume groups in shared mode
# and ignore the disk quorum requirement. Note it is normally not 
# advisable to override the quorum.
#
# Uncomment the fifth line (VGCHANGE="vgchange -a y") if you wish to 
# use non-exclusive activation mode. Single node cluster configurations
# must use non-exclusive activation.
#
# VGCHANGE="vgchange -a e -q n"
# VGCHANGE="vgchange -a e -q n -s"
# VGCHANGE="vgchange -a s"
# VGCHANGE="vgchange -a s -q n"
# VGCHANGE="vgchange -a y"
VGCHANGE="vgchange -a e"		# Default


# CVM DISK GROUP ACTIVATION: 
# Specify the method of activation for CVM disk groups.
# Leave the default
# (CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=exclusivewrite")
# if you want disk groups activated in the exclusive write mode.
#
# Uncomment the first line
# (CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=readonly"),
# and comment out the default, if you want disk groups activated in
# the readonly mode.
#
# Uncomment the second line
# (CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=sharedread"),
# and comment out the default, if you want disk groups activated in the
# shared read mode.
#
# Uncomment the third line
# (CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=sharedwrite"),
# and comment out the default, if you want disk groups activated in the
# shared write mode.
#
# CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=readonly"
# CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=sharedread"
# CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=sharedwrite"
CVM_ACTIVATION_CMD="vxdg -g \$DiskGroup set activation=exclusivewrite" 
	       
# VOLUME GROUPS
# Specify which volume groups are used by this package. Uncomment VG[0]="" 
# and fill in the name of your first volume group. You must begin with 
# VG[0], and increment the list in sequence.
#
# For example, if this package uses your volume groups vg01 and vg02, enter:
#         VG[0]=vg01
#         VG[1]=vg02
#
# The volume group activation method is defined above. The filesystems
# associated with these volume groups are specified below.
#
#VG[0]=""

# CVM DISK GROUPS
# Specify which cvm disk groups are used by this package. Uncomment
# CVM_DG[0]="" and fill in the name of your first disk group. You must 
# begin with CVM_DG[0], and increment the list in sequence.
#
# For example, if this package uses your disk groups dg01 and dg02, enter:
#         CVM_DG[0]=dg01
#         CVM_DG[1]=dg02
#
# The cvm disk group activation method is defined above. The filesystems
# associated with these volume groups are specified below in the CVM_*
# variables.
#
#CVM_DG[0]=""

# NOTE: Do not use CVM and VxVM disk group parameters to reference
# devices used by CFS (cluster file system).  CFS resources are
# controlled by the Disk Group and Mount Multi-node packages.
# 
# VxVM DISK GROUPS
# Specify which VxVM disk groups are used by this package. Uncomment
# VXVM_DG[0]="" and fill in the name of your first disk group. You must 
# begin with VXVM_DG[0], and increment the list in sequence.
#
# For example, if this package uses your disk groups dg01 and dg02, enter:
#         VXVM_DG[0]=dg01
#         VXVM_DG[1]=dg02
#
# The cvm disk group activation method is defined above.
#
#VXVM_DG[0]=""

#
# NOTE: A package could have LVM volume groups, CVM disk groups and VxVM 
#       disk groups.
#
# NOTE: When VxVM is initialized it will store the hostname of the
#       local node in its volboot file in a variable called 'hostid'.
#       The Serviceguard package control scripts use both the values of
#       the hostname(1m) command and the VxVM hostid. As a result
#       the VxVM hostid should always match the value of the
#       hostname(1m) command.
#
#       If you modify the local host name after VxVM has been
#       initialized and such that hostname(1m) does not equal uname -n,
#       you need to use the vxdctl(1m) command to set the VxVM hostid
#       field to the value of hostname(1m). Failure to do so will
#       result in the package failing to start.

# VXVM DISK GROUP IMPORT RETRY
# For packages using VXVM disk groups, if the import of a VXVM
# disk group fails then this parameter allows you to specify if you want 
# to retry the import of disk group. Setting this parameter to "YES" will 
# execute the command "vxdisk scandisks" to scan for potentially missing 
# disks that might have caused the datagroup import to fail. This command
# can take a long time on a system which has a large IO subsystem.          
# The use of this parameter is recommended in a Metrocluster with EMC SRDF
# environment.                           
# The legal values are "YES" and "NO". The default value is "NO"
VXVM_DG_RETRY="NO"


# VOLUME GROUP AND DISK GROUP DEACTIVATION RETRY COUNT
# Specify the number of deactivation retries for each disk group and volume
# group at package shutdown. The default is 2.
DEACTIVATION_RETRY_COUNT=2


# RAW DEVICES
# If you are using raw devices for your application, this parameter allows
# you to specify if you want to kill the processes that are accessing the
# raw devices at package halt time. If raw devices are still being accessed
# at package halt time, volume group or disk group deactivation can fail,
# causing the package halt to also fail. This problem usually happens when
# the application does not shut down properly.
# Note that if you are using Oracle's Cluster Ready Service, killing this
# service could cause the node to reboot.
# The legal values are "YES" and "NO". The default value is "NO".
# The value that is set for this parameter affects all raw devices associated
# with the LVM volume groups and CVM disk groups defined in the package.
KILL_PROCESSES_ACCESSING_RAW_DEVICES="NO"

# FILESYSTEMS
# Filesystems are defined as entries specifying the logical volume, the
# mount point, the mount, umount and fsck options and type of the file system.
# Each filesystem will be fsck'd prior to being mounted. The filesystems 
# will be mounted in the order specified during package startup and will 
# be unmounted in reverse order during package shutdown. Ensure that 
# volume groups referenced by the logical volume definitions below are 
# included in volume group definitions above.
#
# Specify the filesystems which are used by this package. Uncomment 
# LV[0]=""; FS[0]=""; FS_MOUNT_OPT[0]=""; FS_UMOUNT_OPT[0]=""; FS_FSCK_OPT[0]=""
# FS_TYPE[0]="" and fill in the name of your first logical volume, 
# filesystem, mount, umount and fsck options and filesystem type 
# for the file system. You must begin with LV[0], FS[0],
# FS_MOUNT_OPT[0], FS_UMOUNT_OPT[0], FS_FSCK_OPT[0], FS_TYPE[0]
# and increment the list in sequence.
#
# Note: The FS_TYPE parameter lets you specify the type of filesystem to be 
# mounted. Specifying a particular FS_TYPE will improve package failover time.  
# The FSCK_OPT and FS_UMOUNT_OPT parameters can be used to include the 
# -s option with the fsck and umount commands to improve performance for 
# environments that use a large number of filesystems. (An example of a 
# large environment is given below following the decription of the 
# CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS parameter.)
#
# Example: If a package uses two JFS filesystems, pkg01a and pkg01b, 
# which are mounted on LVM logical volumes lvol1 and lvol2 for read and 
# write operation, you would enter the following:
#      LV[0]=/dev/vg01/lvol1; FS[0]=/pkg01a; FS_MOUNT_OPT[0]="-o rw";
#      FS_UMOUNT_OPT[0]=""; FS_FSCK_OPT[0]=""; FS_TYPE[0]="vxfs"
#
#      LV[1]=/dev/vg01/lvol2; FS[1]=/pkg01b; FS_MOUNT_OPT[1]="-o rw"
#      FS_UMOUNT_OPT[1]=""; FS_FSCK_OPT[1]=""; FS_TYPE[1]="vxfs"
#
#Nested mount points may also be configured
#
#LV[0]=""; FS[0]=""; FS_MOUNT_OPT[0]=""; FS_UMOUNT_OPT[0]=""; FS_FSCK_OPT[0]=""
#FS_TYPE[0]=""
#
# VOLUME RECOVERY
#
# When mirrored VxVM volumes are started during the package control
# bring up, if recovery is required the default behavior is for
# the package control script to wait until recovery has been
# completed.
#
# To allow mirror resynchronization to ocurr in parallel with
# the package startup, uncomment the line
# VXVOL="vxvol -g \$DiskGroup -o bg startall" and comment out the default.
#
# VXVOL="vxvol -g \$DiskGroup -o bg startall"
VXVOL="vxvol -g \$DiskGroup startall"      # Default

# FILESYSTEM UNMOUNT COUNT
# Specify the number of unmount attempts for each filesystem during package
# shutdown.  The default is set to 1.
FS_UMOUNT_COUNT=1

# FILESYSTEM MOUNT RETRY COUNT.
# Specify the number of mount retrys for each filesystem. 
# The default is 0. During startup, if a mount point is busy 
# and FS_MOUNT_RETRY_COUNT is 0, package startup will fail and 
# the script will exit with 1.  If a mount point is busy and
# FS_MOUNT_RETRY_COUNT is greater than 0, the script will attempt 
# to kill the user responsible for the busy mount point 
# and then mount the file system.  It will attempt to kill user and
# retry mount, for the number of times specified in FS_MOUNT_RETRY_COUNT.
# If the mount still fails after this number of attempts, the script
# will exit with 1.
# NOTE: If the FS_MOUNT_RETRY_COUNT > 0, the script will execute
# "fuser -ku" to freeup busy mount point.
FS_MOUNT_RETRY_COUNT=0

#
# Configuring the concurrent operations below can be used to improve the 
# performance for starting up or halting a package.  The maximum value for 
# each concurrent operation parameter is 1024.  Set these values carefully.  
# The performance could actually decrease if the values are set too high 
# for the system resources available on your cluster nodes.  Some examples 
# of system resources that can affect the optimum number of concurrent 
# operations are: number of CPUs, amount of available memory, the kernel 
# configuration for nfile and nproc. In some cases, if you set the number 
# of concurrent operations too high, the package may not be able to start
# or to halt.  For example, if you set CONCURRENT_VGCHANGE_OPERATIONS=5 
# and the node where the package is started has only one processor, then 
# running concurrent volume group activations will not be beneficial. 
# It is suggested that the number of concurrent operations be tuned 
# carefully, increasing the values a little at a time and observing the 
# effect on the performance, and the values should never be set to a value 
# where the performance levels off or declines.  Additionally, the values 
# used should take into account the node with the least resources in the 
# cluster, and how many other packages may be running on the node.  
# For instance, if you tune the concurrent operations for a package so 
# that it provides optimum performance for the package on a node while 
# no other packages are running on that node, the package performance 
# may be significantly reduced, or may even fail when other packages are 
# already running on that node.
#
# CONCURRENT VGCHANGE OPERATIONS
# Specify the number of concurrent volume group activations or
# deactivations to allow during package startup or shutdown. 
# Setting this value to an appropriate number may improve the performance
# while activating or deactivating a large number of volume groups in the
# package. If the specified value is less than 1, the script defaults it 
# to 1 and proceeds with a warning message in the package control script 
# logfile. 
CONCURRENT_VGCHANGE_OPERATIONS=1

#
# USE MULTI-THREADED VGCHANGE 
# Specify whether multi-threaded vgchange is to be used if available. 
# 0 means that the multi-threaded option is not to be used and 1 means 
# that the multi-threaded option is to be used. The default is set to 0.
# Multi-threaded vgchange has potential performance benefits. 
# If the activation order of the paths defined in lvmtab is important then
# multi-threaded vgchange should not be used. If mirrored volume groups
# are synced during activation then using multi-threaded vgchange may
# worsen performance. 
# Using the multi-threaded vgchange option can improve the activation 
# performance of volume groups with multiple disks. 
# CONCURRENT_VGCHANGE_OPERATIONS option is beneficial when mutiple 
# volume groups need to be activated. To get the best performance for 
# volume group activation, use the multi-threaded vgchange option in 
# combination with the CONCURRENT_VGCHANGE_OPERATIONS option.
ENABLE_THREADED_VGCHANGE=0

# CONCURRENT FSCK OPERATIONS
# Specify the number of concurrent fsck to allow during package startup. 
# Setting this value to an appropriate number may improve the performance
# while checking a large number of file systems in the package. If the
# specified value is less than 1, the script defaults it to 1 and proceeds 
# with a warning message in the package control script logfile. 
CONCURRENT_FSCK_OPERATIONS=1

# CONCURRENT MOUNT AND UMOUNT OPERATIONS
# Specify the number of concurrent mounts and umounts to allow during 
# package startup or shutdown. 
# Setting this value to an appropriate number may improve the performance
# while mounting or un-mounting a large number of file systems in the package.
# If the specified value is less than 1, the script defaults it to 1 and
# proceeds with a warning message in the package control script logfile. 
CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS=1

# Example:  If a package uses 50 JFS filesystems, pkg01aa through pkg01bx,
# which are mounted on the 50 logical volumes lvol1..lvol50 for read and write 
# operation, you may enter the following:
#
#      CONCURRENT_FSCK_OPERATIONS=50
#      CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS=50
#
#      LV[0]=/dev/vg01/lvol1; FS[0]=/pkg01aa; FS_MOUNT_OPT[0]="-o rw";
#      FS_UMOUNT_OPT[0]="-s"; FS_FSCK_OPT[0]="-s"; FS_TYPE[0]="vxfs"
#
#      LV[1]=/dev/vg01/lvol2; FS[1]=/pkg01ab; FS_MOUNT_OPT[1]="-o rw"
#      FS_UMOUNT_OPT[1]="-s"; FS_FSCK_OPT[1]="-s"; FS_TYPE[0]="vxfs"
#         :           :          :
#         :           :          :
#         :           :          :
#      LV[49]=/dev/vg01/lvol50; FS[49]=/pkg01bx; FS_MOUNT_OPT[49]="-o rw"
#      FS_UMOUNT_OPT[49]="-s"; FS_FSCK_OPT[49]="-s"; FS_TYPE[0]="vxfs"
#
# IP ADDRESSES
# Specify the IP and Subnet address pairs which are used by this package.
# You could specify IPv4 or IPv6 IP and subnet address pairs.
# Uncomment IP[0]="" and SUBNET[0]="" and fill in the name of your first
# IP and subnet address. You must begin with IP[0] and SUBNET[0] and 
# increment the list in sequence.
#
# For example, if this package uses an IP of 192.10.25.12 and a subnet of 
# 192.10.25.0 enter:
#          IP[0]=192.10.25.12 
#          SUBNET[0]=192.10.25.0
#          (netmask=255.255.255.0)
#
# Hint: Run "netstat -i" to see the available subnets in the Network field.
#
# For example, if this package uses an IPv6 IP of 2001::1/64 
# The address prefix identifies the subnet as 2001::/64 which is an available
# subnet.
# enter:
#          IP[0]=2001::1
#          SUBNET[0]=2001::/64
#          (netmask=ffff:ffff:ffff:ffff::)
# Alternatively the IPv6 IP/Subnet pair can be specified without the prefix 
# for the IPv6 subnet.
#          IP[0]=2001::1
#          SUBNET[0]=2001::
#          (netmask=ffff:ffff:ffff:ffff::)
#
# Hint: Run "netstat -i" to see the available IPv6 subnets by looking
# at the address prefixes
# IP/Subnet address pairs for each IP address you want to add to a subnet 
# interface card.  Must be set in pairs, even for IP addresses on the same
# subnet.
#
IP[0]=10.53.144.11
SUBNET[0]=10.53.144.0

# SERVICE NAMES AND COMMANDS.
# Specify the service name, command, and restart parameters which are 
# used by this package. Uncomment SERVICE_NAME[0]="", SERVICE_CMD[0]="",
# SERVICE_RESTART[0]="" and fill in the name of the first service, command,
# and restart parameters. You must begin with SERVICE_NAME[0], SERVICE_CMD[0],
# and SERVICE_RESTART[0] and increment the list in sequence.
#
# For example:
#          SERVICE_NAME[0]=pkg1a 
#          SERVICE_CMD[0]="/usr/bin/X11/xclock -display 192.10.25.54:0"
#          SERVICE_RESTART[0]=""  # Will not restart the service.
#
#          SERVICE_NAME[1]=pkg1b
#          SERVICE_CMD[1]="/usr/bin/X11/xload -display 192.10.25.54:0"
#          SERVICE_RESTART[1]="-r 2"   # Will restart the service twice.
#
#          SERVICE_NAME[2]=pkg1c
#          SERVICE_CMD[2]="/usr/sbin/ping"
#          SERVICE_RESTART[2]="-R" # Will restart the service an infinite 
#                                    number of times.
#
# Note: No environmental variables will be passed to the command, this 
# includes the PATH variable. Absolute path names are required for the
# service command definition.  Default shell is /usr/bin/sh.
#
#SERVICE_NAME[0]=""
#SERVICE_CMD[0]=""
#SERVICE_RESTART[0]=""

SERVICE_NAME[0]=srv_eq
SERVICE_CMD[0]="/etc/cmcluster/pkg_eq/mon_pkg_eq.sh monitor"
SERVICE_RESTART[0]=""

# DEFERRED_RESOURCE NAME
# Specify the full path name of the 'DEFERRED' resources configured for
# this package.  Uncomment DEFERRED_RESOURCE_NAME[0]="" and fill in the
# full path name of the resource.
#
#DEFERRED_RESOURCE_NAME[0]=""
       
# DTC manager information for each DTC.
# Example: DTC[0]=dtc_20
#DTC_NAME[0]=
       
# HA_NFS_SCRIPT_EXTENSION
# If the package uses HA NFS, this variable can be used to alter the
# name of the HA NFS script.  If not set, the name of this script is
# assumed to be "hanfs.sh".  If set, the "sh" portion of the default
# script name is replaced by the value of this variable.  So if
# HA_NFS_SCRIPT_EXTENSION is set to "package1.sh", for example, the name
# of the HA NFS script becomes "hanfs.package1.sh".  In any case,
# the HA NFS script must be placed in the same directory as the package
# control script.  This allows multiple packages to be run out of the
# same directory, as needed by SGeSAP.
#HA_NFS_SCRIPT_EXTENSION=""
 
# Setting the log file
log_file=${SG_SCRIPT_LOG_FILE:-$0.log}

# START OF CUSTOMER DEFINED FUNCTIONS

# This function is a place holder for customer define functions.
# You should define all actions you want to happen here, before the service is
# started.  You can create as many functions as you need.  

function customer_defined_run_cmds
{
# ADD customer defined run commands.
: # do nothing instruction, because a function must contain some command.

	test_return 51
}
       
# This function is a place holder for customer define functions.
# You should define all actions you want to happen here, after the service is
# halted.

function customer_defined_halt_cmds
{
# ADD customer defined halt commands.
: # do nothing instruction, because a function must contain some command.


	test_return 52
}
       
# END OF CUSTOMER DEFINED FUNCTIONS
       

# START OF RUN FUNCTIONS

###############################################################
#  This function checks for the existence of MetroCluster or
# ContinentalClusters packages that use physical data
# replication via Continuous Access XP on HP SureStore XP
# series disk arrays or SRDF on EMC Symmetrix disk arrays.
#
#  If the /usr/sbin/DRCheckDiskStatus file exists in the system,
# then the cluster has at least one package which will be
# configured for remote data mirroring in a metropolitan or
# continental cluster.
#
#  The function is called before attempting to activate the
# volume group. If no /usr/sbin/DRCheckDiskStatus file exists,
# the function does nothing.
#
###############################################################
#                                                                              
function verify_physical_data_replication
{
if [[ -x /usr/sbin/DRCheckDiskStatus ]]
then
    /usr/sbin/DRCheckDiskStatus "${0}" "${VGCHANGE}" "${CVM_ACTIVATION_CMD}" "${VG[*]}" "${CVM_DG[*]}" "${VXVM_DG[*]}"

    exit_val=$?
    if [[ $exit_val -ne 0 ]]
    then
        exit $exit_val
    fi                
fi
}

##############################################################
# This function tests whether the package is using HA NFS or
# not.  If the HA NFS script file exists in the
# package directory then the package will be configured for
# use with HA NFS and the script will be executed.
#
# This function has one parameter passed to it, which then
# be passed to the hanfs.sh script:
#
# - start - to indicate the package is starting up
# - stop  - to indicate the package is shutting down
#
###############################################################
#
HA_NFS_SCRIPT="${0%/*}/hanfs.${HA_NFS_SCRIPT_EXTENSION:-sh}"

function verify_ha_nfs
{

if [[ -x $HA_NFS_SCRIPT ]]
then

    #
    # The hanfs.sh script has the return values as follow:
    #
    #   0 - success              
    #   1 - fails
    #

    if [[ $1 = "start" ]]
    then
     $HA_NFS_SCRIPT $1
     test_return 49
    else
     $HA_NFS_SCRIPT $1
     test_return 50
    fi
fi
}

##############################################################
# This function is used to migrate nfs file locks if that
# functionality is available on the system. The HA_NFS_SCRIPT
# is called with its lock migration option.
###############################################################
#
function ha_nfs_file_locks
{
if [[ -x $HA_NFS_SCRIPT ]]
then

    $HA_NFS_SCRIPT file_lock_migration

    #
    # The hanfs.sh script has the return values as follow:
    #
    #   0 - success              
    #   1 - fails
    #
    test_return 53
fi
}

function activate_volume_group
{
integer index=0
integer i
integer j
set -A VGS ${VG[@]}
integer num_vgs=${#VGS[*]}

typeset pids_list
typeset volume_list

# Perform parallel volume group activations for better performance.
# Limit the number of parallel activations to specified 
# CONCURRENT_VGCHANGE_OPERATIONS
while (( index < num_vgs ))
do
        j=0
        while (( j < CONCURRENT_VGCHANGE_OPERATIONS && index < num_vgs ))
        do
           I=${VGS[$index]}
           if [[ "${VGCHANGE##*vgchange -a e}" != "${VGCHANGE}" ]]
	   then
        	print "$(date '+%b %e %X') - Node \"$(hostname)\": Activating volume group $I with exclusive option." 
           elif [[ "${VGCHANGE##*vgchange -a s}" != "${VGCHANGE}" ]]
           then
        	print "$(date '+%b %e %X') - Node \"$(hostname)\": Activating volume group $I with shared option." 
	   else
        	print "$(date '+%b %e %X') - \"$(hostname)\": Activating volume group $I with non-exclusive option." 
	   fi
	   (
           $VGCHANGE $I 
           ) &
           # save the process id and name of VG, used while checking exit status
	   pids_list[$j]="$!"
           volume_list[$j]=$I
           (( j = j + 1 ))
           (( index = index + 1 ))
         done
      
         # wait for background vg activations to finish
         # I is used by "test_return 1"
         while (( j > 0 ))
         do
             pid=${pids_list[$j-1]}
             I=${volume_list[$j-1]}
             wait $pid
             if (( $? != 0 ))
             then
                 let 0
                 test_return 1
             fi
             (( j = j - 1 ))
         done 

         # Check exit value (set if any proceeding vgchange calls failed)
         if (( $exit_value == 1 ))
         then
		deactivate_volume_group
                print "\n\t########### Node \"$(hostname)\": Package start failed at $(date) ###########"
		exit 1
         fi
done

# If the -s option has been specified, then we perform
# the resynchronization as a background task
#
if [[ ${VGCHANGE#*-s} != ${VGCHANGE} ]]
then
    index=0
    while (( index < num_vgs ))
    do
        I=${VGS[$index]}
        (
        if /sbin/vgsync $I
        then
		print "$(date '+%b %e %X') - Node \"$(hostname)\": Resynchronized volume group $I"
        else
                print "$(date '+%b %e %X') - Node \"$(hostname)\": Resynchronization of volume group $I encountered an error"
        fi
        ) &
        (( index = index + 1 ))
    done
fi
}

function activate_disk_group
{
typeset -i retval
typeset DiskGroup

for I in ${CVM_DG[@]}
do
	if [[ ${CVM_ACTIVATION_CMD} = *exclusivewrite ]]
	then
        	print "$(date '+%b %e %X') - \"$(hostname)\": Activating disk group $I with exclusive option."
	else
        	print "$(date '+%b %e %X') - Node \"$(hostname)\": Activating disk group $I with non-exclusive option."
	fi

	# The vxdg command requires a disk group parameter, specified
	# with the -g option. This option preceeds the activation
	# parameter. So the CVM_ACTIVATION_CMD command contains a
	# variable (DiskGroup)
	# that we will set now and evaluated at vxdg runtime. To do
	# this we will now set the $DiskGroup variable and execute 
	# vxdg with the eval command.
	DiskGroup=$I
	eval $CVM_ACTIVATION_CMD
	test_return 21

done

for I in ${VXVM_DG[@]}
do
        print "$(date '+%b %e %X') - \"$(hostname)\": Importing disk group $I."

	# If the disk group is already imported on this node,
	# check_dg will return 10. Then we can skip the vxdg import
	# since that would fail anyway.

        check_dg $I
	retval=$?
        typeset -i cnt=0
        typeset ret_str
        typeset -i ret_cmd_val
        typeset msg
        typeset vxdg_scan

	if (( retval > 1 )) && (( retval != 10 )); then
		let 0
		test_return 22
	fi
        if (( retval != 10 )) && (( retval != 1 )); then
                msg=`vxdg -tfC import $I 2>&1`
                ret_cmd_val=$?
        fi

        if [ ! -z "$(print "$msg" | grep -i 'WARNING')" ]
        then
                vxdg_scan="YES"
        else
                vxdg_scan="NO"
        fi


        if  [[ $VXVM_DG_RETRY = "YES" && $retval -ne 10 ]]; then
             if [[ $ret_cmd_val -ne 0 || $vxdg_scan = "YES" ]]; then
                  print "$(date '+%b %e %X') - \"$(hostname)\": Import of $I failed, trying again."

                  VXVM_DG_RETRY="NO"
                  ret_str=$(UNIX95=1 ps -C vxdisk -f | awk '
                         /vxdisk scandisks/ { if ("root" == $1) { print $1; exit } }')
                  while [[ $ret_str = "root" ]]
                  do
                      cnt=$cnt+1
                      if (( $cnt % 5 == 0 )); then
                          print "\n Waiting for the command vxdisk scandisks to be completed."
                      fi
                      sleep 2
                      ret_str=$(UNIX95=1 ps -C vxdisk -f | awk '
                             /vxdisk scandisks/ { if ("root" == $1) { print $1; exit } }')
                  done

                  if (( $cnt == 0 )); then
                      vxdisk scandisks
                  fi

                  check_dg $I
	          retval=$?

	          if (( retval > 0 )) && (( retval != 10 )); then
		         let 0
		         test_return 22
	          fi
	          if (( retval != 10 )); then
		         vxdg -tfC import $I
	          fi
             fi
        fi

	test_return 23

	DiskGroup=$I
        eval $VXVOL
	test_return 24
done
}

########################################################################
# This function waits for the specified cvm disk group/volumes to
# enable. This is added for the defect JAGaf74126, where the packages are
# started before cvm disk groups get enabled.
#
########################################################################
function wait_for_cvm_dg_vols_enabled
{
typeset -i ret_val
typeset -i flag
typeset curr_kstate
typeset tmp_kstate

for I in ${CVM_DG[@]}
do
    for k in `vxprint -v -q -g $I | awk '{print $2}'`
    do
        flag=1
        tmp_kstate=DISABLED
        while [[ $tmp_kstate = "DISABLED" ]]
        do
            curr_kstate=$(/usr/sbin/vxprint -g $I -F %kstate $k)
            ret_val=$?
            if (( $ret_val == 0 ))
            then
                if [[ $curr_kstate = "DISABLED" ]]
                then
                    if (( $flag == 1 ))
                    then
                        print "$(date '+%b %e %X') - $k in $I is $curr_kstate, waiting for it to be ENABLED."
                        flag=0
                    fi
                    sleep 5
                else
                    tmp_kstate=$curr_kstate
                fi
            else
                let 0
                test_return 7
            fi
        done
     done
done
}

#################################
# This function will exits with 
# an error if the volume group
# is already activated by another
# node.
##################################
function check_dg
{
    typeset -i retval=0
    vg=$1
    hostid=""
    disk=""

    vxdisk -s list > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
       print "check_dg: Error in vxdisk"
       return 1 
    fi

    #get the disk

    disk=$(vxdisk -s list | awk -v vg=$1 '
           /^Disk:/   { disk = $2 }
           /^dgname:/ { if (vg == $2) { print disk; exit } }')

    if [ "$disk" = "" ] ; then
        print "check_dg: Error $vg does not have any disk"
        return 1
    fi
   
    #get the hostids in the  vg 

    hostid=$(vxdisk list $disk | awk  '/^hostid:/ { print $2; exit }')

    #get the hostname of the node  
    host=$(hostname)
    if [ $? -ne 0 ] ; then
       print "check_dg: Error in getting the hostname"
       return 1
    fi
   
    #check hostid
    if [ "$hostid" != "" ] ; then 

        status=""
  
        if [ $host != $hostid ] ; then

           #get status of node
           status=$(cmviewcl -n $hostid | sed -n "s/^  $hostid[ ]*[a-z]*[ ]*//p")
           if [ -z "$status" ] ; then
              #try again  
              status=$(cmviewcl -n $hostid | sed -n "s/^  $hostid[ ]*[a-z]*[ ]*//p")
              if [ -z "$status" ] ; then
                 #give up
                 print "check_dg: Error in cmviewcl" 
                 return 1
              fi
            fi

            case $status in
                *ailed*) 
                   print "check_dg: $hostid status failed..okay to activate $vg" 
                   ;;
                *) cmviewcl 
                print "check_dg: Error $vg may still be imported on $hostid"
                print ""
                print "To correct this situation, logon to \"$hostid\" and  "
                print "execute the following command:"
                print "   vxdg deport $vg"
                print ""
                print "Once \"$vg\" has been deported from \"$hostid\", "
                print "this package may be restarted via either cmmodpkg(1M)"
                print "or cmrunpkg(1M)."
                print ""
                print "In the event that \"$hostid\" is either powered off"
                print "or unable to boot, then \"$vg\" must be force "
                print "imported. "
                print ""
                print "******************* WARNING **************************"
                print ""
                print "The use of force import can lead to data corruption if"
                print "\"$hostid\" is still running and has \"$vg\""
                print "imported. It is imperitive to positively determine that"
                print "\"$hostid\" is not running prior to performing the force"
                print "import. See \"-C\" option on vxdg(1M)."
                print ""
                print "*******************************************************"
                print ""
                print "To force import \"$vg\", execute the following"
                print "commands on the local system:"
                print "   vxdg -tfC import $vg"
                print "   vxdg deport $vg"
                print ""
                   return 2;;
            esac

	else
		retval=10
        fi
        #checking one hostid is enough
        break;

    fi 
    return $retval
}

function ps_tree {
    typeset pid=$1
    typeset ppid
    typeset cmd
    typeset err=0
    typeset prefix=""
    typeset spaces=""
    while (( pid != 1 && pid != 0 && err == 0))
    do
        cmd=
        UNIX95=1 ps -p $pid -oppid= -oargs= 2>/dev/null | read ppid cmd
        err=$?
        if (( err == 0 ))
        then
            echo "${prefix}$pid: $cmd"
            (( pid = ppid ))
        else
            echo "${prefix}$pid: <command unavailable>"
        fi
        spaces="${spaces} "
        prefix="${spaces}child of "
    done
}

function show_users {
    typeset dev=$1
    [[ -z "$dev" ]] && return
    typeset pids=$(fuser $dev 2> /dev/null)
    [[ -z "$pids" ]] && return
    echo "$dev in use by:"
    typeset pid
    for pid in $pids
    do
        ps_tree $pid
    done
}

#This function is used to kill the user to freeup a mountpoint
#that could be busy and then do the mount operation.
#freeup_busy_mountpoint_and_mount_fs(x, y, z) 
#	x  =  Logical volume group to be mounted.
#	y  =  File System where the logical volume is to be mounted.
#       z  =  Mount Options to be used for mount operation
#
function freeup_busy_mountpoint_and_mount_fs
{

typeset vol_to_mount
typeset mount_pt
typeset fs_mount_opt

vol_to_mount=$1
mount_pt=$2
shift 2
fs_mount_opt=$*

print "\tWARNING:   Running fuser on ${mount_pt} to remove anyone using the busy mount point directly."
UM_COUNT=0 
RET=1

# The control script exits, if the mount failed after 
# retrying FS_MOUNT_RETRY_COUNT times. 

while (( $UM_COUNT < $FS_MOUNT_RETRY_COUNT && $RET != 0 ))
do
    (( UM_COUNT = $UM_COUNT + 1 ))
    fuser -ku ${mount_pt}
    if (($UM_COUNT == $FS_MOUNT_RETRY_COUNT))
    then
        mount ${fs_mount_opt} ${vol_to_mount} ${mount_pt}
        (( RET = $? ))
        if(( $RET != 0 ))
        then
            print "\tERROR:  Function freeup_busy_mountpoint_and_mount_fs"
            print "\tERROR:  Failed to mount ${vol_to_mount} to ${mount_pt}"
            break
        fi
    else
        mount ${fs_mount_opt} ${vol_to_mount} ${mount_pt}
        (( RET = $? ))
        sleep 1
    fi
done
return $RET
}

 
function check_vxvm_vol_available
{
    typeset volpath
    volpath=$1
     

    VOL=${volpath##*/} 
    TMP=${volpath%/*} 
    DG=${TMP##*/} 
    vol_kstate=$(vxprint -g $DG -F %kstate $VOL)
    TMP=$?
    if(( $TMP != 0 ))
    then
	print "\tERROR:  Function check_vxvm_vol_available"
	print "\tERROR:  vxprint -g $DG -F %kstate $VOL"
	print "\tERROR:  Failed to get KSTATE for \"${volpath}\" See vxintro(1M) for EXIT CODE of $TMP."
	exit_value=1
        return 0
    fi
 
    if [[  $vol_kstate = "ENABLED" ]]
    then
        return 0
    fi
    print "$(date '+%b %e %X') - Node \"$(hostname)\": KSTATE for \"${volpath}\" is ${vol_kstate}."
    return 1
}                              

#mount ${FS_MOUNT_OPT[$F]} $I ${FS[$F]}

function sort_fs_directories
{
     typeset -i r=0
     typeset -i i=0
     typeset -i a=0
     typeset indexes
     typeset num_of_comp
     typeset Y
     typeset X
     typeset dirnm
     typeset temp
     typeset temp1
     typeset -i j


    while (( $a < ${#FS[*]} ))
    do
        (( indexes[a] = $a ))
        (( mnt_order[a] = 1 ))

        #Make sure all the mnt points end with a / for uniformity
        Y=${FS[a]}
        if [[ ${Y%/} = $Y ]]
        then
            Y=$Y/
        fi
        dirnm=$Y
         # Calculate number of components in the moint point path
        (( num_of_comp[a] = $(echo $dirnm | awk -F "/" '{print NF}') ))
        (( a = a + 1 ))
    done


    ((i=0))
    ((temp=0))
    ((temp1=0))

    #sort num_of_comp[*] and save the indexes as we have to
    #with FS and FS_options arrays

    while ((i<${#num_of_comp[*]}))
    do
        ((j=i+1))
        while ((j < ${#num_of_comp[*]}))
        do
            if (( ${num_of_comp[i]} > ${num_of_comp[j]} ))
            then
                temp=${num_of_comp[i]}
                num_of_comp[i]=${num_of_comp[j]}
                num_of_comp[j]=$temp

                temp1=${indexes[i]}
                indexes[i]=${indexes[j]}
                indexes[j]=$temp1
            fi
            ((j=j+1))
        done
        ((i=i+1))
    done

    #Loop through all the elements starting from the last
    #element to the first to find out if subcomponents of
    #it need to be mounted before this can be mounted.

    (( max_mnt_order = 1 ))
    ((i=${#indexes[*]} - 1))
    while ((i>-1))
    do
        X=${FS[${indexes[i]}]}
        ((j=0))
        while ((j<i))
        do
            Y=${FS[${indexes[j]}]}

            #See if $Y is a substring of $X
            if [[ ${X#$Y} = $X ]]
            then
                ((j=j+1))
            else
                #If $Y is a substring  of $X it means $Y is parent
                #of $X. So, $X needs to be mounted after $Y. So, increment
                #corresponding mnt_order[] element by 1.

                ((mnt_order[${indexes[i]}]=${mnt_order[${indexes[i]}]}+1))
                if (( ${mnt_order[${indexes[i]}]} > $max_mnt_order ))
                then
                    (( max_mnt_order = max_mnt_order + 1 ))
                fi
                ((j=j+1))
            fi
        done
        ((i=i-1))
    done
}


      
# For each {file system/logical volume} pair, fsck the file system
# and mount it. 
# If the mount point is busy and if FS_MOUNT_RETRY_COUNT = 0, 
# mounting of the file system will fail and the control script
# will exit with an error.
# 
function check_and_mount
{

typeset pids_list
integer NOT_READY=1
typeset mnt_order
typeset -i total_mnts
typeset -i cur_ord
typeset -i mnts_processed
typeset -i mnts_identified
typeset I


while (( $NOT_READY != 0 ))
do
    NOT_READY=0
    integer R=0
    for I in ${LV[@]}
    do
	if [[ $(mount -p | awk '$1 == "'$I'"') = "" ]]
	then
           case $I in
              */dev/vx/dsk*)
                  check_vxvm_vol_available $I
                  if(( $? != 0 ))
                  then       
                      NOT_READY=1
                  else
                      RLV[$R]=$(print $I | sed -e 's/dsk/rdsk/')
                  fi
                  ;;
              *)
		  RLV[$R]="${I%/*}/r${I##*/}"
                  ;;
           esac

           (( R = $R + 1 ))
	fi
    done
    if(( $NOT_READY != 0 ))
    then
        sleep 5
    fi
done

# Verify that there is at least one file system to check.
if [[ "$exit_value" != 1  &&  ${RLV[@]} != "" ]] 
then
	print -n "$(date '+%b %e %X') - Node \"$(hostname)\": "
	print "Checking filesystems:"
	print ${LV[@]} | tr ' ' '\012' | sed -e 's/^/   /'

        # Perform parallel fsck's for better performance.
        # Limit the number of concurrent fsck's to CONCURRENT_FSCK_OPERATIONS
        R=0
	while (( R < ${#RLV[*]} ))
	do
            j=0
            while (( j < CONCURRENT_FSCK_OPERATIONS  && R < ${#RLV[*]} ))
            do

                ( case ${FS_TYPE[$R]} in
   
		  hfs) fsck -F ${FS_TYPE[$R]} ${FS_FSCK_OPT[$R]} -P ${RLV[$R]}
                       ;;
   
		 vxfs) fsck -F ${FS_TYPE[$R]} ${FS_FSCK_OPT[$R]} -p -y ${RLV[$R]}
		       ;;
   
                 unk*) fsck ${FS_FSCK_OPT[$R]} ${RLV[$R]}
                       ;;
                             
                    *) if [[ ${FS_TYPE[$R]} = "" ]]
                       then
                            fsck ${FS_FSCK_OPT[$R]} ${RLV[$R]}
                       else 
                            fsck -F ${FS_TYPE[$R]} ${FS_FSCK_OPT[$R]} ${RLV[$R]}
                       fi   
                       ;;

		    esac ) &

                    # save the process id for monitoring the status
		    pids_list[$j]="$!"
                    (( j = j + 1 ))
		    (( R = R + 1 ))
              done

              # wait for background fsck's to finish
              while (( j > 0 ))
              do
                     pid=${pids_list[$j-1]}
                     wait $pid
                     if (( $? != 0 ))
                     then
                          let 0
                          test_return 2
                     fi
                     (( j = j - 1 ))
              done
	 done

         # Check exit value (set if any preceeding fsck calls failed)
         if (( $exit_value == 1 ))
         then
	       deactivate_volume_group
	       deactivate_disk_group
	       print "\n\t########### Node \"$(hostname)\": Package start failed at $(date) ###########"
	       exit 1 
         fi
fi

sort_fs_directories
#Total number of mounts to do
(( total_mnts = ${#mnt_order[*]} ))

#Current order of mount being processed
(( cur_order = 1 ))
#Used to keep track how many mounts are
# completed
(( mnts_processed = 0 ))

#Number of mounts being done in one iteration
(( mnts_identified = 0 ))


print "\n\t mnt order: ${mnt_order[*]}"
 #Variable to loop through mount point array
integer F=0
integer j
set -A LogicalVolumes ${LV[@]}
integer L=${#LogicalVolumes[*]}

typeset volume_list

while (( mnts_processed < total_mnts ))
do
    (( mnts_identified = 0 ))
     #If we have gone through all the
     #list then we can process next level of mounts

    if (( $F == $total_mnts ))
    then
	(( cur_order = cur_order + 1 ))
	(( F = 0 ))
    fi
    while (( mnts_identified  < CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS \
		    && F < total_mnts ))
    do
       if (( ${mnt_order[$F]} == $cur_order ))
       then
           I=${LogicalVolumes[$F]}
           if [[ $(mount | grep -e $I" ") = "" ]]
           then
	       print "$(date '+%b %e %X') - Node \"$(hostname)\": Mounting $I at ${FS[$F]}" 

               case ${FS_TYPE[$F]} in

                   unk*) # Don't alter fsck/mount options.
                         ;;

                      *) if [[ ${FS_TYPE[$F]} != "" ]]
                         then
                              FS_MOUNT_OPT[$F]="-F ${FS_TYPE[$F]} ${FS_MOUNT_OPT[$F]}"
                         fi
                         ;;
               esac

               # Perform parallel file system mounts for better performance.
               # Limit the number of parallel mounts to 
               # CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS

   	       # if there is permission to kill the user, we can 
	       # run fuser to kill the user, on the mount point.
               # This would freeup the mount point, if it is busy
	       	
	       if (( $FS_MOUNT_RETRY_COUNT > 0 ))
	       then	
                     (
                      mount ${FS_MOUNT_OPT[$F]} $I ${FS[$F]}                 
                      if (( $? != 0 ))
                      then
                            freeup_busy_mountpoint_and_mount_fs \
                            $I ${FS[$F]} ${FS_MOUNT_OPT[$F]}
                            (( RET = $? ))
                            return $RET
                      fi
                     ) &
               else
                       (
                       mount ${FS_MOUNT_OPT[$F]} $I ${FS[$F]}
                       ) &
               fi

               # save the process id and volume name for monitoring status
               pids_list[$mnts_identified]="$!"
               volume_list[$mnts_identified]=$I
           else
	       print "$(date '+%b %e %X') - Node \"$(hostname)\": WARNING:  File system \"${FS[$F]}\" was already mounted." 
           fi
           (( mnts_identified = mnts_identified + 1 ))
           (( mnts_processed = mnts_processed + 1 ))
        fi #new
	   (( F = F + 1 ))
        done

    # wait for background mounts to finish
    # I is used by "test_return 3"
    while (( mnts_identified > 0 ))
    do
        pid=${pids_list[$mnts_identified-1]}
        I=${volume_list[$mnts_identified-1]}
        wait $pid
        if (( $? != 0 ))
        then
             let 0
             test_return 3
         fi
         (( mnts_identified = mnts_identified - 1 ))
    done 

    # Check exit value (set if any preceeding mount calls failed)
    if (( $exit_value == 1 ))
    then
        umount_fs
        deactivate_volume_group
        deactivate_disk_group
        print "\n\t########### Node \"$(hostname)\": Package start failed at $(date) ###########"
        exit 1
    fi
done
}

function retry_print
{

if [[ $(echo $1 | grep "Retrying") != "" ]]
then
    print "$1" >> $log_file
fi

}
       
# For each {IP address/subnet} pair, add the IP address to the subnet
# using cmmodnet(1m).
       
function add_ip_address
{
integer S=0
integer error=0
typeset -i retval=0

for I in ${IP[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Adding IP address $I to subnet ${SUBNET[$S]}"
	XX=$( cmmodnet -a -i $I ${SUBNET[$S]} 2>&1 )
        retval=$?
	if (( retval != 0 ))
	then
                if [[ $(echo $XX | grep "heartbeat IP") != "" ]]
                then
                        # IP has been configured as a heartbeat IP address.
                        print "$XX" >> $log_file
                        (( error = 1 ))
                else
                        
                        # Look for the IP address in the 4th column of netstat -in output.
                        # If "IPv6:" keyword is present in the output, start looking for it
                        # in the 3rd column since IPv6 addresses are shown in the 3rd column.

                        YY=$(netstat -in | sed 's,/[0-9][0-9]*,,' |
                             awk -v f=4 '$f == "'${I%/*}'" { print } $1 == "IPv6:"{ f-- }')
                        if [[ -z $YY ]]
                        then
                                print "$XX" >> $log_file
                                print "\tERROR:  Failed to add IP $I to subnet ${SUBNET[$S]}"
                                (( error = 1 ))
                        else
                                retry_print "$XX"
                                print "\tWARNING:  IP $I is already configured on the subnet ${SUBNET[$S]}"
                        fi
                fi
        else
            retry_print "$XX"
	fi
	(( S = $S + 1 ))
done

if (( error != 0 ))
then

# `let 0` is used to set the value of $? to 1. The function test_return 
# requires $? to be set to 1 if it has to print error message.

        let 0
        test_return 4
fi

}
       
# Own and reset the DTC connections
       
function get_ownership_dtc
{
for I in ${DTC_NAME[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Assigning Ownership of the DTC $I"
	dtcmodifyconfs -o $I
	test_return 5
       
	for J in ${IP[@]}
	do
		print "$(date '+%b %e %X') - Node \"$(hostname)\": Resetting the DTC connections to IP address $J"
		dtcdiag -Q $J -q -f $I
		test_return 6
	done
done
}


# For each {service name/service command string} pair, start the
# service command string at the service name using cmrunserv(1m).

function start_services
{
integer C=0
for I in ${SERVICE_NAME[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Starting service $I using"
	print "   \"${SERVICE_CMD[$C]}\""
            #
            # Check if cmrunserv should be called the old
            # way without a restart count.
            #
	if [[ "${SERVICE_RESTART[$C]}" = "" ]]
	then
	    cmrunserv $I ">> $log_file 2>&1 ${SERVICE_CMD[$C]}"
	else
	    #
            # Do not attempt to restart when SERVICE_CMD does not exists or
            # does not have executable permission(JAGag12644)
            # Extract the service script name first from the SERVICE_CMD
            # and then check for the execute permission
            #
            if [[ -d ${SERVICE_CMD[$C]%% *} ]] || [[ ! -x ${SERVICE_CMD[$C]%% *} ]]
	    then
	        print "\tWARNING:  Service command ${SERVICE_CMD[$C]%% *} does not exist or is not executable."
	        print "\tWARNING:  Ignoring configured SERVICE_RESTART value, and starting the service without any restart."
                
	        cmrunserv $I ">> $log_file 2>&1 ${SERVICE_CMD[$C]}"
	    else
	        cmrunserv ${SERVICE_RESTART[$C]} $I ">> $log_file 2>&1 ${SERVICE_CMD[$C]}"
	    fi
	fi
	test_return 8
	(( C = $C + 1 ))
done
}


# For each {deferred resource name}, start resource monitoring for this
# resource using cmstartres(1m).

function start_resources
{
for I in ${DEFERRED_RESOURCE_NAME[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Starting resource monitoring for $I"
	cmstartres -u -p $PACKAGE $I >> $log_file 2>&1
	test_return 15
done
}

# END OF RUN FUNCTIONS.



# START OF HALT FUNCTIONS

# For each {deferred resource name}, stop resource monitoring for this
# resource using cmstopres(1m).

function stop_resources
{
for I in ${DEFERRED_RESOURCE_NAME[@]}
do
        print "$(date '+%b %e %X') - Node \"$(hostname)\": Stopping resource monitoring for $I"
        cmstopres -p $PACKAGE $I >> $log_file 2>&1
        test_return 16
done
}


# Halt each service using cmhaltserv(1m).

function halt_services
{
for I in ${SERVICE_NAME[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Halting service $I"
	cmhaltserv $I
	test_return 9
done
}

# Disown the DTC.

function disown_dtc 
{
for I in ${DTC_NAME[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Disowning the DTC $I"
	dtcmodifyconfs -d $I
	test_return 11
done
}

# For each IP address/subnet pair, remove the IP address from the subnet
# using cmmodnet(1m).

function remove_ip_address
{
integer S=0
typeset -i retval=0

for I in ${IP[@]}
do
	print "$(date '+%b %e %X') - Node \"$(hostname)\": Remove IP address $I from subnet ${SUBNET[$S]}"
        XX=$( cmmodnet -r -i $I ${SUBNET[$S]} 2>&1 )
        retval=$?
	if (( retval != 0 ))
	then
		if [[ $(echo $XX | grep "is not configured on the subnet") != "" ]]
		then
			print "$XX" >> $log_file
			# `let 0` is used to set the value of $? to 1.
			# The function test_return requires $? to be set
			# to 1 if it has to print error message.
                	let 0
                	test_return 12
		fi
	else
		retry_print "$XX"
	fi
	(( S = $S + 1 ))
done
}


# Unmount each logical volume.

function umount_fs
{
integer UM_CNT=${FS_UMOUNT_COUNT:-1}
integer ret
integer j
typeset mnt_order
typeset -i max_mnt_order=1
typeset -i i=0
    typeset -i total_mnts
    typeset -i cur_ord
    typeset -i mnts_processed
    typeset -i mnts_identified
    typeset K
    typeset I


sort_fs_directories
print "max mnt order: $max_mnt_order"

set -A LogicalVolumes ${LV[@]}

if [[ $UM_CNT < 1 ]]
then
   UM_CNT=1
fi

integer L=${#LogicalVolumes[*]}

# Perform parallel file system umounts for better performance.
# Limit the number of parallel umounts to CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS

 #Current order of mount being processed
 (( cur_order = max_mnt_order ))

 #Used to keep track how many mounts are completed
 (( mnts_processed = 0 ))

 #Total number of mounts to do
 (( total_mnts = ${#mnt_order[*]} ))

 #Number of mounts being done in one iteration
 (( mnts_identified = 0 ))


typeset mounttab=$(mount)

typeset pids_list
typeset volume_list

#Variable to loop through mount point array
(( i = total_mnts ))

while (( mnts_processed < total_mnts ))
do 
    mnts_identified=0

    #Check if we have gone through all
    #the elements, if so process to unmount
    # previous level mounts

    if (( $i == 0 ))
    then
	(( cur_order = cur_order - 1 ))
	(( i = $total_mnts ))
    fi
    while (( mnts_identified < \
	       CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS && i > 0 ))
    do
       (( i = i - 1 ))
       if [[ ${mnt_order[$i]} = $cur_order ]]
       then
           I=${LogicalVolumes[$i]}
           echo $mounttab | grep -e $I" " > /dev/null 2>&1
           if (( $? == 0 ))
           then
	       print "$(date '+%b %e %X') - Node \"$(hostname)\": Unmounting filesystem on $I" 
               (
               typeset users=$(show_users $I)
               umount ${FS_UMOUNT_OPT[$i]} $I; ret=$?
	       if (( ret != 0 ))
               then
                   print "$users"
	           print "\tWARNING:   Running fuser to remove anyone using the file system directly." 
	       fi

	       UM_COUNT=$UM_CNT
	       while (( ret != 0 && UM_COUNT > 0 ))
	       do
	           fuser -ku $I 
	           umount ${FS_UMOUNT_OPT[$i]} $I; ret=$?
	           if (( ret != 0 ))
	           then
		       (( UM_COUNT = $UM_COUNT - 1 ))
		       if (( $UM_COUNT > 0 ))
		       then
		           print "\t$(date '+%b %e %X') - Unmount $I failed, trying again." 
		           sleep 1
		       fi
	           fi 
                done
                return $ret 
                ) &

                # save the process id and name of logical volume to be used later
                # while checking the exit status 
                pids_list[$mnts_identified]="$!"
                volume_list[$mnts_identified]=$I
             fi
             (( mnts_identified = mnts_identified + 1 ))
             (( mnts_processed = mnts_processed + 1 ))
         fi #new
     done

     # wait for background umount processes to finish
     # I is used by "test_return 13"
     while (( mnts_identified > 0 ))
     do
         pid=${pids_list[$mnts_identified-1]}
         I=${volume_list[$mnts_identified-1]}
         wait $pid
         if (( $? != 0 ))
         then
             let 0
             test_return 13
         fi
         (( mnts_identified = mnts_identified - 1 ))
     done 
done
}


function deactivate_volume_group
{
# Perform multiple volume group deactivations at same time.
# Limit the number of concurrent deactivations to CONCURRENT_VGCHANGE_OPERATIONS

integer index=0
integer j
integer ret
integer num_retries=0
set -A VGS ${VG[@]}
integer num_vgs=${#VGS[*]}

typeset pids_list
typeset volume_list

while (( index < num_vgs ))
do
        j=0
        while (( j < CONCURRENT_VGCHANGE_OPERATIONS && index < num_vgs ))
        do
           I=${VGS[$index]}
           print "$(date '+%b %e %X') - Node \"$(hostname)\": Deactivating volume group $I" 
           (
	   vgchange -a n $I; ret=$?
           while (( ret != 0 && num_retries <  DEACTIVATION_RETRY_COUNT ))
           do
               print "\t$(date '+%b %e %X') - vgchange -a n $I failed, trying again."
               if  [[ $KILL_PROCESSES_ACCESSING_RAW_DEVICES = "YES" ]]
               then
                   print "\tWARNING:   Running fuser to remove anyone using the raw device directly."
                   find /dev/${I##*/} -type c \! -name group | xargs fuser -ku
               fi
               sleep 1
               vgchange -a n $I; ret=$?
               (( num_retries = num_retries + 1 ))
           done
           return $ret
           ) &
           # save the process id and name of VG, used while checking the exit status
           pids_list[$j]="$!"
           volume_list[$j]=$I
           (( j = j + 1 ))
           (( index = index + 1 ))
         done
      
         # wait for background vg deactivations to finish
         # I is used by "test_return 14"
         while (( j > 0 ))
         do
             pid=${pids_list[$j-1]}
             I=${volume_list[$j-1]}
             wait $pid
             if (( $? != 0 ))
             then
	         let 0
                 test_return 14
             fi
             (( j = j - 1 ))
         done 
done
}

function dg_fuser
{
    typeset opts=""
    while (( $# > 1 ))
    do
        opts="$opts $1" ; shift
    done
    typeset dg=$1
    for vol in /dev/vx/rdsk/$dg/*
    do
        [[ -z "$opts" ]] && show_users $vol
        [[ -n "$opts" ]] && fuser $opts $vol 2>&1 | awk -F: '$2 !~ "^ *$"'
    done
}

function deactivate_dg
{
    typeset action=$1
    typeset dg=$2
    typeset -i retval=0
    typeset -i cmd_status=1
    typeset out
    case "$action" in
    ("deactivate")
        out=$(vxdg -g $dg set activation=off 2>&1)
        cmd_status=$?
        ;;
    ("deport")
        out=$(vxdg deport $dg 2>&1)
        cmd_status=$?
        ;;
    esac
    # show output if failure.  if retryable, run fuser and return 2.
    if (( cmd_status != 0 ))
    then
        print "vxdg failed with exit code $cmd_status"
        print "$out"
        retval=1
        echo "$out" | grep -qi -e 'in use' -e 'is open' && retval=2
        (( retval == 2 )) && dg_fuser $dg
    fi
    
    return $retval
}

function deactivate_dg_with_retries
{
    typeset action=$1
    typeset dg=$2
    integer num_retries=0
    integer ret=0

    deactivate_dg $action $dg
    ret=$?

    while (( ret == 2 && num_retries <  DEACTIVATION_RETRY_COUNT ))
    do
        print "\t$(date '+%b %e %X') - failed to $action disk group $dg, trying again."
        if  [[ $KILL_PROCESSES_ACCESSING_RAW_DEVICES = "YES" ]]
        then
            print "\tWARNING:   Running fuser to remove anyone using the raw device directly."
            dg_fuser -ku $dg
        fi
        # vxvm has background processes that can touch dgs/volumes, so
        # wait a bit to let those finish before retrying
        cmsleep 1
        deactivate_dg $action $dg
        ret=$?
        (( ret == 0 )) && print "Retry of $action on disk group $dg succeeded"

        (( num_retries = num_retries + 1 ))
    done

    return $ret
}

function deactivate_disk_group
{
    integer ret

    for I in ${CVM_DG[@]}
    do
        print "$(date '+%b %e %X') - Node \"$(hostname)\": Deactivating disk group $I"
        deactivate_dg_with_retries deactivate $I
        ret=$?
        if (( ret != 0 ))
        then
            let 0
            test_return 25
        fi
    done

    for I in ${VXVM_DG[@]}
    do
        print "$(date '+%b %e %X') - Node \"$(hostname)\": Deporting disk group $I"
        deactivate_dg_with_retries deport $I
        ret=$?
        if (( ret != 0 ))
        then
            let 0
            test_return 26
        fi
    done
}

# END OF HALT FUNCTIONS.

# FUNCTIONS COMMON TO BOTH RUN AND HALT.

# Test return value of functions and exit with NO RESTART if bad.
# Return value of 0 - 50 are reserved for use by Hewlett-Packard.
# System administrators can use numbers above 50 for return values.
	function test_return
	{
	if (( $? != 0 ))
	then
                integer to_exit=0
		case $1 in
			1)
			print "\tERROR:  Function activate_volume_group"
			print "\tERROR:  Failed to activate $I"
			exit_value=1
			;;

			2)
			print "\tERROR:  Function check_and_mount"
			print "\tERROR:  Failed to fsck one of the logical volumes."
			exit_value=1
			;;

                        3)
                        print "\tERROR:  Function check_and_mount"
                        print "\tERROR:  Failed to mount $I"
			exit_value=1
                        ;;

			4)
			print "\tERROR:  Function add_ip_address"
			print "\tERROR:  Failed to add IP address to subnet"
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			5)
			print "\tERROR:  Function get_ownership_dtc"
			print "\tERROR:  Failed to own $I"
			disown_dtc
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			6)
			print "\tERROR:  Function get_ownership_dtc"
			print "\tERROR:  Failed to switch $I"
			disown_dtc
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

                        7)
                        print "\tERROR:  Function wait_for_cvm_dg_vols_enabled"
                        print "\tERROR:  Failed to enable $I"
                        disown_dtc
                        remove_ip_address
                        verify_ha_nfs stop
                        umount_fs
                        deactivate_volume_group
                        deactivate_disk_group
                        to_exit=1
                        ;;

			8)
			print "\tERROR:  Function start_services"
			print "\tERROR:  Failed to start service ${SERVICE_NAME[$C]}"
			halt_services
			customer_defined_halt_cmds
			disown_dtc
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			9)
			print "\tFunction halt_services"
			print "\tWARNING: Failed to halt service $I"
			;;

			11)
			print "\tERROR:  Function disown_dtc"
			print "\tERROR:  Failed to disown $I from ${SUBNET[$S]}"
			exit_value=1
			;;

			12) 
			print "\tERROR:  Function remove_ip_address"
			print "\tERROR:  Failed to remove $I" 
			exit_value=1 
			;; 

			13) 
			print "\tERROR:  Function umount_fs"
			print "\tERROR:  Failed to unmount $I"
			exit_value=1
			;;

			14)
			print "\tERROR:  Function deactivate_volume_group"
                        print "\tERROR:  Failed to deactivate $I"
			exit_value=1
			;;

			15)
			print "\tERROR:  Function start_resources"
			print "\tERROR:  Failed to start resource $I"
			stop_resources
			halt_services
			customer_defined_halt_cmds
			disown_dtc
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			16)
			print "\tERROR:  Function stop_resources"
			print "\tERROR:  Failed to stop resource $I"
			exit_value=1
			;;

			17)
			print "\tERROR:  Function freeup_busy_mountpoint_and_mount_fs"
			print "\tERROR:  Failed to mount $I to ${FS[$F]}"
			exit_value=1
			;;

			21)
			print "\tERROR:  Function activate_disk_group"
			print "\tERROR:  Failed to activate $I"
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			22)
			print "\tERROR:  Function check_dg failed" 
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			23)
			print "\tERROR:  Function activate_disk_group"
			print "\tERROR:  Failed to import $I"
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			24)
			print "\tERROR:  Function activate_disk_group"
			print "\tERROR:  Failed to vxvol -g $I startall"
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			25)
			print "\tERROR:  Function deactivate_disk_group"
			print "\tERROR:  Failed to deactivate $I"
			exit_value=1
			;;

			26)
			print "\tERROR:  Function deactivate_disk_group"
			print "\tERROR:  Failed to deport $I"
			exit_value=1
			;;

                        49)
                        print "\tERROR:  Function verify_ha_nfs"
                        print "\tERROR:  Failed to start NFS"
                        umount_fs
                        deactivate_volume_group
                        deactivate_disk_group
                        to_exit=1
                        ;;

                        50)
                        print "\tERROR:  Function verify_ha_nfs"
                        print "\tERROR:  Failed to stop NFS"
                        exit_value=1
                        ;;
                        
			51)
			print "\tERROR:  Function customer_defined_run_cmds"
			print "\tERROR:  Failed to RUN customer commands"
			halt_services
			customer_defined_halt_cmds
			disown_dtc
			remove_ip_address
                        verify_ha_nfs stop
			umount_fs
			deactivate_volume_group
			deactivate_disk_group
			to_exit=1
			;;

			52)
			print "\tERROR:  Function customer_defined_halt_cmds"
			print "\tERROR:  Failed to HALT customer commands"
			exit_value=1
			;;

                        53)
                        print "\tERROR:  Function ha_nfs_file_locks failed"
			remove_ip_address
                        verify_ha_nfs stop
                        umount_fs
                        deactivate_volume_group
                        deactivate_disk_group
                        to_exit=1
                        ;;

			*)
			print "\tERROR:  Failed, unknown error."
			;;

		esac
                
                if (( $to_exit == 1 ))
                then
                    print "###### Node \"$(hostname)\": Package start failed at $(date) ######"
                    exit 1
                fi
	fi
	}

	# END OF FUNCTIONS COMMON TO BOTH RUN AND HALT

	#-------------------MAINLINE Control Script Code Starts Here-----------------
	#
	# FUNCTION STARTUP SECTION.

	typeset MIN_VERSION="11.14"  # Minimum version this control script works on

	integer exit_value=0
	typeset CUR_VERSION

	#
	# Check that this control script is being run on a A.10.03 or later release
	# of Serviceguard or Serviceguard Extension for RAC.  The control scripts are forward 
	# compatible but are not backward compatible because newer control 
	# scripts use commands and option not available on older releases.

	CUR_VERSION=`$SGSBIN/cmversion | cut -f2-3 -d"."`

	if [[ "${CUR_VERSION}" = ""  ]] || \
				      [[ "${CUR_VERSION#*.}" < "${MIN_VERSION#*.}" ]]
	then
	    print "ERROR:  Mismatched control script version ($MIN_VERSION).  You cannot run"
	    print "\ta version ${MIN_VERSION} control_script on a node running pre"
	    print "\t${MIN_VERSION} Serviceguard or Serviceguard Extension for RAC software"
	    exit 1
	fi

        # Check that CONCURRENT_VGCHANGE_OPERATIONS is set to >=1.
        if (( CONCURRENT_VGCHANGE_OPERATIONS < 1 ))
        then
            print "\tWARNING:  Invalid CONCURRENT_VGCHANGE_OPERATIONS value. Defaulting it to 1."
            CONCURRENT_VGCHANGE_OPERATIONS=1
        fi

        # Check that CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS is set to >=1.
        if (( CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS < 1 ))
        then
            print "\tWARNING:  Invalid CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS value. Defaulting it to 1."
            CONCURRENT_MOUNT_AND_UMOUNT_OPERATIONS=1
        fi

        # Check that CONCURRENT_FSCK_OPERATIONS is set to >=1.
        if (( CONCURRENT_FSCK_OPERATIONS < 1 ))
        then
            print "\tWARNING:  Invalid CONCURRENT_FSCK_OPERATIONS value. Defaulting it to 1."
            CONCURRENT_FSCK_OPERATIONS=1
        fi

	# If multi-threaded version of vgchange is available and user wants to use it then
	# use -T option.
	vgchange 2>&1 | grep -q -e "\[-T\]"
	if (($? == 0 && $ENABLE_THREADED_VGCHANGE == 1))
	then
 		VGCHANGE=$VGCHANGE" -T"
	fi

	# Test to see if we are being called to run the package, or halt the package.

	if [[ $1 = "start" ]]
	then
		print "\n\t########### Node \"$(hostname)\": Starting package at $(date) ###########"

		
		verify_physical_data_replication   # add hook for MetroCluster # 实际上什么也没做

		activate_volume_group  # 并发激活 `VG`

		activate_disk_group

		check_and_mount 

		verify_ha_nfs $1     # add hook for NFS

		add_ip_address

                ha_nfs_file_locks

		get_ownership_dtc

                wait_for_cvm_dg_vols_enabled

		customer_defined_run_cmds

		start_services

		start_resources


	# Check exit value

		if (( $exit_value == 1 ))
		then
			print "\n\t########### Node \"$(hostname)\": Package start failed at $(date) ###########"
			exit 1 
		else 
			print "\n\t########### Node \"$(hostname)\": Package start completed at $(date) ###########"
			exit 0 
		fi

	elif [[ $1 = "stop" ]]
	then
		print "\n\t########### Node \"$(hostname)\": Halting package at $(date) ###########"


		stop_resources

		halt_services

		customer_defined_halt_cmds

		disown_dtc

		remove_ip_address

		verify_ha_nfs $1  # add hook for NFS

		umount_fs

		deactivate_volume_group

		deactivate_disk_group

	# Check exit value
		if (( $exit_value == 1 ))
		then
			print "\n\t########### Node \"$(hostname)\": Package halt failed at $(date) ###########"
			exit 1 
		else 
			print "\n\t########### Node \"$(hostname)\": Package halt completed at $(date) ###########"
			exit 0 
		fi

fi
