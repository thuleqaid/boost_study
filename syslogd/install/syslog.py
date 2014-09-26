#!/usr/local/bin/python
import os

def modifySamba():
	with open('/etc/samba/smb.conf','r') as fh:
		lines=fh.readlines()
	if not lines[-1].startswith('full_audit:'):
		lines.append('\tvfs objects = full_audit\n')
		lines.append('\tfull_audit:prefix = SMBLOG\n')
		lines.append('\tfull_audit:success = mkdir rename pwrite write\n')
		lines.append('\tfull_audit:failure = none\n')
		lines.append('\tfull_audit:facility = LOCAL5\n')
		lines.append('\tfull_audit:priority = NOTICE\n')
		os.rename('/etc/samba/smb.conf','/etc/samba/vmlog_smb.conf')
		with open('/etc/samba/smb.conf','w') as fh:
			fh.writelines(lines)
		print("Samba Setting Fixed")
		print("Run 'service smb restart' Please")
	else:
		print("Samba Setting Has Already Been Fixed")

def modifySyslog():
	with open('/etc/syslog.conf','r') as fh:
		lines=fh.readlines()
	if not lines[-1].startswith('local5.'):
		lines.append('local5.*    @192.168.0.1\n')
		lines.append('local5.*    /var/log/smb.log\n')
		os.rename('/etc/syslog.conf','/etc/vmlog_syslog.conf')
		with open('/etc/syslog.conf','w') as fh:
			fh.writelines(lines)
		print("Syslog Setting Fixed")
		print("Run 'service sysklogd restart' Please")
	else:
		print("Syslog Setting Has Already Been Fixed")

if __name__=='__main__':
	modifySamba()
	modifySyslog()
