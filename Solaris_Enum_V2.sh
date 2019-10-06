#!/bin/bash
#Created By WO1 Gabriel Garcia
#Solaris Enumeration Script
#POC gabriel.a.garcia80.mil@mail.mil or ggarciasnt@gmail.com
#CPT 155 TEAM White Claw Securi Draco

#####Updated LINE 109 to only copy files with contents and keep the original timestamps.

read -p "IP Address of ServerIP : " filename

#mkdir $./$filename
#outdir=./$filename\_results_$(date +%d%b%y)@$(date +%H%M)
outfile=$(hostname)_$filename.txt

seperator()
{
echo -e "\n#################################################################################\n\n" | tee -a ./$outfile &>/dev/null
}

echo -e "Script Started At $(date +%d:%b:%y@%H:%M:%S)"    
echo -e "Script Started at $(date +%d:%b:%y@%H:%M:%S)"  | tee -a ./$outfile &>/dev/null

echo -e "-------------------OUTPUT OF UNAME -A COMMAND------------/n" | tee -a ./$outfile &>/dev/null
uname -a | tee -a $outfile &>/dev/null
seperator

echo -e "Getting Processes"
echo -e "-----------------RESULTS OF COMMAND PS -EF--------------------/n" | tee -a ./$outfile &>/dev/null
ps -ef | tee -a ./$outfile &>/dev/null

echo -e "Getting Services"
echo -e "---------------------------------LIST ALL INSTALLED SERVICES ----------/n" | tee -a ./$outfile &>/dev/null
svcs -aHpv | tee -a ./$outfile &>/dev/null
seperator
echo -e "Getting All Package Info"
echo -r "----------------------------------LIST ALL PACKAGES--------------------/n" | tee -a ./$outfile &>/dev/null
pkginfo -l | tee -a ./$outfile &>/dev/null
seperator

echo -e "Getting all User Info"
echo -e "----------------------------------USER INFROMATION---------------------/n" | tee -a ./$outfile &>/dev/null
cat /etc/passwd | tee -a ./$outfile &>/dev/null
echo -e "--------------------------ALL KNOWN USERS-----------------------------/n" | tee -a ./$outfile &>/dev/null
getent passwd | tee -a ./$outfile &>/dev/null
echo -e "-------------------------ALL VALID USERS-----------------------------/n" | tee -a ./$outfile &>/dev/null
dispuid | tee -a ./$outfile &>/dev/null

seperator

echo -e "Getting all Group Info"
echo -e "--------------------------------------GROUPS--------------------------/n" | tee -a ./$outfile &>/dev/null

groups | tee -a ./$outfile &>/dev/null
cat /etc/group | tee -a ./$outfile &>/dev/null

seperator
echo -e "---------------------------------UID 0 Users--------------------------/n" | tee -a ./$outfile &>/dev/null
awk -F: '($3 == 0){print $1}' /etc/passwd | tee -a ./$outfile &>/dev/null

seperator
echo -e "Getting Network information"

echo -r "-----------------------NETWORK CONNECTIONS-------------------/n" | tee -a ./$outfile &>/dev/null
echo -e "----------------IFCONFIG-------------------------------------/n" | tee -a ./$outfile &>/dev/null
/usr/sbin/ifconfig -a | tee -a ./$outfile &>/dev/null
seperator
echo -e "------------------------NETSTATS-----------------------------/n" | tee -a ./$outfile &>/dev/null
netstat -i | tee -a $outfile &>/dev/null
seperator
netstat -p | tee -a $outfile &>/dev/null
seperator
netstat -anv | tee -a $outfile &>/dev/null
seperator
netstat -m | tee -a $outfile &>/dev/null
seperator
echo -e " -----------------------ETC Resolve.Conf and ETC HOSTS--------------------------------/n" | tee -a ./$outfile &>/dev/null
cat /etc/hosts | tee -a ./$outfile &>/dev/null
seperator
cat /etc/resolv.conf | tee -a $./outfile &>/dev/null

echo -e "--------------------------------------FILES AND DIRs----------------------/n" | tee -a ./$outfile &>/dev/null
echo -e "Enumerating Files and Directories"
find / -mtime -10 -ls 2>&1 | grep -v "Permission denied" | tee -a ./$(hostname)_modded_files.txt &>/dev/null
ls -lat | tee -a ./$(hostname)_modded_files.txt &>/dev/null
echo -e "----------------------------------SUID and GUID FILES---------------------/n" | tee -a ./$outfile &>/dev/null
find / -type f -perm /4000 2>/dev/null | tee -a ./$outfile &>/dev/null
find / -type f -perm /2000 2>/dev/null | tee -a ./$outfile &>/dev/null
echo -e "---------------------------------HIDDEN FILES---------------------------------/n" | tee -a ./$outfile &>/dev/null
#find / -type f -name '.*' -exec ls-l {}\+ | tee -a ./$outfile &>/dev/null

echo -e "---------------------------------------Crontab-------------------------------/n" | tee -a ./$outfile &>/dev/null
ls -al /etc/cron.* | tee -a ./$outfile &>/dev/null
echo -e "-------------------------------------RC START SCRIPTS-------------------------/n" | tee -a ./$outfile &>/dev/null
ls -al /etc/rc*.d | tee -a ./$outfile &>/dev/null
echo -e "------------------------------------FILES AND DIRs WITHOUT OWNERSHIP----------/n" | tee -a ./$outfile &>/dev/null
find / -group nobody 2>&1 | grep -v "Permission denied" | tee -a ./$outfile &>/dev/null
find / -user nobody 2>&1 | grep -v "Permission denied" | tee -a ./$outfile &>/dev/null
echo -e "-----------------------------------WORLD WRITABLE AND DIRECTORIES-------------------/n" | tee -a ./$outfile &>/dev/null
find / -perm -0002 -type d -print 2>&1 | grep -v "Permission denied" | tee -a ./$outfile &>/dev/null
find / -perm -0002 -type f -print 2>&1 | grep -v "Permission denied" | tee -a ./$outfile &>/dev/null
seperator
echo -e "Enumerating Mounts and Partitions"
echo -e "------------------------------------MOUNTS AND PARTITIONS---------------------/n" | tee -a ./$outfile &>/dev/null
df -a | tee -a ./$outfile &>/dev/null
vmstat -s | tee -a ./$outfile &>/dev/null
iostat -En | tee -a ./$outfile &>/dev/null

mkdir ./history
find /history/ -name 'history*' -type f  -size +0 -exec cp -p {} ./history/ \; &>/dev/null
#cp /history/* ./history/ | &>/dev/null
echo -e "done"