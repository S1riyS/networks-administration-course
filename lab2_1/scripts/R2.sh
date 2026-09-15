# Команды Huawei VRP для маршрутизатора R2 (ЛР 2.1).
# Строки с # — комментарии к пунктам отчёта, в CLI их вставлять не нужно.

system-view

# 2.1 Задание имен устройствам
sysname R2

# 2.2 Настройка адресов для физических интерфейсов
interface GigabitEthernet0/0/0
ip address 10.0.12.2 24
quit
interface GigabitEthernet0/0/1
ip address 10.0.23.2 24
quit

# 2.3 Создание loopback-интерфейсов
interface LoopBack0
ip address 10.0.1.2 32
quit

# 2.4 Настройка статических маршрутов
ip route-static 10.0.1.1 32 10.0.12.1
ip route-static 10.0.1.3 32 10.0.23.3

# 2.5.1 Настройка статических маршрутов R1, R2
# (резервный маршрут от R2 к R1 через R3)
ip route-static 10.0.1.1 32 10.0.23.3 preference 100

# 2.5.3 Отключение GigabitEthernet0/0/0 на маршрутизаторах R1 и R2
interface GigabitEthernet 0/0/0
shutdown
quit

# 2.6.1 Включение интерфейсов и удаление настроенных маршрутов
interface GigabitEthernet 0/0/0
undo shutdown
quit
