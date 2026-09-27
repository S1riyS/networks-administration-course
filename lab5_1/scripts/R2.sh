system-view
sysname R2
interface GigabitEthernet0/0/2
ip address 10.0.12.2 255.255.255.0
undo shutdown
quit
ftp server enable
aaa
local-user ftp-client password irreversible-cipher Huawei@123
local-user ftp-client service-type ftp
local-user ftp-client privilege level 15
local-user ftp-client ftp-directory flash:/
quit
return
