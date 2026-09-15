# Команды Huawei VRP для маршрутизатора R3 (ЛР 2.1).
# Строки с # — комментарии к пунктам отчёта, в CLI их вставлять не нужно.

system-view

# 2.1 Задание имен устройствам
sysname R3

# 2.2 Настройка адресов для физических интерфейсов
interface GigabitEthernet0/0/1
ip address 10.0.23.3 24
quit
interface GigabitEthernet0/0/2
ip address 10.0.13.3 24
quit

# 2.3 Создание loopback-интерфейсов
interface LoopBack0
ip address 10.0.1.3 32
quit

# 2.4 Настройка статических маршрутов
ip route-static 10.0.1.1 32 10.0.13.1
ip route-static 10.0.1.2 32 10.0.23.2
