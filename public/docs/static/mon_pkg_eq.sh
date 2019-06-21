#!/usr/bin/sh

trap "signal_handler" 15
#trap "halt_proc" 1 2 3
#trap "exit" 1 2 3

case $PATH in
	"") PATH=/bin:/usr/bin:/etc
	    export PATH ;;
esac

program=$0

proc_check=/etc/cmcluster/pkg_eq/proc_check_eq.conf

if [ -f $proc_check ]
then
    . $proc_check
else
    PROC_CHECK = 1
fi

#kanshi_process="request_daemon eda_daemon master_daemon"
#kanshiuser='titann1'


#
# Using waiting for oracle start completed.
#
orauser=oracle
#oracle_process="ora_dbw ora_smon ora_pmon ora_lgwr ora_reco ora_ckpt"
oracle_process="ora_smon"
max_waiting_for_oracle=1800      # seconds

HOST=`hostname`
DATE=`date`

ORACLE_HOME=/package/oracle/oracle11/app/oracle/product/11.2.0/db_1
db_user=TITANN1
db_pass=NAN1

# Oracle setup
export ORACLE_BASE=/package/oracle/oracle11/app/oracle
export ORACLE_SID ora11
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_TERM=vt100
export PATH=${PATH}:${ORACLE_HOME}/bin
export NLS_LANG=American_America.AL32UTF8
export LANG=en_US.utf8
export ORA_NLS10=$ORACLE_HOME/nls/data
# oracle 64bit Edition
export SHLIB_PATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export TWO_TASK=ORA11

#-----------------------------------
# Signal handler
#-----------------------------------
function signal_handler
{
  echo "Accept trap signal"
  halt_package
  exit
}

#-----------------------------------
# Private WAIT for oracle started
#-----------------------------------
function wait_oracle
{
  integer n=0
  echo "$HOST : Now waiting startup ORACLE. ($DATE)"

  for i in ${oracle_process[@]}
  do
    while true
    do
        PROCESSES_PID=`ps -fu ${orauser} | awk '/'${i}'/ { print $2 }'`

        if [ "${PROCESSES_PID}" != "" ]
        then
           echo "$i is started with pid ${PROCESSES_PID}"
           break
        fi

        sleep 2
        (( n = $n + 2 ))
        if [ $n -gt $max_waiting_for_oracle ]
        then
	    echo "ERROR Oracle not response."
            exit
        fi
    done
  done

  echo "$HOST : All ORACLE process startup. and wait 60 sec... ($DATE)"
}

#-----------------------------------
# HALT process
#-----------------------------------
function halt_package
{

#su - titann1 -c '/package/titann1/toraja/bin/svrdctl.sh stop'
#su - titann1 -c '/package/titann1/shells/titan shutdown'
#su - oracle -c '/package/oracle/oracle11/app/oracle/product/11.2.0/db_1/bin/cldbshut'
 echo "halt package"
 
}

#-----------------------------------
# HALT process
#-----------------------------------
function restart_package
{

#su - oracle -c '/package/oracle/oracle11/app/oracle/product/11.2.0/db_1/bin/cldbshut'

#su - oracle -c '/package/oracle/oracle11/app/oracle/product/11.2.0/db_1/bin/cldbstart' 

 echo "restart_package"

}

#-----------------------------------
#-----------------------------------
# Start up touroku package
#-----------------------------------
function start_processes
{

#su - oracle -c '/package/oracle/oracle11/app/oracle/product/11.2.0/db_1/bin/cldbstart' 
#su - titann1 -c '/package/titann1/toraja/bin/svrdctl.sh start'
#su - titann1 -c '/package/titann1/shells/titan startup'

 echo "start_processes"

}

#-----------------------------------
# Monitor processes
#-----------------------------------
function monitor_processes
{
  end_proc=""
  echo "$HOST : Packge K1_1 monitor start. ($DATE)"

  while true ; do
    if [ "$PROC_CHECK" -ne 0 ]
    then

      # Check titank1 user process
      for i in ${kanshi_process[@]}
      do
        PROCESS_PID=`ps -fu ${kanshiuser} | awk '/'${i}'/ { print $2 }'`
        if [ "${PROCESS_PID}" = "" ]
        then
          end_proc=${i}
          break;
        fi
      done

      if [ "${end_proc}" != "" ] 
      then
          echo "Process finished (${end_proc})"
          break;
      fi

      # Check oracle user process
#      for i in ${oracle_process[@]}
#      do
#        PROCESS_PID=`ps -fu ${orauser} | awk '/'${i}'/ { print $2 }'`
#        if [ "${PROCESS_PID}" = "" ]
#        then
#          end_proc=${i}
#          break;
#        fi
#      done

      if [ "${end_proc}" != "" ] 
      then
          echo "Process finished (${end_proc})"
          break;
      fi

      # ORACLE Login Check
      ${ORACLE_HOME}/bin/sqlplus -S ${db_user}/${db_pass} <<EOF
      whenever oserror exit 1 rollback
      whenever sqlerror exit 1 rollback
      exit
EOF
      if [ $? -ne 0 ] 
      then
        echo "ORACLE is not running"
        break;
      fi

    fi
    sleep 5
  done
}

###############################################################################
# FUNCTION STARTUP SECTION.
#
# Test to see if we are being called to run the application, or halt the
# application.
###############################################################################

print "\n *** $0 called with $1 argument. ***\n"
case $1 in

    monitor)
        monitor_processes
    ;;

    start)
        print "\n \"${HOST}\": Starting K1_1 package at ${DATE} "
        start_processes
    ;;

    halt)
        print "\n \"${HOST}\": Shutdown K1_1 package at ${DATE} "
        halt_package
    ;;

    *)
        print "Usage: ${0} [ halt | start | monitor ]"
    ;;
esac

