# GEMMI-Monitor
MMI3GP Google Earth client log monitor scripts

The production script that starts the Google Earth client gemmi_final on Harman/Becker MMI3GP systems discards log output at run time.  Inspection of the compiled gemmi_final binary with Unix strings(1) finds various command line arguments that allow status monitoring of the client during operation.

This collection of QNX scripts for Harman/Becker MMI3GP systems implements a simple run-time monitor that will restart the gemmi_final process after the monitor finds the client has reported its network connection down for a certain time period.  Included here are:

gemmi_monitor.sh:
Shell script that scans the current GEMMI plain-text log file periodically.  When the script finds that the gemmi_final client has reported its network connection down for more than X seconds, the script terminates the current gemmi_final process.

getCacheStatus.sh-monitor:
Green Engineering menu script to report on the GEMMI cache status.

getInfoGEMMI.sh-monitor:
Green Engineering menu script to report certain network status to the console and a FAT32 SD card in slot 1.

run_gemmi.sh-monitor:
Shell script that implements the gemmi_final process logger to plain-text files in /mnt/persistence/log.  Command-line arguments to gemmi_final are configured here.
