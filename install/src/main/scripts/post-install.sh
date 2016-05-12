#!/bin/bash
rpmInstallDir=/opt/thinkbig
pgrepMarkerThinkbigUi=thinkbig-ui-pgrep-marker
pgrepMarkerThinkbigServices=thinkbig-services-pgrep-marker
pgrepMarkerThinkbigSparkShell=thinkbig-spark-shell-pgrep-marker
rpmLogDir=/var/log

echo "    - Install thinkbig-ui application"
tar -xf $rpmInstallDir/thinkbig-ui/thinkbig-ui-app-*.tar.gz -C $rpmInstallDir/thinkbig-ui --strip-components=1
rm -rf $rpmInstallDir/thinkbig-ui/thinkbig-ui-app-*.tar.gz
echo "   - Installed thinkbig-ui to '$rpmInstallDir/thinkbig-ui'"

cat << EOF > $rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui.sh
  #!/bin/bash
  java \$THINKBIG_UI_OPTS -cp $rpmInstallDir/thinkbig-ui/conf:$rpmInstallDir/thinkbig-ui/lib/* com.thinkbiganalytics.ThinkbigDataLakeUiApplication --pgrep-marker=$pgrepMarkerThinkbigUi > /dev/null 2>&1 &
EOF
cat << EOF > $rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui-with-debug.sh
  #!/bin/bash
  JAVA_DEBUG_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8008
  java \$THINKBIG_UI_OPTS \$JAVA_DEBUG_OPTS --cp $rpmInstallDir/thinkbig-ui/conf:$rpmInstallDir/thinkbig-ui/lib/* com.thinkbiganalytics.app.Application --pgrep-marker=$pgrepMarkerThinkbigUi
EOF
chmod +x $rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui.sh
chmod +x $rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui-with-debug.sh
echo "   - Created thinkbig-ui script '$rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui.sh'"

cat << EOF > /etc/init.d/thinkbig-ui
  #! /bin/sh
  # chkconfig: 345 95 20
  # description: thinkbig-ui
  # processname: thinkbig-ui
  case "\$1" in
    start)
        if pgrep -f $pgrepMarkerThinkbigUi >/dev/null 2>&1
          then
            echo Already running.
          else
            echo Starting thinkbig-ui ...
            $rpmInstallDir/thinkbig-ui/bin/run-thinkbig-ui.sh
        fi
      ;;
    stop)
        if pgrep -f $pgrepMarkerThinkbigUi >/dev/null 2>&1
          then
            echo Stopping thinkbig-ui ...
            pkill -f $pgrepMarkerThinkbigUi
          else
            echo Already stopped.
        fi
            ;;
        status)
        if pgrep -f $pgrepMarkerThinkbigUi >/dev/null 2>&1
          then
              echo Running.  Here are the related processes:
              pgrep -lf $pgrepMarkerThinkbigUi
          else
            echo Stopped.
        fi
            ;;
  esac
  exit 0
EOF
chmod +x /etc/init.d/thinkbig-ui
echo "   - Created thinkbig-ui script '/etc/init.d/thinkbig-ui'"

mkdir -p $rpmLogDir/thinkbig-ui/
echo "   - Created Log folder $rpmLogDir/thinkbig-ui/"

chkconfig --add thinkbig-ui
chkconfig thinkbig-ui on
echo "   - Added service 'thinkbig-ui'"
echo "    - Completed thinkbig-ui install"

echo "    - Install thinkbig-services application"

tar -xf $rpmInstallDir/thinkbig-services/thinkbig-service-app-*.tar.gz -C $rpmInstallDir/thinkbig-services --strip-components=1
rm -rf $rpmInstallDir/thinkbig-services/thinkbig-service-app-*.tar.gz
rm -f $rpmInstallDir/thinkbig-services/lib/jetty*
rm -f $rpmInstallDir/thinkbig-services/lib/servlet-api*
echo "   - Installed thinkbig-services to '$rpmInstallDir/thinkbig-services'"

cat << EOF > $rpmInstallDir/thinkbig-services/bin/run-thinkbig-services.sh
  #!/bin/bash
  java \$THINKBIG_SERVICES_OPTS -cp $rpmInstallDir/thinkbig-services/conf:$rpmInstallDir/thinkbig-services/lib/* com.thinkbiganalytics.server.ThinkbigServerApplication --pgrep-marker=$pgrepMarkerThinkbigServices > /dev/null 2>&1 &
EOF
cat << EOF > $rpmInstallDir/thinkbig-services/bin/run-thinkbig-services-with-debug.sh
  #!/bin/bash
  JAVA_DEBUG_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8008
  java \$THINKBIG_SERVICES_OPTS \$JAVA_DEBUG_OPTS --cp $rpmInstallDir/thinkbig-services/conf:$rpmInstallDir/thinkbig-services/lib/* com.thinkbiganalytics.hive.server.Application --pgrep-marker=$pgrepMarkerThinkbigServices
EOF
chmod +x $rpmInstallDir/thinkbig-services/bin/run-thinkbig-services.sh
chmod +x $rpmInstallDir/thinkbig-services/bin/run-thinkbig-services-with-debug.sh
echo "   - Created thinkbig-services script '$rpmInstallDir/thinkbig-services/bin/run-thinkbig-services.sh'"

cat << EOF > /etc/init.d/thinkbig-services
  #! /bin/sh
  # chkconfig: 345 95 20
  # description: thinkbig-services
  # processname: thinkbig-services
  case "\$1" in
    start)
        if pgrep -f $pgrepMarkerThinkbigServices >/dev/null 2>&1
          then
            echo Already running.
          else
            echo Starting thinkbig-services ...
            $rpmInstallDir/thinkbig-services/bin/run-thinkbig-services.sh
        fi
      ;;
    stop)
        if pgrep -f $pgrepMarkerThinkbigServices >/dev/null 2>&1
          then
            echo Stopping thinkbig-services ...
            pkill -f $pgrepMarkerThinkbigServices
          else
            echo Already stopped.
        fi
            ;;
        status)
        if pgrep -f $pgrepMarkerThinkbigServices >/dev/null 2>&1
          then
              echo Running.  Here are the related processes:
              pgrep -lf $pgrepMarkerThinkbigServices
          else
            echo Stopped.
        fi
            ;;
  esac
  exit 0
EOF
chmod +x /etc/init.d/thinkbig-services
echo "   - Created thinkbig-services script '/etc/init.d/thinkbig-services'"

mkdir -p $rpmLogDir/thinkbig-services/
echo "   - Created Log folder $rpmLogDir/thinkbig-services/"

chkconfig --add thinkbig-services
chkconfig thinkbig-services on
echo "   - Added service 'thinkbig-services'"


echo "    - Completed thinkbig-services install"

echo "    - Install thinkbig-spark-shell application"
tar -xf $rpmInstallDir/thinkbig-spark-shell/thinkbig-spark-shell-service-*.tar.gz -C $rpmInstallDir/thinkbig-spark-shell --strip-components=1
rm -rf $rpmInstallDir/thinkbig-spark-shell/thinkbig-spark-shell-service-*.tar.gz
rm -f $rpmInstallDir/thinkbig-spark-shell/lib/slf4j*
rm -f $rpmInstallDir/thinkbig-spark-shell/lib/log4j*
rm -f $rpmInstallDir/thinkbig-spark-shell/lib/thinkbig-spark-shell*
echo "   - Installed thinkbig-spark-shell to '$rpmInstallDir/thinkbig-spark-shell'"

cat << EOF > $rpmInstallDir/thinkbig-spark-shell/bin/run-thinkbig-spark-shell.sh
  #!/bin/bash
  spark-submit --conf spark.driver.userClassPathFirst=true --class com.thinkbiganalytics.spark.SparkShellServer --jars \`find $rpmInstallDir/thinkbig-spark-shell/lib/ -name "*.jar" | paste -d, -s\` $rpmInstallDir/thinkbig-spark-shell/thinkbig-spark-shell-*.jar --pgrep-marker=$pgrepMarkerThinkbigSparkShell
EOF
chmod +x $rpmInstallDir/thinkbig-spark-shell/bin/run-thinkbig-spark-shell.sh
echo "   - Created thinkbig-spark-shell script '$rpmInstallDir/thinkbig-spark-shell/bin/run-thinkbig-spark-shell.sh'"

cat << EOF > /etc/init.d/thinkbig-spark-shell
  #! /bin/sh
  # chkconfig: 345 95 20
  # description: thinkbig-spark-shell
  # processname: thinkbig-spark-shell
  stdout_log="/var/log/thinkbig-spark-shell/thinkbig-spark-shell.log"
  stderr_log="/var/log/thinkbig-spark-shell/thinkbig-spark-shell.err"
  case "\$1" in
    start)
        if pgrep -f /thinkbig-spark-shell/ >/dev/null 2>&1
          then
            echo Already running.
          else
            echo Starting thinkbig-spark-shell ...
            $rpmInstallDir/thinkbig-spark-shell/bin/run-thinkbig-spark-shell.sh >> "\$stdout_log" 2>> "\$stderr_log" &
        fi
      ;;
    stop)
        if pgrep -f /thinkbig-spark-shell/ >/dev/null 2>&1
          then
            echo Stopping thinkbig-spark-shell ...
            pkill -f /thinkbig-spark-shell/
          else
            echo Already stopped.
        fi
            ;;
        status)
        if pgrep -f /thinkbig-spark-shell/ >/dev/null 2>&1
          then
              echo Running.  Here are the related processes:
              pgrep -lf /thinkbig-spark-shell/
          else
            echo Stopped.
        fi
            ;;
  esac
  exit 0
EOF
chmod +x /etc/init.d/thinkbig-spark-shell
echo "   - Created thinkbig-spark-shell script '/etc/init.d/thinkbig-spark-shell'"

mkdir -p $rpmLogDir/thinkbig-spark-shell/
echo "   - Created Log folder $rpmLogDir/thinkbig-spark-shell/"

chkconfig --add thinkbig-spark-shell
chkconfig thinkbig-spark-shell on
echo "   - Added service 'thinkbig-spark-shell'"


echo "    - Completed thinkbig-spark-shell install"

{
echo "    - Create aa RPM Removal script at: $rpmInstallDir/remove-thinkbig-datalake-accelerator.sh"
lastRpm=$(rpm -qa | grep thinkbig-datalake-accelerator)
touch $rpmInstallDir/remove-thinkbig-datalake-accelerator.sh
echo "rpm -e $lastRpm " > $rpmInstallDir/remove-thinkbig-datalake-accelerator.sh
chmod +x $rpmInstallDir/remove-thinkbig-datalake-accelerator.sh

}

echo "   INSTALL COMPLETE"
echo "   - Please configure the application using the property files and scripts located under the '$rpmInstallDir/thinkbig-ui/conf' and '$rpmInstallDir/thinkbig-services/conf' folder.  See deployment guide for details."
echo "   - To remove thinkbig-datalake-accelerator run $rpmInstallDir/remove-thinkbig-datalake-accelerator.sh "