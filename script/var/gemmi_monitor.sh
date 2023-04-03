#!/bin/ksh

# 20230320 drger; bug fix, added timestamp
# 20221122 drger; Monitor GEMMI network connection status

export LOGDIR=/mnt/persistence/log
export xgemmilog=${LOGDIR}/gemmi.log

xgemminetstatus()
{
  if [ -n "$(ifconfig $xnetif | grep 'status: active')" ]
  then
    xt0="$(sed -n 'H; /^\[GEMMI\] gemmi_final start:/h; ${g;p;}' $xgemmilog |
           grep '^Network ' | sed -n '$p')"
    if [ -n "$(echo "$xt0" | grep '^Network down ')" ]
    then
      xfnr="$(echo "$xt0" | sed 's/Network down on frame //')"
      echo "down $xfnr"
    else
      echo "up"
    fi
  else
    echo "off"
  fi
}

if [ -f /HBpersistence/DLinkReplacesPPP ]
then
  xnetif=en5
else
  xnetif=ppp0
fi
export xnetif
echo "[GEMMI] gemmi_monitor script start $xnetif $(getTime)"
nts=0
while true
do
  nts=$((${nts} + 1))
  # get current gemmi_final log output, look for Network Down status:
  xnetstatus="$(xgemminetstatus)"
  if [ -n "$(echo $xnetstatus | grep 'down')" ]
  then
    xfnr1="$(echo $xnetstatus | sed 's/^down //')"
    while true
    do
      # Sleep a bit before checking again
      sleep 180
      xnetstatus="$(xgemminetstatus)"
      if [ -n "$(echo $xnetstatus | grep 'down')" ]
      then
        xfnr2="$(echo $xnetstatus | sed 's/^down //')"
        echo "[GEMMI] Network down $xfnr1 $xfnr2 $(getTime)"
        if [ X"$xfnr1" = X"xfnr2" ]
        then
          if [ -n "$(ifconfig -v $xnetif | grep 'status: active')" ]
          then
            echo "[GEMMI] Terminate gemmi_final process $(getTime)"
            slay -s KILL gemmi_final
            break
          fi
        fi
        # network down but different frame nr, repeat
        xfnr1="$xfnr2"
      else
        # network not down, quit this while condition
        echo "[GEMMI] Found network up $(getTime)"
        break
      fi
    done
  fi
  # check again in 5 min
  sleep 300
  if test $nts -eq 6
  then
    echo "[GEMMI] Timestamp: $(getTime)"
    nts=0
  fi
done
