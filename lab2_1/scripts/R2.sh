system-view
sysname R2

interface GigabitEthernet0/0/0
ip address 10.0.12.2 24
quit
interface GigabitEthernet0/0/1
ip address 10.0.23.2 24
quit

interface LoopBack0
ip address 10.0.1.2 32
quit

ip route-static 10.0.1.1 32 10.0.12.1
ip route-static 10.0.1.3 32 10.0.23.3

ip route-static 10.0.1.1 32 10.0.23.3 preference 100

interface GigabitEthernet 0/0/0
shutdown
quit

interface GigabitEthernet 0/0/0
undo shutdown
quit
