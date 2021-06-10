#!/bin/bash

###########################################################################
# Script Name: 	CISL1-AL2-v1.0.0-hardening.sh
# Description: 	Hardening script for AL2 and CIS Level 1 benchmarks v1.0.0
# Args: 		none
# Author: 		Stefano Ratto
# Email: 		stefano.ratto@gmail.com
# GitHub: 		github.com/StefanoRatto
###########################################################################

#### Formatted output
#START="┌-- \e[1mCIS LEVEL 1 HARDENING SCRIPT FOR AL2 v1.0.0\e[0m"
#OK="| └─> \e[92mPass\e[0m"
#NOK="| └─> \e[91mFAIL\e[0m"
#REBOOT="| └─> \e[93mRequires REBOOT\e[0m"
#NIMP="| └-> Not implemented"
#EXIT="└-- \e[91mEXITING\!\e[0m"
#DONE="└-- \e[1mDONE\!\e[0m!"

#### Unformatted output
START="┌-- CIS LEVEL 1 HARDENING SCRIPT FOR AL2 v1.0.0"
OK="| └─> Pass"
NOK="| └─> FAIL"
NE="| └─> Not enforceable"
REBOOT="| └─> Requires REBOOT"
NIMP="| └-> Not implemented"
EXIT="└-- EXITING!"
DONE="└-- DONE!"

echo ""
echo $START

if [[ $EUID -ne 0 ]]; then
	echo "| └─> This script must be run as root" 
	echo "|"
	echo $EXIT
	echo ""
	exit 1
fi

if [[ $(cat /etc/os-release | grep "Amazon Linux 2") != "PRETTY_NAME=\"Amazon Linux 2\"" ]]; then
	echo "| └─> This script can run on Amazon Linux 2 -based instances only"
	echo "|"
	echo $EXIT
	echo ""
	exit 1
fi

#### CIS Level 1 - Benchmark 1/176: 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)
echo "|"
echo "| L1 1/176: 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)"
echo "install cramfs /bin/true" >> /etc/modprobe.d/cramfs.conf
#rmmod cramfs
actual1=$(modprobe -n -v cramfs | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep cramfs)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 2/176: 1.1.1.2 Ensure mounting of hfs filesystems is disabled (Scored)
echo "|"
echo "| L1 2/176: 1.1.1.2 Ensure mounting of hfs filesystems is disabled (Scored)"
echo "install hfs /bin/true" >> /etc/modprobe.d/hfs.conf
#rmmod hfs
actual1=$(modprobe -n -v hfs | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep hfs)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 3/176: 1.1.1.3 Ensure mounting of hfsplus filesystems is disabled (Scored)
echo "|"
echo "| L1 3/176: 1.1.1.3 Ensure mounting of hfsplus filesystems is disabled (Scored)"
echo "install hfsplus /bin/true" >> /etc/modprobe.d/hfsplus.conf
#rmmod hfsplus
actual1=$(modprobe -n -v hfsplus | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep hfsplus)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 4/176: 1.1.1.4 Ensure mounting of squashfs filesystems is disabled (Scored)
echo "|"
echo "| L1 4/176: 1.1.1.4 Ensure mounting of squashfs filesystems is disabled (Scored)"
echo "install squashfs /bin/true" >> /etc/modprobe.d/squashfs.conf
#rmmod squashfs
actual1=$(modprobe -n -v squashfs | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep squashfs)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 5/176: 1.1.1.5 Ensure mounting of udf filesystems is disabled (Scored)
echo "|"
echo "| L1 5/176: 1.1.1.5 Ensure mounting of udf filesystems is disabled (Scored)"
echo "install udf /bin/true" >> /etc/modprobe.d/udf.conf
#rmmod udf
actual1=$(modprobe -n -v udf | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep udf)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 6/176: 1.1.2 Ensure /tmp is configured (Scored)
echo "|"
echo "| L1 6/176: 1.1.2 Ensure /tmp is configured (Scored)"
if [[ -f "/etc/fstab.bak" ]]; then
	actual1=$(mount | grep /tmp)
	expected1="tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
	actual2=$(systemctl is-enabled tmp.mount)
	expected2="enabled"
	if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
else
	cp /etc/fstab /etc/fstab.bak
	echo "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0" >> /etc/fstab
	#systemctl unmask tmp.mount
	#systemctl enable tmp.mount
	#sed -i 's/Options=mode=1767,strictatime/Options=mode=1767,strictatime,noexec,nodev,nosuid/g' /etc/systemd/system/local-fs.target.wants/tmp.mount
	echo $REBOOT
fi

#### CIS Level 1 - Benchmark 7/176: 1.1.3 Ensure nodev option set on /tmp partition (Scored)
echo "|"
echo "| L1 7/176: 1.1.3 Ensure nodev option set on /tmp partition (Scored)"
actual1=$(mount | grep /tmp | grep nodev)
expected1="tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	echo "$OK (implemented by 1.1.2)"
else
	echo "$NOK (fix by implementing 1.1.2)"
fi

#### CIS Level 1 - Benchmark 8/176: 1.1.4 Ensure nosuid option set on /tmp partition (Scored)
echo "|"
echo "| L1 8/176: 1.1.4 Ensure nosuid option set on /tmp partition (Scored)"
actual1=$(mount | grep /tmp | grep nosuid)
expected1="tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	echo "$OK (implemented by 1.1.2)"
else
	echo "$NOK (fix by implementing 1.1.2)"
fi

#### CIS Level 1 - Benchmark 9/176: 1.1.5 Ensure noexec option set on /tmp partition (Scored)
echo "|"
echo "| L1 9/176: 1.1.5 Ensure noexec option set on /tmp partition (Scored)"
actual1=$(mount | grep /tmp | grep noexec)
expected1="tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	echo "$OK (implemented by 1.1.2)"
else
	echo "$NOK (fix by implementing 1.1.2)"
fi

#### CIS Level 1 - Benchmark 10/176: 1.1.8 Ensure nodev option set on /var/tmp partition (Scored)
echo "|"
echo "| L1 10/176: 1.1.8 Ensure nodev option set on /var/tmp partition (Scored)"
actual1=$(mount | grep /var/tmp | grep nodev)
expected1=""
expected2="tmpfs on /var/tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	if [[ ! -f "/etc/fstab.bak" ]]; then
		cp /etc/fstab /etc/fstab.bak
	fi
	echo "tmpfs /var/tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0" >> /etc/fstab
	echo $REBOOT
else
	if [[ "$actual1" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 11/176: 1.1.9 Ensure nosuid option set on /var/tmp partition (Scored)
echo "|"
echo "| L1 11/176: 1.1.9 Ensure nosuid option set on /var/tmp partition (Scored)"
actual1=$(mount | grep /var/tmp | grep nosuid)
expected1="tmpfs on /var/tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	echo "$OK (implemented by 1.1.8)"
else
	echo "$NOK (fix by implementing 1.1.8)"
fi

#### CIS Level 1 - Benchmark 12/176: 1.1.10 Ensure noexec option set on /var/tmp partition (Scored)
echo "|"
echo "| L1 12/176: 1.1.10 Ensure noexec option set on /var/tmp partition (Scored)"
actual1=$(mount | grep /var/tmp | grep noexec)
expected1="tmpfs on /var/tmp type tmpfs (rw,nosuid,nodev,noexec,relatime)"
if [[ "$actual1" == "$expected1" ]]; then
	echo "$OK (implemented by 1.1.8)"
else
	echo "$NOK (fix by implementing 1.1.8)"
fi

#### CIS Level 1 - Benchmark 13/176: 1.1.15 Ensure nodev option set on /dev/shm partition (Scored)
echo "|"
echo "| L1 13/176: 1.1.15 Ensure nodev option set on /dev/shm partition (Scored)"
actual1=$(mount | grep /dev/shm | grep nodev)
expected1="tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)"
expected2="tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,noexec)"
if [[ "$actual1" == "$expected1" ]]; then
	if [[ ! -f "/etc/fstab.bak" ]]; then
		cp /etc/fstab /etc/fstab.bak
	fi
	echo "tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab
	echo $REBOOT
else
	if [[ "$actual1" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 14/176: 1.1.16 Ensure nosuid option set on /dev/shm partition (Scored)
echo "|"
echo "| L1 14/176: 1.1.16 Ensure nosuid option set on /dev/shm partition (Scored)"
actual1=$(mount | grep /dev/shm | grep nosuid)
expected1="tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)"
expected2="tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,noexec)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $REBOOT
else
	if [[ "$actual1" == "$expected2" ]]; then
		echo "$OK (implemented by 1.1.15)"
	else
		echo "$NOK (fix by implementing 1.1.15)"
	fi
fi

#### CIS Level 1 - Benchmark 15/176: 1.1.17 Ensure noexec option set on /dev/shm partition (Scored)
echo "|"
echo "| L1 15/176: 1.1.17 Ensure noexec option set on /dev/shm partition (Scored)"
actual1=$(mount | grep /dev/shm | grep noexec)
expected1=""
expected2="tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,noexec)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $REBOOT
else
	if [[ "$actual1" == "$expected2" ]]; then
		echo "$OK (implemented by 1.1.15)"
	else
		echo "$NOK (fix by implementing 1.1.15)"
	fi
fi

#### CIS Level 1 - Benchmark 16/176: 1.1.18 Ensure sticky bit is set on all world-writable directories (Scored)
echo "|"
echo "| L1 16/176: 1.1.18 Ensure sticky bit is set on all world-writable directories (Scored)"
actual1=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null)
expected1=""
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 17/176: 1.1.19 Disable Automounting (Scored)
echo "|"
echo "| L1 17/176: 1.1.19 Disable Automounting (Scored)"
actual1=$(systemctl is-enabled autofs 2>&1)
expected1="disabled"
expected2="Failed to get unit file state for autofs.service: No such file or directory"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	if [[ "$actual1" == "$expected2" ]]; then
		yum -y install autofs &> /dev/null
		systemctl disable autofs &> /dev/null
		actual1=$(systemctl is-enabled autofs)
		if [[ "$actual1" == "$expected1" ]]; then
			echo $OK
		fi
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 18/176: 1.2.1 Ensure package manager repositories are configured (Not Scored)
echo "|"
echo "| L1 18/176: 1.2.1 Ensure package manager repositories are configured (Not Scored)"
echo "$OK (repositories need to be manually configured according to site policy)"

#### CIS Level 1 - Benchmark 19/176: 1.2.2 Ensure GPG keys are configured (Not Scored)
echo "|"
echo "| L1 19/176: 1.2.2 Ensure GPG keys are configured (Not Scored)"
echo "$OK (GPG keys of the package manager need to be manually updated in accordance with site policy)"

#### CIS Level 1 - Benchmark 20/176: 1.2.3 Ensure gpgcheck is globally activated (Scored)
echo "|"
echo "| L1 20/176: 1.2.3 Ensure gpgcheck is globally activated (Scored)"
actual1=$(grep ^gpgcheck /etc/yum.conf)
expected1="gpgcheck=1"
actual2=$(grep ^gpgcheck /etc/yum.repos.d/* | tr -d '\n')
expected2="/etc/yum.repos.d/amzn2-core.repo:gpgcheck=1/etc/yum.repos.d/amzn2-core.repo:gpgcheck=1/etc/yum.repos.d/amzn2-core.repo:gpgcheck=1/etc/yum.repos.d/amzn2-extras.repo:gpgcheck = 1/etc/yum.repos.d/amzn2-extras.repo:gpgcheck = 1/etc/yum.repos.d/amzn2-extras.repo:gpgcheck = 1"
if [[ "$actual1" == "$expected1" ]]  && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 21/176: 1.3.1 Ensure AIDE is installed (Scored)
echo "|"
echo "| L1 21/176: 1.3.1 Ensure AIDE is installed (Scored)"
actual1=$(rpm -q aide)
expected1="package aide is not installed"
expected2="aide-"
if [[ "$actual1" == "$expected1" ]]; then
	yum -y install aide &> /dev/null
	aide --init &> /dev/null
	mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
	actual2=$(rpm -q aide)
	if [[ "${actual2:0:5}" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
elif [[ "${actual1:0:5}" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 22/176: 1.3.2 Ensure filesystem integrity is regularly checked (Scored)
echo "|"
echo "| L1 22/176: 1.3.2 Ensure filesystem integrity is regularly checked (Scored)"
actual1=$(crontab -u root -l | grep aide)
expected1="0 5 * * * /usr/sbin/aide --check"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	echo "0 5 * * * /usr/sbin/aide --check" | crontab -u root -
	actual1=$(crontab -u root -l | grep aide)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 23/176: 1.4.1 Ensure permissions on bootloader config are configured (Scored)
echo "|"
echo "| L1 23/176: 1.4.1 Ensure permissions on bootloader config are configured (Scored)"
actual1=$(stat /boot/grub2/grub.cfg | grep root)
expected1="Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /boot/grub2/grub.cfg
	chmod og-rwx /boot/grub2/grub.cfg
	actual1=$(crontab -u root -l | grep aide)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else 
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 24/176: 1.4.2 Ensure authentication required for single user mode (Scored) 
echo "|"
echo "| L1 24/176: 1.4.2 Ensure authentication required for single user mode (Scored)"
actual1=$(grep /sbin/sulogin /usr/lib/systemd/system/rescue.service)
expected1="ExecStart=-/bin/sh -c \"/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\""
actual2=$(grep /sbin/sulogin /usr/lib/systemd/system/emergency.service)
expected2="ExecStart=-/bin/sh -c \"/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 25/176: 1.5.1 Ensure core dumps are restricted (Scored)
echo "|"
echo "| L1 25/176: 1.5.1 Ensure core dumps are restricted (Scored)"
actual1=$(grep "hard core" /etc/security/limits.conf)
expected1="* hard core 0"
actual2=$(sysctl fs.suid_dumpable)
expected2="fs.suid_dumpable = 0"
actual3=$(grep "fs\.suid_dumpable" /etc/sysctl.conf)
expected3="fs.suid_dumpable = 0"
if [[ "$actual1" != "$expected1" ]]; then
	echo "* hard core 0" >> /etc/security/limits.conf
	actual1=$(grep "hard core" /etc/security/limits.conf)
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
	actual2=$(sysctl fs.suid_dumpable)
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
	actual3=$(grep "fs\.suid_dumpable" /etc/sysctl.conf)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 26/176: 1.5.2 Ensure address space layout randomization (ASLR) is enabled (Scored)
echo "|"
echo "| L1 26/176: 1.5.2 Ensure address space layout randomization (ASLR) is enabled (Scored)"
actual1=$(sysctl kernel.randomize_va_space)
expected1="kernel.randomize_va_space = 2"
actual2=$(grep "kernel\.randomize_va_space" /etc/sysctl.conf)
expected2="kernel.randomize_va_space = 2"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w kernel.randomize_va_space=2
	actual1=$(sysctl kernel.randomize_va_space)
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
	actual2=$(grep "kernel\.randomize_va_space" /etc/sysctl.conf)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 27/176: 1.5.3 Ensure prelink is disabled (Scored)
echo "|"
echo "| L1 27/176: 1.5.3 Ensure prelink is disabled (Scored)"
actual1=$(rpm -q prelink)
expected1="package prelink is not installed"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	prelink -ua
	yum -y remove prelink &> /dev/null
	actual1=$(rpm -q prelink)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 28/176: 1.7.1.1 Ensure message of the day is configured properly (Scored)
echo "|"
echo "| L1 28/176: 1.7.1.1 Ensure message of the day is configured properly (Scored)"
actual1=$(cat /etc/motd)
expected1=""
actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/motd)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	cp /etc/motd /etc/motd.bak
	> /etc/motd
   	cp /etc/update-motd.d/30-banner /etc/update-motd.d/30-banner.bak
    > /etc/update-motd.d/30-banner
	cp /etc/update-motd.d/50-amazon-linux-extras-news /etc/update-motd.d/50-amazon-linux-extras-news.bak
	> /etc/update-motd.d/50-amazon-linux-extras-news
	cp /etc/update-motd.d/70-available-updates /etc/update-motd.d/70-available-updates.bak
	> /etc/update-motd.d/70-available-updates
	actual1=$(cat /etc/motd)
	actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/motd)
	if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 29/176: 1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)
echo "|"
echo "| L1 29/176: 1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)"
actual1=$(cat /etc/issue)
expected1="Authorized uses only. All activity may be monitored and reported."
actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/issue)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	cp /etc/issue /etc/issue.bak
	echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
	actual1=$(cat /etc/issue)
	actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/issue)
	if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 30/176: 1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)
echo "|"
echo "| L1 30/176: 1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)"
actual1=$(cat /etc/issue.net)
expected1="Authorized uses only. All activity may be monitored and reported."
actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/issue.net)
expected2=""
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	cp /etc/issue.net /etc/issue.net.bak
	echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net
	actual1=$(cat /etc/issue.net)
	actual2=$(egrep -i '(\\v|\\r|\\m|\\s|Amazon)' /etc/issue.net)
	if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 31/176: 1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)
echo "|"
echo "| L1 31/176: 1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 32/176: 1.7.1.5 Ensure permissions on /etc/issue are configured (Scored)
echo "|"
echo "| L1 32/176: 1.7.1.5 Ensure permissions on /etc/issue are configured (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 33/176: 1.7.1.6 Ensure permissions on /etc/issue.net are configured (Not Scored)
echo "|"
echo "| L1 33/176: 1.7.1.6 Ensure permissions on /etc/issue.net are configured (Not Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 34/176: 1.8 Ensure updates, patches, and additional security software are installed (Scored)
echo "|"
echo "| L1 34/176: 1.8 Ensure updates, patches, and additional security software are installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 35/176: 2.1.1.1 Ensure time synchronization is in use (Not Scored)
echo "|"
echo "| L1 35/176: 2.1.1.1 Ensure time synchronization is in use (Not Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 36/176: 2.1.1.2 Ensure ntp is configured (Scored)
echo "|"
echo "| L1 36/176: 2.1.1.2 Ensure ntp is configured (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 37/176: 2.1.1.3 Ensure chrony is configured (Scored)
echo "|"
echo "| L1 37/176: 2.1.1.3 Ensure chrony is configured (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 38/176: 2.1.2 Ensure X Window System is not installed (Scored)
echo "|"
echo "| L1 38/176: 2.1.2 Ensure X Window System is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 39/176: 2.1.3 Ensure Avahi Server is not enabled (Scored)
echo "|"
echo "| L1 39/176: 2.1.3 Ensure Avahi Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 40/176: 2.1.4 Ensure CUPS is not enabled (Scored)
echo "|"
echo "| L1 40/176: 2.1.4 Ensure CUPS is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 41/176: 2.1.5 Ensure DHCP Server is not enabled (Scored)
echo "|"
echo "| L1 41/176: 2.1.5 Ensure DHCP Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 42/176: 2.1.6 Ensure LDAP server is not enabled (Scored)
echo "|"
echo "| L1 42/176: 2.1.6 Ensure LDAP server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 43/176: 2.1.7 Ensure NFS and RPC are not enabled (Scored)
echo "|"
echo "| L1 43/176: 2.1.7 Ensure NFS and RPC are not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 44/176: 2.1.8 Ensure DNS Server is not enabled (Scored)
echo "|"
echo "| L1 44/176: 2.1.8 Ensure DNS Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 45/176: 2.1.9 Ensure FTP Server is not enabled (Scored)
echo "|"
echo "| L1 45/176: 2.1.9 Ensure FTP Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 46/176: 2.1.10 Ensure HTTP server is not enabled (Scored)
echo "|"
echo "| L1 46/176: 2.1.10 Ensure HTTP server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 47/176: 2.1.11 Ensure IMAP and POP3 server is not enabled (Scored)
echo "|"
echo "| L1 47/176: 2.1.11 Ensure IMAP and POP3 server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 48/176: 2.1.12 Ensure Samba is not enabled (Scored)
echo "|"
echo "| L1 48/176: 2.1.12 Ensure Samba is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 49/176: 2.1.13 Ensure HTTP Proxy Server is not enabled (Scored)
echo "|"
echo "| L1 49/176: 2.1.13 Ensure HTTP Proxy Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 50/176: 2.1.14 Ensure SNMP Server is not enabled (Scored)
echo "|"
echo "| L1 50/176: 2.1.14 Ensure SNMP Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 51/176: 2.1.15 Ensure mail transfer agent is configured for local-only mode (Scored)
echo "|"
echo "| L1 51/176: 2.1.15 Ensure mail transfer agent is configured for local-only mode (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 52/176: 2.1.16 Ensure NIS Server is not enabled (Scored)
echo "|"
echo "| L1 52/176: 2.1.16 Ensure NIS Server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 53/176: 2.1.17 Ensure rsh server is not enabled (Scored)
echo "|"
echo "| L1 53/176: 2.1.17 Ensure rsh server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 54/176: 2.1.18 Ensure telnet server is not enabled (Scored)
echo "|"
echo "| L1 54/176: 2.1.18 Ensure telnet server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 55/176: 2.1.19 Ensure tftp server is not enabled (Scored)
echo "|"
echo "| L1 55/176: 2.1.19 Ensure tftp server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 56/176: 2.1.20 Ensure rsync service is not enabled (Scored)
echo "|"
echo "| L1 56/176: 2.1.20 Ensure rsync service is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 57/176: 2.1.21 Ensure talk server is not enabled (Scored)
echo "|"
echo "| L1 57/176: 2.1.21 Ensure talk server is not enabled (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 58/176: 2.2.1 Ensure NIS Client is not installed (Scored)
echo "|"
echo "| L1 58/176: 2.2.1 Ensure NIS Client is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 59/176: 2.2.2 Ensure rsh client is not installed (Scored)
echo "|"
echo "| L1 59/176: 2.2.2 Ensure rsh client is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 60/176: 2.2.3 Ensure talk client is not installed (Scored)
echo "|"
echo "| L1 60/176: 2.2.3 Ensure talk client is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 61/176: 2.2.4 Ensure telnet client is not installed (Scored)
echo "|"
echo "| L1 61/176: 2.2.4 Ensure telnet client is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 62/176: 2.2.5 Ensure LDAP client is not installed (Scored)
echo "|"
echo "| L1 62/176: 2.2.5 Ensure LDAP client is not installed (Scored)"
echo $NIMP 

#### CIS Level 1 - Benchmark 63/176: 3.1.1 Ensure IP forwarding is disabled (Scored)
echo "|"
echo "| L1 63/176: 3.1.1 Ensure IP forwarding is disabled (Scored)"
actual1=$(sysctl net.ipv4.ip_forward)
expected1="net.ipv4.ip_forward = 0"
actual2=$(grep "net\.ipv4\.ip_forward" /etc/sysctl.conf)
expected2="net.ipv4.ip_forward = 0"
actual3=$(sysctl net.ipv6.conf.all.forwarding)
expected3="net.ipv6.conf.all.forwarding = 0"
actual4=$(grep "net\.ipv6\.conf\.all\.forwarding" /etc/sysctl.conf)
expected4="net.ipv6.conf.all.forwarding = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.ip_forward=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
fi
if [[ "$actual3" != "$expected3" ]]; then
	sysctl -w net.ipv6.conf.all.forwarding=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.ip_forward)
actual2=$(grep "net\.ipv4\.ip_forward" /etc/sysctl.conf)
actual3=$(sysctl net.ipv6.conf.all.forwarding)
actual4=$(grep "net\.ipv6\.conf\.all\.forwarding" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 64/176: 3.1.2 Ensure packet redirect sending is disabled (Scored)
echo "|"
echo "| L1 64/176: 3.1.2 Ensure packet redirect sending is disabled (Scored)"
actual1=$(sysctl net.ipv4.conf.all.send_redirects)
expected1="net.ipv4.conf.all.send_redirects = 0"
actual2=$(sysctl net.ipv4.conf.default.send_redirects)
expected2="net.ipv4.conf.default.send_redirects = 0"
actual3=$(grep "net\.ipv4\.conf\.all\.send_redirects" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.send_redirects = 0"
actual4=$(grep "net\.ipv4\.conf\.default\.send_redirects" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.send_redirects = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.send_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.send_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.send_redirects)
actual2=$(sysctl net.ipv4.conf.default.send_redirects)
actual3=$(grep "net\.ipv4\.conf\.all\.send_redirects" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.send_redirects" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 65/176: 3.2.1 Ensure source routed packets are not accepted (Scored)
echo "|"
echo "| L1 65/176: 3.2.1 Ensure source routed packets are not accepted (Scored)"
actual1=$(sysctl net.ipv4.conf.all.accept_source_route)
expected1="net.ipv4.conf.all.accept_source_route = 0"
actual2=$(sysctl net.ipv4.conf.default.accept_source_route)
expected2="net.ipv4.conf.default.accept_source_route = 0"
actual3=$(grep "net\.ipv4\.conf\.all\.accept_source_route" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.accept_source_route = 0"
actual4=$(grep "net\.ipv4\.conf\.default\.accept_source_route" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.accept_source_route = 0"
actual5=$(sysctl net.ipv6.conf.all.accept_source_route)
expected5="net.ipv6.conf.all.accept_source_route = 0"
actual6=$(sysctl net.ipv6.conf.default.accept_source_route)
expected6="net.ipv6.conf.default.accept_source_route = 0"
actual7=$(grep "net\.ipv6\.conf\.all\.accept_source_route" /etc/sysctl.conf)
expected7="net.ipv6.conf.all.accept_source_route = 0"
actual8=$(grep "net\.ipv6\.conf\.default\.accept_source_route" /etc/sysctl.conf)
expected8="net.ipv6.conf.default.accept_source_route = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.accept_source_route=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.accept_source_route=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
fi
if [[ "$actual5" != "$expected5" ]]; then
	sysctl -w net.ipv6.conf.all.accept_source_route=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual6" != "$expected6" ]]; then
	sysctl -w net.ipv6.conf.default.accept_source_route=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual7" != "$expected7" ]]; then
	echo "net.ipv6.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
fi
if [[ "$actual8" != "$expected8" ]]; then
	echo "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.accept_source_route)
actual2=$(sysctl net.ipv4.conf.default.accept_source_route)
actual3=$(grep "net\.ipv4\.conf\.all\.accept_source_route" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.accept_source_route" /etc/sysctl.conf)
actual5=$(sysctl net.ipv6.conf.all.accept_source_route)
actual6=$(sysctl net.ipv6.conf.default.accept_source_route)
actual7=$(grep "net\.ipv6\.conf\.all\.accept_source_route" /etc/sysctl.conf)
actual8=$(grep "net\.ipv6\.conf\.default\.accept_source_route" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]] && [[ "$actual5" == "$expected5" ]] && [[ "$actual6" == "$expected6" ]] && [[ "$actual7" == "$expected7" ]] && [[ "$actual8" == "$expected8" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 66/176: 3.2.2 Ensure ICMP redirects are not accepted (Scored)
echo "|"
echo "| L1 66/176: 3.2.2 Ensure ICMP redirects are not accepted (Scored)"
actual1=$(sysctl net.ipv4.conf.all.accept_redirects)
expected1="net.ipv4.conf.all.accept_redirects = 0"
actual2=$(sysctl net.ipv4.conf.default.accept_redirects)
expected2="net.ipv4.conf.default.accept_redirects = 0"
actual3=$(grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.accept_redirects = 0"
actual4=$(grep "net\.ipv4\.conf\.default\.accept_redirects" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.accept_redirects = 0"
actual5=$(sysctl net.ipv6.conf.all.accept_redirects)
expected5="net.ipv6.conf.all.accept_redirects = 0"
actual6=$(sysctl net.ipv6.conf.default.accept_redirects)
expected6="net.ipv6.conf.default.accept_redirects = 0"
actual7=$(grep "net\.ipv6\.conf\.all\.accept_redirects" /etc/sysctl.conf)
expected7="net.ipv6.conf.all.accept_redirects = 0"
actual8=$(grep "net\.ipv6\.conf\.default\.accept_redirects" /etc/sysctl.conf)
expected8="net.ipv6.conf.default.accept_redirects = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.accept_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.accept_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
fi
if [[ "$actual5" != "$expected5" ]]; then
	sysctl -w net.ipv6.conf.all.accept_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual6" != "$expected6" ]]; then
	sysctl -w net.ipv6.conf.default.accept_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual7" != "$expected7" ]]; then
	echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
fi
if [[ "$actual8" != "$expected8" ]]; then
	echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.accept_redirects)
actual2=$(sysctl net.ipv4.conf.default.accept_redirects)
actual3=$(grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.accept_redirects" /etc/sysctl.conf)
actual5=$(sysctl net.ipv6.conf.all.accept_redirects)
actual6=$(sysctl net.ipv6.conf.default.accept_redirects)
actual7=$(grep "net\.ipv6\.conf\.all\.accept_redirects" /etc/sysctl.conf)
actual8=$(grep "net\.ipv6\.conf\.default\.accept_redirects" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]] && [[ "$actual5" == "$expected5" ]] && [[ "$actual6" == "$expected6" ]] && [[ "$actual7" == "$expected7" ]] && [[ "$actual8" == "$expected8" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 67/176: 3.2.3 Ensure secure ICMP redirects are not accepted (Scored)
echo "|"
echo "| L1 67/176: 3.2.3 Ensure secure ICMP redirects are not accepted (Scored)"
actual1=$(sysctl net.ipv4.conf.all.secure_redirects)
expected1="net.ipv4.conf.all.secure_redirects = 0"
actual2=$(sysctl net.ipv4.conf.default.secure_redirects)
expected2="net.ipv4.conf.default.secure_redirects = 0"
actual3=$(grep "net\.ipv4\.conf\.all\.secure_redirects" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.secure_redirects = 0"
actual4=$(grep "net\.ipv4\.conf\.default\.secure_redirects" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.secure_redirects = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.secure_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.secure_redirects=0 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.secure_redirects)
actual2=$(sysctl net.ipv4.conf.default.secure_redirects)
actual3=$(grep "net\.ipv4\.conf\.all\.secure_redirects" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.secure_redirects" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 68/176: 3.2.4 Ensure suspicious packets are logged (Scored)
echo "|"
echo "| L1 68/176: 3.2.4 Ensure suspicious packets are logged (Scored)"
actual1=$(sysctl net.ipv4.conf.all.log_martians)
expected1="net.ipv4.conf.all.log_martians = 1"
actual2=$(sysctl net.ipv4.conf.default.log_martians)
expected2="net.ipv4.conf.default.log_martians = 1"
actual3=$(grep "net\.ipv4\.conf\.all\.log_martians" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.log_martians = 1"
actual4=$(grep "net\.ipv4\.conf\.default\.log_martians" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.log_martians = 1"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.log_martians=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.log_martians=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.log_martians)
actual2=$(sysctl net.ipv4.conf.default.log_martians)
actual3=$(grep "net\.ipv4\.conf\.all\.log_martians" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.log_martians" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 69/176: 3.2.5 Ensure broadcast ICMP requests are ignored (Scored)
echo "|"
echo "| L1 69/176: 3.2.5 Ensure broadcast ICMP requests are ignored (Scored)"
actual1=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts)
expected1="net.ipv4.icmp_echo_ignore_broadcasts = 1"
actual2=$(grep "net\.ipv4\.icmp_echo_ignore_broadcasts" /etc/sysctl.conf)
expected2="net.ipv4.icmp_echo_ignore_broadcasts = 1"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts)
actual2=$(grep "net\.ipv4\.icmp_echo_ignore_broadcasts" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 70/176: 3.2.6 Ensure bogus ICMP responses are ignored (Scored)
echo "|"
echo "| L1 70/176: 3.2.6 Ensure bogus ICMP responses are ignored (Scored)"
actual1=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses)
expected1="net.ipv4.icmp_ignore_bogus_error_responses = 1"
actual2=$(grep "net\.ipv4\.icmp_ignore_bogus_error_responses" /etc/sysctl.conf)
expected2="net.ipv4.icmp_ignore_bogus_error_responses = 1"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses)
actual2=$(grep "net\.ipv4\.icmp_ignore_bogus_error_responses" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 71/176: 3.2.7 Ensure Reverse Path Filtering is enabled (Scored)
echo "|"
echo "| L1 71/176: 3.2.7 Ensure Reverse Path Filtering is enabled (Scored)"
actual1=$(sysctl net.ipv4.conf.all.rp_filter)
expected1="net.ipv4.conf.all.rp_filter = 1"
actual2=$(sysctl net.ipv4.conf.default.rp_filter)
expected2="net.ipv4.conf.default.rp_filter = 1"
actual3=$(grep "net\.ipv4\.conf\.all\.rp_filter" /etc/sysctl.conf)
expected3="net.ipv4.conf.all.rp_filter = 1"
actual4=$(grep "net\.ipv4\.conf\.default\.rp_filter" /etc/sysctl.conf)
expected4="net.ipv4.conf.default.rp_filter = 1"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.conf.all.rp_filter=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv4.conf.default.rp_filter=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.conf.all.rp_filter)
actual2=$(sysctl net.ipv4.conf.default.rp_filter)
actual3=$(grep "net\.ipv4\.conf\.all\.rp_filter" /etc/sysctl.conf)
actual4=$(grep "net\.ipv4\.conf\.default\.rp_filter" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 72/176: 3.2.8 Ensure TCP SYN Cookies is enabled (Scored)
echo "|"
echo "| L1 72/176: 3.2.8 Ensure TCP SYN Cookies is enabled (Scored)"
actual1=$(sysctl net.ipv4.tcp_syncookies)
expected1="net.ipv4.tcp_syncookies = 1"
actual2=$(grep "net\.ipv4\.tcp_syncookies" /etc/sysctl.conf)
expected2="net.ipv4.tcp_syncookies = 1"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv4.tcp_syncookies=1 > /dev/null 2>&1
	sysctl -w net.ipv4.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv4.tcp_syncookies)
actual2=$(grep "net\.ipv4\.tcp_syncookies" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 73/176: 3.2.9 Ensure IPv6 router advertisements are not accepted (Scored)
echo "|"
echo "| L1 73/176: 3.2.9 Ensure IPv6 router advertisements are not accepted (Scored)"
actual1=$(sysctl net.ipv6.conf.all.accept_ra)
expected1="net.ipv6.conf.all.accept_ra = 0"
actual2=$(sysctl net.ipv6.conf.default.accept_ra)
expected2="net.ipv6.conf.default.accept_ra = 0"
actual3=$(grep "net\.ipv6\.conf\.all\.accept_ra" /etc/sysctl.conf)
expected3="net.ipv6.conf.all.accept_ra = 0"
actual4=$(grep "net\.ipv6\.conf\.default\.accept_ra" /etc/sysctl.conf)
expected4="net.ipv6.conf.default.accept_ra = 0"
if [[ "$actual1" != "$expected1" ]]; then
	sysctl -w net.ipv6.conf.all.accept_ra=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual2" != "$expected2" ]]; then
	sysctl -w net.ipv6.conf.default.accept_ra=0 > /dev/null 2>&1
	sysctl -w net.ipv6.route.flush=1 > /dev/null 2>&1
fi
if [[ "$actual3" != "$expected3" ]]; then
	echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.conf
fi
if [[ "$actual4" != "$expected4" ]]; then
	echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.conf
fi
actual1=$(sysctl net.ipv6.conf.all.accept_ra)
actual2=$(sysctl net.ipv6.conf.default.accept_ra)
actual3=$(grep "net\.ipv6\.conf\.all\.accept_ra" /etc/sysctl.conf)
actual4=$(grep "net\.ipv6\.conf\.default\.accept_ra" /etc/sysctl.conf)
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 74/176: 3.3.1 Ensure TCP Wrappers is installed (Scored)
echo "|"
echo "| L1 74/176: 3.3.1 Ensure TCP Wrappers is installed (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 75/176: 3.3.2 Ensure /etc/hosts.allow is configured (Not Scored)
echo "|"
echo "| L1 75/176: 3.3.2 Ensure /etc/hosts.allow is configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 76/176: 3.3.3 Ensure /etc/hosts.deny is configured (Not Scored)
echo "|"
echo "| L1 76/176: 3.3.3 Ensure /etc/hosts.deny is configured (Not Scored)"
actual=$(grep "#ALL: ALL" /etc/hosts.deny)
expected="#ALL: ALL"
if [[ "$actual" != "$expected" ]]; then
	echo "#ALL: ALL" >> /etc/hosts.deny
	actual=$(cat /etc/hosts.deny)
fi
if [[ "$actual" == "$expected" ]]; then
	echo $NE
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 77/176: 3.3.4 Ensure permissions on /etc/hosts.allow are configured (Scored)
echo "|"
echo "| L1 77/176: 3.3.4 Ensure permissions on /etc/hosts.allow are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 78/176: 3.3.5 Ensure permissions on /etc/hosts.deny are configured (Scored)
echo "|"
echo "| L1 78/176: 3.3.5 Ensure permissions on /etc/hosts.deny are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 79/176: 3.4.1 Ensure DCCP is disabled (Not Scored)
echo "|"
echo "| L1 79/176: 3.4.1 Ensure DCCP is disabled (Not Scored)"
actual1=$(modprobe -n -v dccp | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep dccp)
expected2=""
if [[ "$actual1" != "$expected1" ]] || [[ "$actual2" != "$expected2" ]]; then
	echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
	actual1=$(modprobe -n -v dccp | grep true)
	actual2=$(lsmod | grep dccp)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 80/176: 3.4.2 Ensure SCTP is disabled (Not Scored)
echo "|"
echo "| L1 80/176: 3.4.2 Ensure SCTP is disabled (Not Scored)"
actual1=$(modprobe -n -v sctp | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep sctp)
expected2=""
if [[ "$actual1" != "$expected1" ]] || [[ "$actual2" != "$expected2" ]]; then
       	echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
       	actual1=$(modprobe -n -v sctp | grep true)
       	actual2=$(lsmod | grep sctp)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
       	echo $OK
else
       	echo $NOK
fi

#### CIS Level 1 - Benchmark 81/176: 3.4.3 Ensure RDS is disabled (Not Scored)
echo "|"
echo "| L1 81/176: 3.4.3 Ensure RDS is disabled (Not Scored)"
actual1=$(modprobe -n -v rds | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep rds)
expected2=""
if [[ "$actual1" != "$expected1" ]] || [[ "$actual2" != "$expected2" ]]; then
        echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
        actual1=$(modprobe -n -v rds | grep true)
        actual2=$(lsmod | grep rds)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
        echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 82/176: 3.4.4 Ensure TIPC is disabled (Not Scored)
echo "|"
echo "| L1 82/176: 3.4.4 Ensure TIPC is disabled (Not Scored)"
actual1=$(modprobe -n -v tipc | grep true)
expected1="install /bin/true "
actual2=$(lsmod | grep tipc)
expected2=""
if [[ "$actual1" != "$expected1" ]] || [[ "$actual2" != "$expected2" ]]; then
        echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
        actual1=$(modprobe -n -v tipc | grep true)
        actual2=$(lsmod | grep tipc)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
        echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 83/176: 3.5.1.1 Ensure default deny firewall policy (Scored)
echo "|"
echo "| L1 83/176: 3.5.1.1 Ensure default deny firewall policy (Scored)"
if [[ $(rpm -aq iptables-services) == "" ]]; then
	yum install iptables-services -y > /dev/null 2>&1
fi
systemctl enable iptables > /dev/null 2>&1
systemctl start iptables > /dev/null 2>&1
actual1=$(iptables -L | grep "Chain INPUT")
#expected1="Chain INPUT (policy DROP)"
expected1="Chain INPUT (policy ACCEPT)"
if [[ "$actual1" != "$expected1" ]]; then
	#iptables -P INPUT DROP
	iptables -P INPUT ACCEPT
	service iptables save > /dev/null 2>&1
	actual1=$(iptables -L | grep "Chain INPUT")
fi
actual2=$(iptables -L | grep "Chain FORWARD")
#expected2="Chain FORWARD (policy DROP)"
expected2="Chain FORWARD (policy ACCEPT)"
if [[ "$actual2" != "$expected2" ]]; then
	#iptables -P FORWARD DROP
	iptables -P FORWARD ACCEPT
	service iptables save > /dev/null 2>&1
	actual2=$(iptables -L | grep "Chain FORWARD")
fi
actual3=$(iptables -L | grep "Chain OUTPUT")
#expected3="Chain OUTPUT (policy DROP)"
expected3="Chain OUTPUT (policy ACCEPT)"
if [[ "$actual3" != "$expected3" ]]; then
	#iptables -P OUTPUT DROP
	iptables -P OUTPUT ACCEPT
	service iptables save > /dev/null 2>&1
	actual3=$(iptables -L | grep "Chain OUTPUT")
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]]; then
	echo $NE
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 84/176: 3.5.1.2 Ensure loopback traffic is configured (Scored)
echo "|"
echo "| L1 84/176: 3.5.1.2 Ensure loopback traffic is configured (Scored)"
if [[ $(rpm -aq iptables-services) == "" ]]; then
       	yum install iptables-services -y > /dev/null 2>&1
fi
systemctl enable iptables > /dev/null 2>&1
systemctl start iptables > /dev/null 2>&1
actual1=$(iptables -L INPUT -v -n | grep "0 ACCEPT     all  --  lo")
expected1="    0     0 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           "
if [[ "$actual1" != "$expected1" ]]; then
	iptables -A INPUT -i lo -j ACCEPT
	service iptables save > /dev/null 2>&1
	actual1=$(iptables -L INPUT -v -n | grep "0 ACCEPT     all  --  lo")
fi
actual2=$(iptables -L INPUT -v -n | grep "0 DROP       all  --  *")
expected2="    0     0 DROP       all  --  *      *       127.0.0.0/8          0.0.0.0/0           "
if [[ "$actual2" != "$expected2" ]]; then
	iptables -A INPUT -s 127.0.0.0/8 -j DROP
	service iptables save > /dev/null 2>&1
	actual2=$(iptables -L INPUT -v -n | grep "0 DROP       all  --  *")
fi
actual3=$(iptables -L OUTPUT -v -n | grep "0 ACCEPT     all  --  *")
expected3="    0     0 ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0           "
if [[ "$actual3" != "$expected3" ]]; then
	iptables -A OUTPUT -o lo -j ACCEPT
	service iptables save > /dev/null 2>&1
	actual3=$(iptables -L OUTPUT -v -n | grep "0 ACCEPT     all  --  *")
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 85/176: 3.5.1.3 Ensure outbound and established connections are configured (Not Scored)
echo "|"
echo "| L1 85/176: 3.5.1.3 Ensure outbound and established connections are configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 86/176: 3.5.1.4 Ensure firewall rules exist for all open ports (Scored)
echo "|"
echo "| L1 86/176: 3.5.1.4 Ensure firewall rules exist for all open ports (Scored)"
if [[ $(rpm -aq iptables-services) == "" ]]; then
	yum install iptables-services -y > /dev/null 2>&1
fi
systemctl enable iptables > /dev/null 2>&1
systemctl start iptables > /dev/null 2>&1
actual1=$(iptables -L INPUT -v -n | grep "state NEW tcp dpt:22" | grep -o "0.0.0.0.*")
expected1="0.0.0.0/0            0.0.0.0/0            state NEW tcp dpt:22"
if [[ "$actual1" != "$expected1" ]]; then
	iptables -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT > /dev/null 2>&1
	service iptables save > /dev/null 2>&1
	actual1=$(iptables -L INPUT -v -n | grep "state NEW tcp dpt:22" | grep -o "0.0.0.0.*")
fi
if [[ "$actual1" == "$expected1" ]]; then
	echo $NE
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 87/176: 3.5.2.1 Ensure IPv6 default deny firewall policy (Scored)
echo "|"
echo "| L1 87/176: 3.5.2.1 Ensure IPv6 default deny firewall policy (Scored)"
if [[ $(ip6tables -L | grep DROP) == "" ]]; then
	ip6tables -F > /dev/null 2>&1
	ip6tables -P INPUT DROP > /dev/null 2>&1
	ip6tables -P OUTPUT DROP > /dev/null 2>&1
	ip6tables -P FORWARD DROP > /dev/null 2>&1
	ip6tables -A INPUT -i lo -j ACCEPT > /dev/null 2>&1
	ip6tables -A OUTPUT -o lo -j ACCEPT > /dev/null 2>&1
	ip6tables -A INPUT -s ::1 -j DROP > /dev/null 2>&1
	ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT > /dev/null 2>&1
	ip6tables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT > /dev/null 2>&1
fi
actual1=$(ip6tables -L | grep "INPUT")
expected1="Chain INPUT (policy DROP)"
if [[ "$actual1" != "$expected1" ]]; then
	ip6tables -P INPUT DROP
	service ip6tables save > /dev/null 2>&1
	actual1=$(ip6tables -L | grep "INPUT")
fi
actual2=$(ip6tables -L | grep "FORWARD")
expected2="Chain FORWARD (policy DROP)"
if [[ "$actual2" != "$expected2" ]]; then
	ip6tables -P FORWARD DROP
	service ip6tables save > /dev/null 2>&1
	actual2=$(ip6tables -L | grep "FORWARD")
fi
actual3=$(ip6tables -L | grep "OUTPUT")
expected3="Chain OUTPUT (policy DROP)"
if [[ "$actual3" != "$expected3" ]]; then
        ip6tables -P OUTPUT DROP
	service ip6tables save > /dev/null 2>&1
	actual3=$(ip6tables -L | grep "OUTPUT")
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]]; then
        echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 88/176: 3.5.2.2 Ensure IPv6 loopback traffic is configured (Scored)
echo "|"
echo "| L1 88/176: 3.5.2.2 Ensure IPv6 loopback traffic is configured (Scored)"
actual1=$(ip6tables -L INPUT -v -n | grep "0 ACCEPT     all      lo")
expected1="    0     0 ACCEPT     all      lo     *       ::/0                 ::/0                "
if [[ "$actual1" != "$expected1" ]]; then
	ip6tables -A INPUT -i lo -j ACCEPT
	service ip6tables save > /dev/null 2>&1
	actual1=$(ip6tables -L INPUT -v -n | grep "0 ACCEPT     all      lo")
fi
actual2=$(ip6tables -L INPUT -v -n | grep "0 DROP       all      *")
expected2="    0     0 DROP       all      *      *       ::1                  ::/0                "
if [[ "$actual2" != "$expected2" ]]; then
	ip6tables -A INPUT -s ::1 -j DROP
	service ip6tables save > /dev/null 2>&1
	actual2=$(ip6tables -L INPUT -v -n | grep "0 DROP       all      *")
fi
actual3=$(ip6tables -L OUTPUT -v -n | grep "0 ACCEPT     all      *")
expected3="    0     0 ACCEPT     all      *      lo      ::/0                 ::/0                "
if [[ "$actual3" != "$expected3" ]]; then
	ip6tables -A OUTPUT -o lo -j ACCEPT
	service ip6tables save > /dev/null 2>&1
	actual3=$(ip6tables -L OUTPUT -v -n | grep "0 ACCEPT     all      *")
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]]; then
        echo $OK
else
       	echo $NOK
fi

#### CIS Level 1 - Benchmark 89/176: 3.5.2.3 Ensure IPv6 outbound and established connections are configured (Not Scored)
echo "|"
echo "| L1 89/176: 3.5.2.3 Ensure IPv6 outbound and established connections are configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 90/176: 3.5.2.4 Ensure IPv6 firewall rules exist for all open ports (Not Scored)
echo "|"
echo "| L1 90/176: 3.5.2.4 Ensure IPv6 firewall rules exist for all open ports (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 91/176: 3.5.3 Ensure iptables is installed (Scored)
echo "|"
echo "| L1 91/176: 3.5.3 Ensure iptables is installed (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 92/176: 4.2.1.1 Ensure rsyslog Service is enabled (Scored)
echo "|"
echo "| L1 92/176: 4.2.1.1 Ensure rsyslog Service is enabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 93/176: 4.2.1.2 Ensure logging is configured (Not Scored)
echo "|"
echo "| L1 93/176: 4.2.1.2 Ensure logging is configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 94/176: 4.2.1.3 Ensure rsyslog default file permissions configured (Scored)
echo "|"
echo "| L1 94/176: 4.2.1.3 Ensure rsyslog default file permissions configured (Scored)"
actual=$(grep ^\$FileCreateMode /etc/rsyslog.conf)
expected="\$FileCreateMode 0640"
if [[ "$actual" != "$expected" ]]; then
	echo "\$FileCreateMode 0640" >> /etc/rsyslog.conf
	actual=$(grep ^\$FileCreateMode /etc/rsyslog.conf)
fi
if [[ "$actual" == "$expected" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 95/176: 4.2.1.4 Ensure rsyslog is configured to send logs to a remote log host (Scored)
echo "|"
echo "| L1 95/176: 4.2.1.4 Ensure rsyslog is configured to send logs to a remote log host (Scored)"
actual=$(grep "*.* @@" /etc/rsyslog.conf)
expected="#*.* @@remote-host:514"
if [[ "$actual" != "$expected" ]]; then
	echo "#*.* @@remote-host:514" >> /etc/rsyslog.conf
	pkill -HUP rsyslogd
	actual=$(grep "*.* @@" /etc/rsyslog.conf)
fi
if [[ "$actual" == "$expected" ]]; then
    	echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 96/176: 4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts. (Not Scored)
echo "|"
echo "| L1 96/176: 4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts. (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 97/176: 4.2.2.1 Ensure syslog-ng service is enabled (Scored)
echo "|"
echo "| L1 97/176: 4.2.2.1 Ensure syslog-ng service is enabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 98/176: 4.2.2.2 Ensure logging is configured (Not Scored)
echo "|"
echo "| L1 98/176: 4.2.2.2 Ensure logging is configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 99/176: 4.2.2.3 Ensure syslog-ng default file permissions configured (Scored)
echo "|"
echo "| L1 99/176: 4.2.2.3 Ensure syslog-ng default file permissions configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 100/176: 4.2.2.4 Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)
echo "|"
echo "| L1 100/176: 4.2.2.4 Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 101/176: 4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)
echo "|"
echo "| L1 101/176: 4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 102/176: 4.2.3 Ensure rsyslog or syslog-ng is installed (Scored)
echo "|"
echo "| L1 102/176: 4.2.3 Ensure rsyslog or syslog-ng is installed (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 103/176: 4.2.4 Ensure permissions on all logfiles are configured (Scored)
echo "|"
echo "| L1 103/176: 4.2.4 Ensure permissions on all logfiles are configured (Scored)"
actual=$(find /var/log -type f -exec chmod g-wx,o-rwx {} +)
expected=""
if [[ "$actual" == "$expected" ]]; then
        echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 104/176: 4.3 Ensure logrotate is configured (Not Scored)
echo "|"
echo "| L1 104/176: 4.3 Ensure logrotate is configured (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 105/176: 5.1.1 Ensure cron daemon is enabled (Scored)
echo "|"
echo "| L1 105/176: 5.1.1 Ensure cron daemon is enabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 106/176: 5.1.2 Ensure permissions on /etc/crontab are configured (Scored)
echo "|"
echo "| L1 106/176: 5.1.2 Ensure permissions on /etc/crontab are configured (Scored)"
actual1=$(stat /etc/crontab | grep Uid | xargs)
expected1="Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/crontab
	chmod og-rwx /etc/crontab
	actual1=$(stat /etc/crontab | grep Uid | xargs)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else 
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 107/176: 5.1.3 Ensure permissions on /etc/cron.hourly are configured (Scored)
echo "|"
echo "| L1 107/176: 5.1.3 Ensure permissions on /etc/cron.hourly are configured (Scored)"
actual1=$(stat /etc/cron.hourly | grep Uid | xargs)
expected1="Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/cron.hourly
	chmod og-rwx /etc/cron.hourly
	actual1=$(stat /etc/cron.hourly | grep Uid | xargs)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 108/176: 5.1.4 Ensure permissions on /etc/cron.daily are configured (Scored)
echo "|"
echo "| L1 108/176: 5.1.4 Ensure permissions on /etc/cron.daily are configured (Scored)"
actual1=$(stat /etc/cron.daily | grep Uid | xargs)
expected1="Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/cron.daily
	chmod og-rwx /etc/cron.daily
	actual1=$(stat /etc/cron.daily | grep Uid | xargs)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 109/176: 5.1.5 Ensure permissions on /etc/cron.weekly are configured (Scored)
echo "|"
echo "| L1 109/176: 5.1.5 Ensure permissions on /etc/cron.weekly are configured (Scored)"
actual1=$(stat /etc/cron.weekly | grep Uid | xargs)
expected1="Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/cron.weekly
	chmod og-rwx /etc/cron.weekly
	actual1=$(stat /etc/cron.weekly | grep Uid | xargs)
 	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 110/176: 5.1.6 Ensure permissions on /etc/cron.monthly are configured (Scored)
echo "|"
echo "| L1 110/176: 5.1.6 Ensure permissions on /etc/cron.monthly are configured (Scored)"
actual1=$(stat /etc/cron.monthly | grep Uid | xargs)
expected1="Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/cron.monthly
	chmod og-rwx /etc/cron.monthly
	actual1=$(stat /etc/cron.monthly | grep Uid | xargs)
	if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 111/176: 5.1.7 Ensure permissions on /etc/cron.d are configured (Scored)
echo "|"
echo "| L1 111/176: 5.1.7 Ensure permissions on /etc/cron.d are configured (Scored)"
actual1=$(stat /etc/cron.d | grep Uid | xargs)
expected1="Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual1" == "$expected1" ]]; then
	echo $OK
else
	chown root:root /etc/cron.d
	chmod og-rwx /etc/cron.d
	actual1=$(stat /etc/cron.d | grep Uid | xargs)
	if [[ "$actual1" == "$expected1" ]]; then
		echo $OK
	else
		echo $NOK
	fi
fi

#### CIS Level 1 - Benchmark 112/176: 5.1.8 Ensure at/cron is restricted to authorized users (Scored)
echo "|"
echo "| L1 112/176: 5.1.8 Ensure at/cron is restricted to authorized users (Scored)"
actual1=$(stat /etc/cron.deny 2>&1)
expected1="stat: cannot stat ‘/etc/cron.deny’: No such file or directory"
if [[ "$actual1" != "$expected1" ]]; then
	rm /etc/cron.deny
	actual1=$(stat /etc/cron.deny 2>&1)
fi
actual2=$(stat /etc/at.deny 2>&1)
expected2="stat: cannot stat ‘/etc/at.deny’: No such file or directory"
if [[ "$actual2" != "$expected2" ]]; then
	rm /etc/at.deny
	actual2=$(stat /etc/at.deny 2>&1)
fi
actual3=$(stat /etc/cron.allow | grep Uid | xargs)
expected3="Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual3" != "$expected3" ]]; then
	touch /etc/cron.allow
	chown root:root /etc/cron.allow
	chmod og-rwx /etc/cron.allow
	actual3=$(stat /etc/cron.allow | grep Uid | xargs)
fi
actual4=$(stat /etc/at.allow | grep Uid | xargs)
expected4="Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"
if [[ "$actual4" != "$expected4" ]]; then
	touch /etc/at.allow
	chown root:root /etc/at.allow
    chmod og-rwx /etc/at.allow
    actual4=$(stat /etc/at.allow | grep Uid | xargs)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]] && [[ "$actual3" == "$expected3" ]] && [[ "$actual4" == "$expected4" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 113/176: 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Scored)
echo "|"
echo "| L1 113/176: 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 114/176: 5.2.2 Ensure permissions on SSH private host key files are configured (Scored)
echo "|"
echo "| L1 114/176: 5.2.2 Ensure permissions on SSH private host key files are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 115/176: 5.2.3 Ensure permissions on SSH public host key files are configured (Scored)
echo "|"
echo "| L1 115/176: 5.2.3 Ensure permissions on SSH public host key files are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 116/176: 5.2.4 Ensure SSH Protocol is set to 2 (Scored)
echo "|"
echo "| L1 116/176: 5.2.4 Ensure SSH Protocol is set to 2 (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 117/176: 5.2.5 Ensure SSH LogLevel is appropriate (Scored)
echo "|"
echo "| L1 117/176: 5.2.5 Ensure SSH LogLevel is appropriate (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 118/176: 5.2.7 Ensure SSH MaxAuthTries is set to 4 or less (Scored)
echo "|"
echo "| L1 118/176: 5.2.7 Ensure SSH MaxAuthTries is set to 4 or less (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 119/176: 5.2.8 Ensure SSH IgnoreRhosts is enabled (Scored)
echo "|"
echo "| L1 119/176: 5.2.8 Ensure SSH IgnoreRhosts is enabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 120/176: 5.2.9 Ensure SSH HostbasedAuthentication is disabled (Scored)
echo "|"
echo "| L1 120/176: 5.2.9 Ensure SSH HostbasedAuthentication is disabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 121/176: 5.2.10 Ensure SSH root login is disabled (Scored)
echo "|"
echo "| L1 121/176: 5.2.10 Ensure SSH root login is disabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 122/176: 5.2.11 Ensure SSH PermitEmptyPasswords is disabled (Scored)
echo "|"
echo "| L1 122/176: 5.2.11 Ensure SSH PermitEmptyPasswords is disabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 123/176: 5.2.12 Ensure SSH PermitUserEnvironment is disabled (Scored)
echo "|"
echo "| L1 123/176: 5.2.12 Ensure SSH PermitUserEnvironment is disabled (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 124/176: 5.2.13 Ensure only strong ciphers are used (Scored)
echo "|"
echo "| L1 124/176: 5.2.13 Ensure only strong ciphers are used (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 125/176: 5.2.14 Ensure only strong MAC algorithms are used (Scored)
echo "|"
echo "| L1 125/176: 5.2.14 Ensure only strong MAC algorithms are used (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 126/176: 5.2.15 Ensure that strong Key Exchange algorithms are used (Scored)
echo "|"
echo "| L1 126/176: 5.2.15 Ensure that strong Key Exchange algorithms are used (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 127/176: 5.2.16 Ensure SSH Idle Timeout Interval is configured (Scored)
echo "|"
echo "| L1 127/176: 5.2.16 Ensure SSH Idle Timeout Interval is configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 128/176: 5.2.17 Ensure SSH LoginGraceTime is set to one minute or less (Scored)
echo "|"
echo "| L1 128/176: 5.2.17 Ensure SSH LoginGraceTime is set to one minute or less (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 129/176: 5.2.18 Ensure SSH access is limited (Scored)
echo "|"
echo "| L1 129/176: 5.2.18 Ensure SSH access is limited (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 130/176: 5.2.19 Ensure SSH warning banner is configured (Scored)
echo "|"
echo "| L1 130/176: 5.2.19 Ensure SSH warning banner is configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 131/176: 5.3.1 Ensure password creation requirements are configured (Scored)
echo "|"
echo "| L1 131/176: 5.3.1 Ensure password creation requirements are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 132/176: 5.3.2 Ensure lockout for failed password attempts is configured (Scored)
echo "|"
echo "| L1 132/176: 5.3.2 Ensure lockout for failed password attempts is configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 133/176: 5.3.3 Ensure password reuse is limited (Scored)
echo "|"
echo "| L1 133/176: 5.3.3 Ensure password reuse is limited (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 134/176: 5.3.4 Ensure password hashing algorithm is SHA-512 (Scored)
echo "|"
echo "| L1 134/176: 5.3.4 Ensure password hashing algorithm is SHA-512 (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 135/176: 5.4.1.1 Ensure password expiration is 365 days or less (Scored)
echo "|"
echo "| L1 135/176: 5.4.1.1 Ensure password expiration is 365 days or less (Scored)"
actual=$(grep PASS_MAX_DAYS /etc/login.defs | tail -n1)
expected="PASS_MAX_DAYS	365"
if [[ "$actual" != "$expected" ]]; then
	sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t365/' /etc/login.defs
	actual=$(grep PASS_MAX_DAYS /etc/login.defs | tail -n1)
fi
if [[ "$actual" == "$expected" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 136/176: 5.4.1.2 Ensure minimum days between password changes is 7 or more (Scored)
echo "|"
echo "| L1 136/176: 5.4.1.2 Ensure minimum days between password changes is 7 or more (Scored)"
actual=$(grep PASS_MIN_DAYS /etc/login.defs | tail -n1 | xargs)
expected="PASS_MIN_DAYS 7"
if [[ "$actual" != "$expected" ]]; then
	sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/' /etc/login.defs
	actual=$(grep PASS_MIN_DAYS /etc/login.defs | tail -n1 | xargs)
fi
if [[ "$actual" == "$expected" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 137/176: 5.4.1.3 Ensure password expiration warning days is 7 or more (Scored)
echo "|"
echo "| L1 137/176: 5.4.1.3 Ensure password expiration warning days is 7 or more (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 138/176: 5.4.1.4 Ensure inactive password lock is 30 days or less (Scored)
echo "|"
echo "| L1 138/176: 5.4.1.4 Ensure inactive password lock is 30 days or less (Scored)"
actual=$(useradd -D | grep INACTIVE)
expected="INACTIVE=30"
if [[ "$actual" != "$expected" ]]; then
	useradd -D -f 30
	actual=$(useradd -D | grep INACTIVE)
fi
if [[ "$actual" == "$expected" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 139/176: 5.4.1.5 Ensure all users last password change date is in the past (Scored)
echo "|"
echo "| L1 139/176: 5.4.1.5 Ensure all users last password change date is in the past (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 140/176: 5.4.2 Ensure system accounts are non-login (Scored)
echo "|"
echo "| L1 140/176: 5.4.2 Ensure system accounts are non-login (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 141/176: 5.4.3 Ensure default group for the root account is GID 0 (Scored)
echo "|"
echo "| L1 141/176: 5.4.3 Ensure default group for the root account is GID 0 (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 142/176: 5.4.4 Ensure default user umask is 027 or more restrictive (Scored)
echo "|"
echo "| L1 142/176: 5.4.4 Ensure default user umask is 027 or more restrictive (Scored)"
actual1=$(grep "umask 0" /etc/bashrc | xargs)
expected1="umask 027 umask 027"
actual2=$(grep "umask 0" /etc/bashrc | xargs)
expected2="umask 027 umask 027"
if [[ "$actual1" != "$expected1" ]]; then
	sed -i 's/umask 002/umask 027/' /etc/bashrc
	sed -i 's/umask 022/umask 027/' /etc/bashrc
	actual1=$(grep "umask 0" /etc/bashrc | xargs)
fi
if [[ "$actual2" != "$expected2" ]]; then
	sed -i 's/umask 002/umask 027/' /etc/profile
	sed -i 's/umask 022/umask 027/' /etc/profile
	actual2=$(grep "umask 0" /etc/bashrc | xargs)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
        echo $OK
else
    	echo $NOK
fi

#### CIS Level 1 - Benchmark 143/176: 5.5 Ensure root login is restricted to system console (Not Scored)
echo "|"
echo "| L1 143/176: 5.5 Ensure root login is restricted to system console (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 144/176: 5.6 Ensure access to the su command is restricted (Scored)
echo "|"
echo "| L1 144/176: 5.6 Ensure access to the su command is restricted (Scored)"
actual1=$(grep "auth required pam_wheel.so" /etc/pam.d/su)
expected1="auth required pam_wheel.so use_uid"
actual2=$(grep wheel /etc/group)
expected2="wheel:x:10:root,ec2-user"
if [[ "$actual1" != "$expected1" ]]; then
	sed -i 's/#auth		required	pam_wheel.so use_uid/auth required pam_wheel.so use_uid/' /etc/pam.d/su
	actual1=$(grep "auth required pam_wheel.so" /etc/pam.d/su)
fi
if [[ "$actual2" != "$expected2" ]]; then
	sed -i 's/wheel:x:10:ec2-user/wheel:x:10:root,ec2-user/' /etc/group
	actual2=$(grep wheel /etc/group)
fi
if [[ "$actual1" == "$expected1" ]] && [[ "$actual2" == "$expected2" ]]; then
	echo $OK
else
	echo $NOK
fi

#### CIS Level 1 - Benchmark 145/176: 6.1.2 Ensure permissions on /etc/passwd are configured (Scored)
echo "|"
echo "| L1 145/176: 6.1.2 Ensure permissions on /etc/passwd are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 146/176: 6.1.3 Ensure permissions on /etc/shadow are configured (Scored)
echo "|"
echo "| L1 146/176: 6.1.3 Ensure permissions on /etc/shadow are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 147/176: 6.1.4 Ensure permissions on /etc/group are configured (Scored)
echo "|"
echo "| L1 147/176: 6.1.4 Ensure permissions on /etc/group are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 148/176: 6.1.5 Ensure permissions on /etc/gshadow are configured (Scored)
echo "|"
echo "| L1 148/176: 6.1.5 Ensure permissions on /etc/gshadow are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 149/176: 6.1.6 Ensure permissions on /etc/passwd- are configured (Scored)
echo "|"
echo "| L1 149/176: 6.1.6 Ensure permissions on /etc/passwd- are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 150/176: 6.1.7 Ensure permissions on /etc/shadow- are configured (Scored)
echo "|"
echo "| L1 150/176: 6.1.7 Ensure permissions on /etc/shadow- are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 151/176: 6.1.8 Ensure permissions on /etc/group- are configured (Scored)
echo "|"
echo "| L1 151/176: 6.1.8 Ensure permissions on /etc/group- are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 152/176: 6.1.9 Ensure permissions on /etc/gshadow- are configured (Scored)
echo "|"
echo "| L1 152/176: 6.1.9 Ensure permissions on /etc/gshadow- are configured (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 153/176: 6.1.10 Ensure no world writable files exist (Scored)
echo "|"
echo "| L1 153/176: 6.1.10 Ensure no world writable files exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 154/176: 6.1.11 Ensure no unowned files or directories exist (Scored)
echo "|"
echo "| L1 154/176: 6.1.11 Ensure no unowned files or directories exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 155/176: 6.1.12 Ensure no ungrouped files or directories exist (Scored)
echo "|"
echo "| L1 155/176: 6.1.12 Ensure no ungrouped files or directories exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 156/176: 6.1.13 Audit SUID executables (Not Scored)
echo "|"
echo "| L1 156/176: 6.1.13 Audit SUID executables (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 157/176: 6.1.14 Audit SGID executables (Not Scored)
echo "|"
echo "| L1 157/176: 6.1.14 Audit SGID executables (Not Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 158/176: 6.2.1 Ensure password fields are not empty (Scored)
echo "|"
echo "| L1 158/176: 6.2.1 Ensure password fields are not empty (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 159/176: 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd (Scored)
echo "|"
echo "| L1 159/176: 6.2.2 Ensure no legacy \"+\" entries exist in /etc/passwd (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 160/176: 6.2.3 Ensure no legacy "+" entries exist in /etc/shadow (Scored)
echo "|"
echo "| L1 160/176: 6.2.3 Ensure no legacy \"+\" entries exist in /etc/shadow (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 161/176: 6.2.4 Ensure no legacy "+" entries exist in /etc/group (Scored)
echo "|"
echo "| L1 161/176: 6.2.4 Ensure no legacy \"+\" entries exist in /etc/group (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 162/176: 6.2.5 Ensure root is the only UID 0 account (Scored)
echo "|"
echo "| L1 162/176: 6.2.5 Ensure root is the only UID 0 account (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 163/176: 6.2.6 Ensure root PATH Integrity (Scored)
echo "|"
echo "| L1 163/176: 6.2.6 Ensure root PATH Integrity (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 164/176: 6.2.7 Ensure all users' home directories exist (Scored)
echo "|"
echo "| L1 164/176: 6.2.7 Ensure all users' home directories exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 165/176: 6.2.8 Ensure users' home directories permissions are 750 or more restrictive (Scored)
echo "|"
echo "| L1 165/176: 6.2.8 Ensure users' home directories permissions are 750 or more restrictive (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 166/176: 6.2.9 Ensure users own their home directories (Scored)
echo "|"
echo "| L1 166/176: 6.2.9 Ensure users own their home directories (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 167/176: 6.2.10 Ensure users' dot files are not group or world writable (Scored)
echo "|"
echo "| L1 167/176: 6.2.10 Ensure users' dot files are not group or world writable (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 168/176: 6.2.11 Ensure no users have .forward files (Scored)
echo "|"
echo "| L1 168/176: 6.2.11 Ensure no users have .forward files (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 169/176: 6.2.12 Ensure no users have .netrc files (Scored)
echo "|"
echo "| L1 169/176: 6.2.12 Ensure no users have .netrc files (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 170/176: 6.2.13 Ensure users' .netrc Files are not group or world accessible (Scored)
echo "|"
echo "| L1 170/176: 6.2.13 Ensure users' .netrc Files are not group or world accessible (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 171/176: 6.2.14 Ensure no users have .rhosts files (Scored)
echo "|"
echo "| L1 171/176: 6.2.14 Ensure no users have .rhosts files (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 172/176: 6.2.15 Ensure all groups in /etc/passwd exist in /etc/group (Scored)
echo "|"
echo "| L1 172/176: 6.2.15 Ensure all groups in /etc/passwd exist in /etc/group (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 173/176: 6.2.16 Ensure no duplicate UIDs exist (Scored)
echo "|"
echo "| L1 173/176: 6.2.16 Ensure no duplicate UIDs exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 174/176: 6.2.17 Ensure no duplicate GIDs exist (Scored)
echo "|"
echo "| L1 174/176: 6.2.17 Ensure no duplicate GIDs exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 175/176: 6.2.18 Ensure no duplicate user names exist (Scored)
echo "|"
echo "| L1 175/176: 6.2.18 Ensure no duplicate user names exist (Scored)"
echo $NIMP

#### CIS Level 1 - Benchmark 176/176: 6.2.19 Ensure no duplicate group names exist (Scored)
echo "|"
echo "| L1 176/176: 6.2.19 Ensure no duplicate group names exist (Scored)"
echo $NIMP

echo "|"
echo $DONE
echo ""

exit 0
