#set document(title: "ЛР3.1 Основы Ethernet и конфигурирование VLAN")
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
    Лабораторная работа №3.1\
    «Основы Ethernet и конфигурирование VLAN»
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

#outline(
  title: [*Оглавление*],
  depth: 3,
)

#pagebreak()

= Топология

// Сохранить скриншот eNSP рядом с этим файлом под именем «топология3_1.png».
#image("топология3_1.png", width: 100%)

В работе используются четыре коммутатора Huawei S5700 и два маршрутизатора
Huawei AR2220. Коммутаторы S1 и S2 соединены trunk-каналом, который переносит
трафик VLAN 2, VLAN 3 и VLAN 10.

#table(
  columns: (1fr, 1fr, 1.4fr),
  stroke: 0.5pt,
  align: (left, left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  [*Первый конец*], [*Второй конец*], [*Назначение*],
  [R1 GE0/0/1], [S1 GE0/0/1], [Access, VLAN 2],
  [S3 GE0/0/1], [S1 GE0/0/13], [Access, VLAN 3],
  [S1 GE0/0/10], [S2 GE0/0/10], [Trunk, VLAN 2, 3 и 10],
  [S4 GE0/0/2], [S2 GE0/0/14], [Access, VLAN 3],
  [R3 GE0/0/2], [S2 GE0/0/1], [Hybrid, MAC-VLAN 10],
)

== Адресация устройств

#table(
  columns: (auto, 1.5fr, 1.2fr, auto),
  stroke: 0.5pt,
  align: (left, left, left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  [*Устройство*], [*Интерфейс*], [*IP-адрес / маска*], [*VLAN*],
  [R1], [GigabitEthernet0/0/1], [10.1.2.1/24], [2],
  [S3], [Vlanif3], [10.1.3.1/24], [3],
  [S4], [Vlanif3], [10.1.3.2/24], [3],
  [R3], [GigabitEthernet0/0/2], [10.1.10.1/24], [10],
)

= Конфигурация

== Настройка маршрутизатора R1

```
<Huawei>system-view
[Huawei]sysname R1
[R1]interface GigabitEthernet 0/0/1
[R1-GigabitEthernet0/0/1]ip address 10.1.2.1 255.255.255.0
[R1-GigabitEthernet0/0/1]undo shutdown
[R1-GigabitEthernet0/0/1]quit
[R1]return
<R1>save
```

== Настройка маршрутизатора R3

```
<Huawei>system-view
[Huawei]sysname R3
[R3]interface GigabitEthernet 0/0/2
[R3-GigabitEthernet0/0/2]ip address 10.1.10.1 255.255.255.0
[R3-GigabitEthernet0/0/2]undo shutdown
[R3-GigabitEthernet0/0/2]quit
[R3]return
<R3>save
```

Фактический MAC-адрес интерфейса GigabitEthernet0/0/2 маршрутизатора R3:

```
<R3>display interface GigabitEthernet 0/0/2 | include Hardware address
IP Sending Frames' Format is PKTFMT_ETHNT_2,
Hardware address is 00e0-fc68-201c
```

== Настройка коммутатора S3

```
<Huawei>system-view
[Huawei]sysname S3
[S3]vlan 3
[S3-vlan3]quit
[S3]interface GigabitEthernet 0/0/1
[S3-GigabitEthernet0/0/1]port link-type access
[S3-GigabitEthernet0/0/1]port default vlan 3
[S3-GigabitEthernet0/0/1]quit
[S3]interface Vlanif 3
[S3-Vlanif3]ip address 10.1.3.1 255.255.255.0
[S3-Vlanif3]quit
[S3]return
<S3>save
```

== Настройка коммутатора S4

```
<Huawei>system-view
[Huawei]sysname S4
[S4]vlan 3
[S4-vlan3]quit
[S4]interface GigabitEthernet 0/0/2
[S4-GigabitEthernet0/0/2]port link-type access
[S4-GigabitEthernet0/0/2]port default vlan 3
[S4-GigabitEthernet0/0/2]quit
[S4]interface Vlanif 3
[S4-Vlanif3]ip address 10.1.3.2 255.255.255.0
[S4-Vlanif3]quit
[S4]return
<S4>save
```

== Настройка коммутатора S1

На S1 создаются VLAN 2, VLAN 3 и VLAN 10. Порты GE0/0/1 и GE0/0/13
работают как access-порты, а GE0/0/10 — как trunk-порт между S1 и S2.

```
<Huawei>system-view
[Huawei]sysname S1
[S1]vlan batch 2 3 10

[S1]interface GigabitEthernet 0/0/1
[S1-GigabitEthernet0/0/1]port link-type access
[S1-GigabitEthernet0/0/1]port default vlan 2
[S1-GigabitEthernet0/0/1]quit

[S1]interface GigabitEthernet 0/0/13
[S1-GigabitEthernet0/0/13]port link-type access
[S1-GigabitEthernet0/0/13]port default vlan 3
[S1-GigabitEthernet0/0/13]quit

[S1]interface GigabitEthernet 0/0/10
[S1-GigabitEthernet0/0/10]port link-type trunk
[S1-GigabitEthernet0/0/10]port trunk allow-pass vlan 2 3 10
[S1-GigabitEthernet0/0/10]undo port trunk allow-pass vlan 1
[S1-GigabitEthernet0/0/10]quit

[S1]interface GigabitEthernet 0/0/11
[S1-GigabitEthernet0/0/11]shutdown
[S1-GigabitEthernet0/0/11]quit
[S1]interface GigabitEthernet 0/0/12
[S1-GigabitEthernet0/0/12]shutdown
[S1-GigabitEthernet0/0/12]quit
[S1]return
<S1>save
```

== Настройка коммутатора S2

Порт GE0/0/14 назначается VLAN 3. Порт GE0/0/10 настраивается как trunk.
На портах GE0/0/1–3 включается классификация MAC-VLAN. MAC-адрес R3
`00e0-fc68-201c` связывается с VLAN 10.

```
<Huawei>system-view
[Huawei]sysname S2
[S2]vlan batch 2 3 10

[S2]interface GigabitEthernet 0/0/14
[S2-GigabitEthernet0/0/14]port link-type access
[S2-GigabitEthernet0/0/14]port default vlan 3
[S2-GigabitEthernet0/0/14]quit

[S2]interface GigabitEthernet 0/0/10
[S2-GigabitEthernet0/0/10]port link-type trunk
[S2-GigabitEthernet0/0/10]port trunk allow-pass vlan 2 3 10
[S2-GigabitEthernet0/0/10]undo port trunk allow-pass vlan 1
[S2-GigabitEthernet0/0/10]quit

[S2]vlan 10
[S2-vlan10]mac-vlan mac-address 00e0-fc68-201c
[S2-vlan10]quit

[S2]interface GigabitEthernet 0/0/1
[S2-GigabitEthernet0/0/1]port link-type hybrid
[S2-GigabitEthernet0/0/1]port hybrid untagged vlan 10
[S2-GigabitEthernet0/0/1]mac-vlan enable
[S2-GigabitEthernet0/0/1]quit

[S2]interface GigabitEthernet 0/0/2
[S2-GigabitEthernet0/0/2]port link-type hybrid
[S2-GigabitEthernet0/0/2]port hybrid untagged vlan 10
[S2-GigabitEthernet0/0/2]mac-vlan enable
[S2-GigabitEthernet0/0/2]quit

[S2]interface GigabitEthernet 0/0/3
[S2-GigabitEthernet0/0/3]port link-type hybrid
[S2-GigabitEthernet0/0/3]port hybrid untagged vlan 10
[S2-GigabitEthernet0/0/3]mac-vlan enable
[S2-GigabitEthernet0/0/3]quit
[S2]return
<S2>save
```

= Проверка конфигурации

== Проверка состояния интерфейсов

#table(
  columns: (auto, 1.5fr, 1.2fr, auto, auto),
  stroke: 0.5pt,
  align: (left, left, left, left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  [*Устройство*], [*Интерфейс*], [*IP-адрес / маска*], [*Physical*], [*Protocol*],
  [R1], [GE0/0/1], [10.1.2.1/24], [up], [up],
  [R3], [GE0/0/2], [10.1.10.1/24], [up], [up],
  [S3], [Vlanif3], [10.1.3.1/24], [up], [up],
  [S4], [Vlanif3], [10.1.3.2/24], [up], [up],
)

== Проверка связи в VLAN 3

Проверяется передача пакетов от S4 к S3 через access-порты и trunk-канал
между S1 и S2.

```
<S4>ping -c 5 10.1.3.1
  PING 10.1.3.1: 56  data bytes, press CTRL_C to break
    Reply from 10.1.3.1: bytes=56 Sequence=1 ttl=255 time=80 ms
    Reply from 10.1.3.1: bytes=56 Sequence=2 ttl=255 time=80 ms
    Reply from 10.1.3.1: bytes=56 Sequence=3 ttl=255 time=80 ms
    Reply from 10.1.3.1: bytes=56 Sequence=4 ttl=255 time=80 ms
    Reply from 10.1.3.1: bytes=56 Sequence=5 ttl=255 time=60 ms

  --- 10.1.3.1 ping statistics ---
    5 packet(s) transmitted
    5 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 60/76/80 ms
```

Обратная проверка от S3 к S4 также завершилась успешно:

```
<S3>ping -c 2 10.1.3.2
  PING 10.1.3.2: 56  data bytes, press CTRL_C to break
    Reply from 10.1.3.2: bytes=56 Sequence=1 ttl=255 time=80 ms
    Reply from 10.1.3.2: bytes=56 Sequence=2 ttl=255 time=90 ms

  --- 10.1.3.2 ping statistics ---
    2 packet(s) transmitted
    2 packet(s) received
    0.00% packet loss
    round-trip min/avg/max = 80/85/90 ms
```

Нулевые потери подтверждают правильную настройку access-портов VLAN 3 и
trunk-канала между S1 и S2.

== Проверка изоляции IP-подсетей

```
<R1>ping -c 2 10.1.3.1
  --- 10.1.3.1 ping statistics ---
    2 packet(s) transmitted
    0 packet(s) received
    100.00% packet loss

<R1>ping -c 2 10.1.3.2
  --- 10.1.3.2 ping statistics ---
    2 packet(s) transmitted
    0 packet(s) received
    100.00% packet loss

<R1>ping -c 2 10.1.10.1
  --- 10.1.10.1 ping statistics ---
    2 packet(s) transmitted
    0 packet(s) received
    100.00% packet loss
```

R1 находится только в подсети 10.1.2.0/24. Маршрутизация к подсетям
10.1.3.0/24 и 10.1.10.0/24 не настраивалась, поэтому отсутствие ответов
является ожидаемым результатом.

== Проверка MAC-VLAN 10

Для создания исходящего ARP-трафика на R3 выполнена команда:

```
<R3>ping 10.1.10.254
```

Адрес 10.1.10.254 в топологии отсутствует, поэтому ответы на ping не
ожидались. После отправки трафика выполнена проверка таблиц S2 и S1.

```
<S2>display mac-vlan vlan 10
---------------------------------------------------
MAC Address     MASK            VLAN    Priority
---------------------------------------------------
00e0-fc68-201c  ffff-ffff-ffff  10      0

Total MAC VLAN address count: 1
```

```
<S2>display mac-address vlan 10
MAC Address     VLAN  Port       Type
00e0-fc68-201c  10    GE0/0/1    dynamic

<S1>display mac-address vlan 10
MAC Address     VLAN  Port       Type
00e0-fc68-201c  10    GE0/0/10   dynamic
```

На S2 MAC-адрес R3 изучен на порту GE0/0/1, к которому подключён R3.
На S1 тот же MAC-адрес изучен на trunk-порту GE0/0/10. Это подтверждает,
что кадры R3 классифицируются как VLAN 10 и передаются между коммутаторами.

= Ответ на контрольный вопрос 3.1.5

Если специальные ПК подключены к S1 через промежуточный коммутатор S2,
классификацию MAC-VLAN можно выполнять на входном порту S1. Обычный
коммутатор не изменяет исходный MAC-адрес Ethernet-кадра, поэтому S1 всё
равно видит MAC-адрес специального ПК.

На S1 необходимо создать VLAN 10, связать с ней MAC-адрес специального ПК,
настроить входной порт как hybrid, разрешить передачу VLAN 10 без тега и
включить `mac-vlan enable`. Порт, по которому трафик передаётся дальше,
должен пропускать VLAN 10.

```
[S1]vlan 10
[S1-vlan10]mac-vlan mac-address <MAC-адрес_специального_ПК>
[S1-vlan10]quit
[S1]interface GigabitEthernet 0/0/1
[S1-GigabitEthernet0/0/1]port link-type hybrid
[S1-GigabitEthernet0/0/1]port hybrid untagged vlan 10
[S1-GigabitEthernet0/0/1]mac-vlan enable
[S1-GigabitEthernet0/0/1]quit
[S1]interface GigabitEthernet 0/0/2
[S1-GigabitEthernet0/0/2]port link-type trunk
[S1-GigabitEthernet0/0/2]port trunk allow-pass vlan 10
```

#pagebreak()

= Вывод

В ходе лабораторной работы были созданы VLAN 2, VLAN 3 и VLAN 10,
настроены access-, trunk- и hybrid-порты. Для маршрутизатора R3 выполнена
классификация трафика по фактическому MAC-адресу `00e0-fc68-201c`.

Связь между S3 и S4 внутри VLAN 3 подтверждена двусторонней проверкой
`ping` без потерь. Отсутствие маршрутизации между подсетями подтверждено
проверками с R1. MAC-адрес R3 появился в VLAN 10 на S2 и S1, что
подтверждает правильную работу MAC-VLAN и trunk-канала.
