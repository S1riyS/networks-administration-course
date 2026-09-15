# Команды Huawei VRP для маршрутизатора R1 (ЛР 2.1).
# Строки с # — комментарии к пунктам отчёта, в CLI их вставлять не нужно.

system-view

# 2.1 Задание имен устройствам
sysname R1

# 2.2 Настройка адресов для физических интерфейсов
interface GigabitEthernet0/0/0
ip address 10.0.12.1 24
quit
interface GigabitEthernet0/0/2
ip address 10.0.13.1 24
quit

# 2.2.1 Проверка связи с помощью ping
ping -c 5 10.0.12.2
ping -c 5 10.0.13.3

# 2.2.2 Таблица маршрутизации R1
display ip routing-table

# 2.3 Создание loopback-интерфейсов
interface LoopBack0
ip address 10.0.1.1 32
quit

# 2.3.1 Таблица маршрутизации R1
display ip routing-table

# 2.3.2 Проверка связи между loopback-интерфейсами
ping -a 10.0.1.1 10.0.1.2

# 2.4 Настройка статических маршрутов
ip route-static 10.0.1.2 32 10.0.12.2
ip route-static 10.0.1.3 32 10.0.13.3

# 2.4.1 Таблица маршрутизации R1
display ip routing-table

# 2.4.2 Проверка связи между loopback-интерфейсами
ping -a 10.0.1.1 10.0.1.2
ping -a 10.0.1.1 10.0.1.3

# 2.5.1 Настройка статических маршрутов R1, R2
# (резервный маршрут от R1 к R2 через R3)
ip route-static 10.0.1.2 32 10.0.13.3 preference 100

# 2.5.2 Таблица маршрутизации R1 (до выключения g0/0/0)
display ip routing-table

# 2.5.3 Отключение GigabitEthernet0/0/0 на маршрутизаторах R1 и R2
interface GigabitEthernet 0/0/0
shutdown
quit

# 2.5.4 Таблица маршрутизации R1 (после выключения g0/0/0)
display ip routing-table

# 2.5.5 Трассировка маршрута, по которому передаются пакеты с данными
tracert -a 10.0.1.1 10.0.1.2

# 2.6.1 Включение интерфейсов и удаление настроенных маршрутов
interface GigabitEthernet 0/0/0
undo shutdown
quit
undo ip route-static 10.0.1.2 32 10.0.12.2
undo ip route-static 10.0.1.2 32 10.0.13.3 preference 100

# 2.6.2 Таблица маршрутизации R1
display ip routing-table

# 2.6.3 Настройка маршрута по умолчанию на R1
ip route-static 0.0.0.0 0 10.0.12.2

# 2.6.4 Таблица маршрутизации R1
display ip routing-table

# 2.6.5 Наличие связи между LoopBack0 R1 и LoopBack0 R2
ping -a 10.0.1.1 10.0.1.2
