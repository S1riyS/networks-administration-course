#set document(title: "ЛР2.1 Адресация и маршрутизация IPv4")
#set page(paper: "a4", margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm))

#set text(lang: "ru", font: "Liberation Serif", size: 14pt)
#set par(justify: true, leading: 0.8em, first-line-indent: 1.25cm)
#set heading(numbering: "1.")
#show heading: set par(first-line-indent: 0pt)

#show raw: set text(font: "Liberation Mono", size: 11pt)

// Рамка и фон для блочного кода
#show raw.where(block: true): set block(
  fill: luma(240),
  stroke: 0.5pt + luma(180),
  inset: 10pt,
  radius: 4pt,
)

#let source(path, lang) = block(
  fill: luma(240),
  stroke: 0.5pt + luma(180),
  inset: 10pt,
  radius: 4pt,
  below: 1.5em,
  raw(read(path), lang: lang, block: true),
)

// ─────────────────────────── Титульный лист ───────────────────────────

#align(center)[
  #set par(first-line-indent: 0pt)
  #text(size: 12pt)[
    Федеральное государственное автономное образовательное учреждение\
    высшего образования\
    *«Национальный исследовательский университет ИТМО»*
  ]

  #v(0.4cm)
  #text(size: 12pt)[Факультет программной инженерии и компьютерной техники]

  #v(3.5cm)

  #text(size: 16pt, weight: "bold")[
    Лабораторная работа №2.1\
    «Адресация и маршрутизация IPv4»
  ]

  #v(0.6cm)
  #text(size: 13pt)[по дисциплине «Администрирование систем и сетей»]

  #v(5cm)

  #align(right)[
    #set par(first-line-indent: 0pt)
    #grid(
      columns: 10cm,
      row-gutter: 0.5em,
      align: (right, left),
      [*Работу выполнили студенты:*],
      [Анкудинов Кирилл Константинович, P3418],
      [Есев Ярослав Леонидович, P3415],
      [],
      [*Желаемая оценка*: 3],
      [],
      [*Преподаватель:*],
      [Афанасьев Дмитрий Борисович],
    )
  ]

  #v(1fr)
  #text(size: 12pt)[Санкт-Петербург, 2026]
]

#pagebreak()

#set page(numbering: "1")
#counter(page).update(1)

// ─────────────────────────── Методика тестирования ───────────────────────────

#outline(
  title: [*Оглавление*],
  depth: 3,
)

#pagebreak()

= Топология
#image("topology.png")

= Конфигурация

== Задание имен устройствам

```
[R1] sysname R1
[R2] sysname R2
[R3] sysname R3
```

== Настройка адресов для физических интерфейсов
#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt,
  align: (left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  [*Маршрутизатор*], [*Интерфейс*], [*IP-адрес / маска*],
  table.cell(rowspan: 2)[R1], [GigabitEthernet0/0/0], [10.0.12.1/24],
                               [GigabitEthernet0/0/2], [10.0.13.1/24],
  table.cell(rowspan: 2)[R2], [GigabitEthernet0/0/0], [10.0.12.2/24],
                               [GigabitEthernet0/0/1], [10.0.23.2/24],
  table.cell(rowspan: 2)[R3], [GigabitEthernet0/0/1], [10.0.23.3/24],
                               [GigabitEthernet0/0/2], [10.0.13.3/24],
)

#pagebreak()

=== Проверка связи с помощью `ping`

```
<R1>ping -c 5 10.0.12.2
  PING 10.0.12.2: 56  data bytes, press CTRL_C to break
    Reply from 10.0.12.2: bytes=56 Sequence=1 ttl=255 time=30 ms
    Reply from 10.0.12.2: bytes=56 Sequence=2 ttl=255 time=20 ms
    Reply from 10.0.12.2: bytes=56 Sequence=3 ttl=255 time=20 ms
    Reply from 10.0.12.2: bytes=56 Sequence=4 ttl=255 time=20 ms
    Reply from 10.0.12.2: bytes=56 Sequence=5 ttl=255 time=40 ms

  --- 10.0.12.2 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 20/26/40 ms

<R1>ping -c 5 10.0.13.3
  PING 10.0.13.3: 56  data bytes, press CTRL_C to break
    Reply from 10.0.13.3: bytes=56 Sequence=1 ttl=255 time=50 ms
    Reply from 10.0.13.3: bytes=56 Sequence=2 ttl=255 time=20 ms
    Reply from 10.0.13.3: bytes=56 Sequence=3 ttl=255 time=30 ms
    Reply from 10.0.13.3: bytes=56 Sequence=4 ttl=255 time=10 ms
    Reply from 10.0.13.3: bytes=56 Sequence=5 ttl=255 time=20 ms

  --- 10.0.13.3 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 10/26/50 ms
```

=== Таблица маршрутизации R1

#block[
  #show raw: set text(size: 9pt)
  ```
  <R1>display ip routing-table
  Route Flags: R - relay, D - download to fib
  ------------------------------------------------------------------------------
  Routing Tables: Public
           Destinations : 10       Routes : 10       
  
  Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface
  
        10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
        10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
        10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
        10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
        127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
        127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  ```
]

== Создание loopback-интерфейсов

// TODO: FIX
#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt,
  align: (left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  // Заголовок
  [*Маршрутизатор*], [*Интерфейс*], [*IP-адрес / маска*],
  // 1-я пара строк (R1)
  [R1], [LoopBack0], [10.0.1.1/32],
  [R2], [LoopBack0], [10.0.1.2/32],
  [R3], [LoopBack0], [10.0.1.3/32],
)

=== Таблица маршрутизации R1
#block[
  #show raw: set text(size: 9pt)
```
[R1]display ip routing-table
Route Flags: R - relay, D - download to fib
------------------------------------------------------------------------------
Routing Tables: Public
         Destinations : 11       Routes : 11       

Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface

       10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
      10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
      10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
    10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
      10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
    10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
      127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
```
]

=== Проверка связи между loopback-интерфейсами

```
[R1]ping 10.0.1.2
  PING 10.0.1.2: 56  data bytes, press CTRL_C to break
    Request time out
    Request time out
    Request time out
    Request time out
    Request time out

  --- 10.0.1.2 ping statistics ---
    5 packet(s) transmitted
    0 packet(s) received
    100.00% packet loss
```

== Настройка статических маршрутов
```
[R1]ip route-static 10.0.1.2 32 10.0.12.2
[R1]ip route-static 10.0.1.3 32 10.0.13.3
```
```
[R2]ip route-static 10.0.1.1 32 10.0.12.1
[R2]ip route-static 10.0.1.3 32 10.0.23.3
```
```
[R3]ip route-static 10.0.1.1 32 10.0.13.1
[R3]ip route-static 10.0.1.2 32 10.0.23.2
```

=== Таблица маршрутизации R1

#block[
  #show raw: set text(size: 9pt)
  ```
[R1]display ip routing-table
Route Flags: R - relay, D - download to fib
------------------------------------------------------------------------------
Routing Tables: Public
         Destinations : 13       Routes : 13       

Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface

       10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
       10.0.1.2/32  Static  60   0          RD   10.0.12.2       GigabitEthernet0/0/0
       10.0.1.3/32  Static  60   0          RD   10.0.13.3       GigabitEthernet0/0/2
      10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
      10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
    10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
      10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
    10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
      127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
```
]

=== Проверка связи между loopback-интерфейсами
```
[R1]ping -a 10.0.1.1 10.0.1.2
  PING 10.0.1.2: 56  data bytes, press CTRL_C to break
    Reply from 10.0.1.2: bytes=56 Sequence=1 ttl=255 time=40 ms
    Reply from 10.0.1.2: bytes=56 Sequence=2 ttl=255 time=30 ms
    Reply from 10.0.1.2: bytes=56 Sequence=3 ttl=255 time=20 ms
    Reply from 10.0.1.2: bytes=56 Sequence=4 ttl=255 time=20 ms
    Reply from 10.0.1.2: bytes=56 Sequence=5 ttl=255 time=20 ms

  --- 10.0.1.2 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 20/26/40 ms

[R1]ping -a 10.0.1.1 10.0.1.3
  PING 10.0.1.3: 56  data bytes, press CTRL_C to break
    Reply from 10.0.1.3: bytes=56 Sequence=1 ttl=255 time=40 ms
    Reply from 10.0.1.3: bytes=56 Sequence=2 ttl=255 time=30 ms
    Reply from 10.0.1.3: bytes=56 Sequence=3 ttl=255 time=20 ms
    Reply from 10.0.1.3: bytes=56 Sequence=4 ttl=255 time=30 ms
    Reply from 10.0.1.3: bytes=56 Sequence=5 ttl=255 time=30 ms

  --- 10.0.1.3 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 20/30/40 ms
```

== Маршрут от R1 к R2 через R3 в качестве резервного

=== Настройка статических маршрутов R1, R2
```
[R1]ip route-static 10.0.1.2 32 10.0.13.3 preference 100
[R2]ip route-static 10.0.1.1 32 10.0.23.3 preference 100
```

=== Таблица маршрутизации R1 (до выключения g0/0/0)

#block[
  #show raw: set text(size: 9pt)
  ```
  [R1]display ip routing-table
  Route Flags: R - relay, D - download to fib
  ------------------------------------------------------------------------------
  Routing Tables: Public
           Destinations : 13       Routes : 13       
  
  Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface
  
         10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
         10.0.1.2/32  Static  60   0          RD   10.0.12.2       GigabitEthernet0/0/0
         10.0.1.3/32  Static  60   0          RD   10.0.13.3       GigabitEthernet0/0/2
        10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
        10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
        10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
        10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
        127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
        127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  ```
]

=== Отключение GigabitEthernet0/0/0 на маршрутизаторе R1

```
[R1]interface GigabitEthernet 0/0/0
[R1-GigabitEthernet0/0/0]shutdown
```

=== Таблица маршрутизации R1 (после выключения g0/0/0)

#block[
  #show raw: set text(size: 9pt)
  ```
  [R1]display ip routing-table
  Route Flags: R - relay, D - download to fib
  ------------------------------------------------------------------------------
  Routing Tables: Public
           Destinations : 10       Routes : 10       
  
  Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface
  
         10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
         10.0.1.2/32  Static  100  0          RD   10.0.13.3       GigabitEthernet0/0/2
         10.0.1.3/32  Static  60   0          RD   10.0.13.3       GigabitEthernet0/0/2
        10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
        10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
        127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
        127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  ```
]

=== Трассировка маршрута, по которому передаются пакеты с данными

```
[R1]tracert -a 10.0.1.1 10.0.1.2

 traceroute to  10.0.1.2(10.0.1.2), max hops: 30 ,packet length: 40,press CTRL_C
 to break 

 1 10.0.13.3 30 ms  30 ms  10 ms 
 2 10.0.23.2 40 ms  20 ms  20 ms 
```

== Настройка маршрутов по умолчанию для установления связи между интерфейсом LoopBack0 маршрутизатора R1 и LoopBack0 R2
=== Включение интерфейсов и удаление настроенных маршрутов
```
[R1]interface GigabitEthernet 0/0/0
[R1-GigabitEthernet0/0/0]undo shutdown
[R1-GigabitEthernet0/0/0]quit
[R1]undo ip route-static 10.0.1.2 32 10.0.12.2
[R1]undo ip route-static 10.0.1.2 32 10.0.13.3 preference 100
```

=== Таблица маршрутизации R1

#block[
  #show raw: set text(size: 9pt)
  ```
  [R1]display ip routing-table
  Route Flags: R - relay, D - download to fib
  ------------------------------------------------------------------------------
  Routing Tables: Public
           Destinations : 12       Routes : 12       
  
  Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface
  
         10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
         10.0.1.3/32  Static  60   0          RD   10.0.13.3       GigabitEthernet0/0/2
        10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
        10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
        10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
        10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
        127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
        127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  ```
]

=== Настройка маршрута по умолчанию на R1

```
[R1]ip route-static 0.0.0.0 0 10.0.12.2
```

=== Таблица маршрутизации R1

#block[
  #show raw: set text(size: 9pt)
  ```
  [R1]display ip routing-table
  Route Flags: R - relay, D - download to fib
  ------------------------------------------------------------------------------
  Routing Tables: Public
           Destinations : 13       Routes : 13       
  
  Destination/Mask    Proto   Pre  Cost      Flags NextHop         Interface
  
          0.0.0.0/0   Static  60   0          RD   10.0.12.2       GigabitEthernet0/0/0
         10.0.1.1/32  Direct  0    0           D   127.0.0.1       LoopBack0
         10.0.1.3/32  Static  60   0          RD   10.0.13.3       GigabitEthernet0/0/2
        10.0.12.0/24  Direct  0    0           D   10.0.12.1       GigabitEthernet0/0/0
        10.0.12.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
      10.0.12.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/0
        10.0.13.0/24  Direct  0    0           D   10.0.13.1       GigabitEthernet0/0/2
        10.0.13.1/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
      10.0.13.255/32  Direct  0    0           D   127.0.0.1       GigabitEthernet0/0/2
        127.0.0.0/8   Direct  0    0           D   127.0.0.1       InLoopBack0
        127.0.0.1/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  127.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  255.255.255.255/32  Direct  0    0           D   127.0.0.1       InLoopBack0
  ```
]

=== Наличия связи между LoopBack0 R1 и LoopBack0 R2
```
[R1]ping -a 10.0.1.1 10.0.1.2
  PING 10.0.1.2: 56  data bytes, press CTRL_C to break
    Reply from 10.0.1.2: bytes=56 Sequence=1 ttl=255 time=50 ms
    Reply from 10.0.1.2: bytes=56 Sequence=2 ttl=255 time=20 ms
    Reply from 10.0.1.2: bytes=56 Sequence=3 ttl=255 time=10 ms
    Reply from 10.0.1.2: bytes=56 Sequence=4 ttl=255 time=20 ms
    Reply from 10.0.1.2: bytes=56 Sequence=5 ttl=255 time=20 ms

  --- 10.0.1.2 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 10/24/50 ms
```