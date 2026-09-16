system-view

sysname R3

interface GigabitEthernet0/0/1
ip address 10.0.23.3 24
quit
interface GigabitEthernet0/0/2
ip address 10.0.13.3 24
quit

interface LoopBack0
ip address 10.0.1.3 32
quit

ip route-static 10.0.1.1 32 10.0.13.1
ip route-static 10.0.1.2 32 10.0.23.2
