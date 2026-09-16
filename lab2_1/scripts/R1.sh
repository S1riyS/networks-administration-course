system-view

sysname R1

interface GigabitEthernet0/0/0
ip address 10.0.12.1 24
quit
interface GigabitEthernet0/0/2
ip address 10.0.13.1 24
quit

ping -c 5 10.0.12.2
ping -c 5 10.0.13.3

display ip routing-table

interface LoopBack0
ip address 10.0.1.1 32
quit

display ip routing-table

ping -a 10.0.1.1 10.0.1.2

ip route-static 10.0.1.2 32 10.0.12.2
ip route-static 10.0.1.3 32 10.0.13.3

display ip routing-table

ping -a 10.0.1.1 10.0.1.2
ping -a 10.0.1.1 10.0.1.3

ip route-static 10.0.1.2 32 10.0.13.3 preference 100

display ip routing-table

interface GigabitEthernet 0/0/0
shutdown
quit

display ip routing-table

tracert -a 10.0.1.1 10.0.1.2

interface GigabitEthernet 0/0/0
undo shutdown
quit
undo ip route-static 10.0.1.2 32 10.0.12.2
undo ip route-static 10.0.1.2 32 10.0.13.3 preference 100

# 2.6.2 Таблица маршрутизации R1
display ip routing-table

ip route-static 0.0.0.0 0 10.0.12.2

display ip routing-table

ping -a 10.0.1.1 10.0.1.2
