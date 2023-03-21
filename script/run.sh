#!/bin/ksh

# 20221124 drger; Install/update GEMMI monitor scripts

# Script startup gets env from copie_scr.sh
showScreen ${SDLIB}/mmiscript-0.png
touch ${SDPATH}/.started
xlogfile=${SDPATH}/run-$(getTime).log
exec > ${xlogfile} 2>&1
umask 022
echo "[INFO] Script start: $(date); Timestamp: $(getTime)"
echo; echo "[INFO] Updating for software train version: $SWTRAIN"
echo; echo "[INFO] GEMMI Monitor version: 20221126a"

# Part 1: Install/update run_gemmi.sh-monitor in /mnt/nav/gemmi
mount -uw /mnt/nav
xddir=/mnt/nav/gemmi
if [ -f ${xddir}/run_gemmi.sh-monitor ]
then
  # Update:
  echo; echo "[INFO] Updating run_gemmi.sh-monitor script"
  mv -v ${xddir}/run_gemmi.sh-monitor ${xddir}/run_gemmi.sh-tmp1
  cp -v ${SDVAR}/run_gemmi.sh-monitor ${xddir}/
  mv -v ${xddir}/run_gemmi.sh ${xddir}/run_gemmi.sh-tmp2
  chmod 0755 ${xddir}/run_gemmi.sh-monitor
  ln -v ${xddir}/run_gemmi.sh-monitor ${xddir}/run_gemmi.sh
  rm -v ${xddir}/run_gemmi.sh-tmp1
  rm -v ${xddir}/run_gemmi.sh-tmp2
else
  # Install:
  echo; echo "[INFO] Installing run_gemmi.sh-monitor script"
  mv -v ${xddir}/run_gemmi.sh ${xddir}/run_gemmi.sh-k9426
  cp -v ${SDVAR}/run_gemmi.sh-monitor ${xddir}/
  chmod 0755 ${xddir}/run_gemmi.sh-monitor
  ln -v ${xddir}/run_gemmi.sh-monitor ${xddir}/run_gemmi.sh
  fi

# Part 2: Install/update gemmi_monitor.sh in /mnt/nav/gemmi
if [ -f ${xddir}/gemmi_monitor.sh ]
then
  # Update:
  echo; echo "[INFO] Updating gemmi_monitor.sh script"
  mv -v ${xddir}/gemmi_monitor.sh ${xddir}/gemmi_monitor.sh-tmp1
  cp -v ${SDVAR}/gemmi_monitor.sh ${xddir}/
  chmod 0755 ${xddir}/gemmi_monitor.sh
  rm -v ${xddir}/gemmi_monitor.sh-tmp1
else
  # Install:
  echo; echo "[INFO] Installing gemmi_monitor.sh script"
  cp -v ${SDVAR}/gemmi_monitor.sh ${xddir}/
  chmod 0755 ${xddir}/gemmi_monitor.sh
fi

echo; echo "[INFO] List /mnt/nav/gemmi"
ls -o /mnt/nav/gemmi/

if [ ! -d /mnt/persistence/log ]
then
  echo; echo "[ACTI] Making persistent log directory ..."
  mkdir /mnt/persistence/log/
fi
echo; echo "[INFO] List /mnt/persistence/log"
ls -o /mnt/persistence/log/

echo; echo "[INFO] Saving GoogleEarthPlus.conf"
cp -v /mnt/img-cache/gemmi/.config/Google/GoogleEarthPlus.conf \
	  ${SDVAR}/GoogleEarthPlus.conf-$(getTime)

# Part 3: Install/update GEMMI GEM info scripts in /mnt/efs-system
mount -uw /mnt/efs-system
xddir=/mnt/efs-system/scripts/GEMMI

# Install/update getInfoGEMMI.sh-monitor
if [ -f ${xddir}/getInfoGEMMI.sh-monitor ]
then
echo; echo "[INFO] Updating getInfoGEMMI.sh-monitor"
  mv -v ${xddir}/getInfoGEMMI.sh-monitor ${xddir}/getInfoGEMMI.sh-tmp1
  cp -v ${SDVAR}/getInfoGEMMI.sh-monitor ${xddir}/
  mv -v ${xddir}/getInfoGEMMI.sh ${xddir}/getInfoGEMMI.sh-tmp2
  cp -v ${xddir}/getInfoGEMMI.sh-monitor ${xddir}/getInfoGEMMI.sh
  chmod 0755 ${xddir}/getInfoGEMMI.sh
  rm -v ${xddir}/getInfoGEMMI.sh-tmp1
  rm -v ${xddir}/getInfoGEMMI.sh-tmp2
else
  echo; echo "[INFO] Installing getInfoGEMMI.sh-monitor"
  mv -v ${xddir}/getInfoGEMMI.sh ${xddir}/getInfoGEMMI.sh-k9426
  cp -v ${SDVAR}/getInfoGEMMI.sh-monitor ${xddir}/
  cp -v ${xddir}/getInfoGEMMI.sh-monitor ${xddir}/getInfoGEMMI.sh
  chmod 755 ${xddir}/getInfoGEMMI.sh
fi

# Install/update getCacheStatus.sh-monitor
if [ -f ${xddir}/getCacheStatus.sh-monitor ]
then
  echo; echo "[INFO] Updating getCacheStatus.sh-monitor"
  mv -v ${xddir}/getCacheStatus.sh-monitor ${xddir}/getCacheStatus.sh-tmp1
  cp -v ${SDVAR}/getCacheStatus.sh-monitor ${xddir}/
  mv -v ${xddir}/getCacheStatus.sh ${xddir}/getCacheStatus.sh-tmp2
  cp -v ${xddir}/getCacheStatus.sh-monitor ${xddir}/getCacheStatus.sh
  chmod 0755 ${xddir}/getCacheStatus.sh
  rm -v ${xddir}/getCacheStatus.sh-tmp1
  rm -v ${xddir}/getCacheStatus.sh-tmp2
else
  echo; echo "[INFO] Installing getCacheStatus.sh-monitor"
  mv -v ${xddir}/getCacheStatus.sh ${xddir}/getCacheStatus.sh-k9426
  cp -v ${SDVAR}/getCacheStatus.sh-monitor ${xddir}/
  cp -v ${xddir}/getCacheStatus.sh-monitor ${xddir}/getCacheStatus.sh
  chmod 0755 ${xddir}/getCacheStatus.sh
fi

echo; echo "[INFO] List /mnt/efs-system/scripts/GEMMI"
ls -o /mnt/efs-system/scripts/GEMMI/

# Script cleanup:
echo "[INFO] End: $(date); Timestamp: $(getTime)"
showScreen ${SDLIB}/mmiscript-1.png
rm -f ${SDPATH}/.started
exit 0
