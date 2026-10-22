#set document(title: "ЛР6 Создание WLAN")
#set page(paper: "a4", margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm))

#set text(lang: "ru", font: "Liberation Serif", size: 14pt)
#set par(justify: true, leading: 0.8em, first-line-indent: 1.25cm)
#set heading(numbering: "1.")
#show heading: set par(first-line-indent: 0pt)

#show raw: set text(font: "Liberation Mono", size: 9pt)

#show raw.where(block: true): it => {
  set par(leading: 0.65em)
  block(
    fill: luma(240),
    stroke: 0.5pt + luma(180),
    inset: 8pt,
    radius: 4pt,
    width: 100%,
    breakable: true,
    it,
  )
}

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
    Лабораторная работа №6\
    «Создание WLAN»
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

#let step(title) = par(first-line-indent: 0pt, [#strong[#title]])

#pagebreak()

= Создание WLAN

== Топология

#image("images/1_topology.png", width: 100%)

== Конфигурирование

=== Настройка параметров проводной сети

#step[Настройка VLAN:]

```
[S1]vlan batch 100 101
Info: This operation may take a few seconds. Please wait for a moment...done.

[S1]interface g0/0/13
[S1-GigabitEthernet0/0/13]port link-type trunk
[S1-GigabitEthernet0/0/13]port trunk allow-pass vlan 100 101
[S1-GigabitEthernet0/0/13]quit

[S1]interface g0/0/14
[S1-GigabitEthernet0/0/14]port link-type trunk
[S1-GigabitEthernet0/0/14]port trunk allow-pass vlan 100 101
[S1-GigabitEthernet0/0/14]quit

[S1]interface g0/0/10
[S1-GigabitEthernet0/0/10]port link-type trunk
[S1-GigabitEthernet0/0/10]port trunk allow-pass vlan 100 101
[S1-GigabitEthernet0/0/10]quit

[AC]vlan batch 100 101
Info: This operation may take a few seconds. Please wait for a moment...done.

[AC]interface g0/0/10
[AC-GigabitEthernet0/0/10]port link-type trunk
[AC-GigabitEthernet0/0/10]port trunk allow-pass vlan 100 101
[AC-GigabitEthernet0/0/10]quit

[S3]vlan batch 100 101
Info: This operation may take a few seconds. Please wait for a moment...done.

[S3]interface g0/0/1
[S3-GigabitEthernet0/0/1]port link-type trunk
[S3-GigabitEthernet0/0/1]port trunk allow-pass vlan 100 101
[S3-GigabitEthernet0/0/1]quit

[S3]interface g0/0/4
[S3-GigabitEthernet0/0/4]port link-type trunk
[S3-GigabitEthernet0/0/4]port trunk pvid vlan 100
[S3-GigabitEthernet0/0/4]port trunk allow-pass vlan 100 101
[S3-GigabitEthernet0/0/4]quit

[S4]vlan batch 100 101
Info: This operation may take a few seconds. Please wait for a moment...done.

[S4]interface g0/0/1
[S4-GigabitEthernet0/0/1]port link-type trunk
[S4-GigabitEthernet0/0/1]port trunk allow-pass vlan 100 to 101
[S4-GigabitEthernet0/0/1]quit

[S4]interface g0/0/4
[S4-GigabitEthernet0/0/4]port link-type trunk
[S4-GigabitEthernet0/0/4]port trunk pvid vlan 100
[S4-GigabitEthernet0/0/4]port trunk allow-pass vlan 100 to 101
[S4-GigabitEthernet0/0/4]quit
```

#step[Настройка IP-адресов интерфейсов:]

```
[S1]interface Vlanif 101
[S1-Vlanif101]ip addr 192.168.101.254 24
[S1-Vlanif101]quit

[S1]interface LoopBack 0
[S1-LoopBack0]ip address 10.0.1.1 32
[S1-LoopBack0]quit

[AC]interface Vlanif 100
[AC-Vlanif100]ip addr 192.168.100.254 24
```

#step[Настройка DHCP:]

```
[S1]dhcp enable
Info: The operation may take a few seconds. Please wait for a moment.done.

[S1]ip pool sta
Info: It's successful to create an IP address pool.
[S1-ip-pool-sta]network 192.168.101.0 mask 24
[S1-ip-pool-sta]gateway-list 192.168.101.254
[S1-ip-pool-sta]quit

[S1]interface Vlanif 101
[S1-Vlanif101]dhcp select global
[S1-Vlanif101]quit

[AC]dhcp enable
Info: The operation may take a few seconds. Please wait for a moment.done.

[AC]ip pool ap
Info: It is successful to create an IP address pool.
[AC-ip-pool-ap]network 192.168.100.254 mask 24
[AC-ip-pool-ap]gateway-list 192.168.100.254
[AC-ip-pool-ap]quit

[AC]interface Vlanif 100
[AC-Vlanif100]dhcp select global
[AC-Vlanif100]quit
```

=== Настройка параметров точек доступа для выхода в сеть

#step[Создание группы AP ap-group1:]

```
[AC]wlan
[AC-wlan-view]ap-group name ap-group1
Info: This operation may take a few seconds. Please wait for a moment.done.
[AC-wlan-ap-group-ap-group1]quit
```

#step[Создание профиля регулирующего домена и настройка кода страны AC в профиле:]

```
[AC]wlan
[AC-wlan-view]regulatory-domain-profile name default
[AC-wlan-regulate-domain-default]country-code cn
Info: The current country code is same with the input country code.
```

#step[Установка привязки профиля регулирующего домена к группе AP:]

```
[AC]wlan
[AC-wlan-view]ap-group name ap-group1
[AC-wlan-ap-group-ap-group1]regulatory-domain-profile default
Warning: Modifying the country code will clear channel, power and antenna gain
configurations of the radio and reset the AP. Continue?[Y/N]:Y
[AC-wlan-ap-group-ap-group1]quit
```

#step[Указание интерфейса-источника на AC для установления туннелей CAPWAP:]

```
[AC]capwap source interface Vlanif 100
```

#step[Импорт точки доступа в AC и добавление их в группу AP с именем ap-group1:]

```
[AC]wlan
[AC-wlan-view]ap auth-mode mac-auth
[AC-wlan-view]ap-id 0 ap-mac 00e0-fccc-1a80
Error: AP already exists.
[AC-wlan-view]ap-name ap1
[AC-wlan-ap-0]ap-group ap-group1
Warning: This operation may cause AP reset. If the country code changes, it will
clear channel, power and antenna gain configurations of the radio, Whether to
continue? [Y/N]:Y
Info: This operation may take a few seconds. Please wait for a moment.. done.
[AC-wlan-ap-0]quit

[AC-wlan-view]ap-id 1 ap-mac 00e0-fc51-4890
[AC-wlan-ap-1]ap-name ap2
[AC-wlan-ap-1]ap-group ap-group1
Warning: This operation may cause AP reset. If the country code changes, it will
clear channel, power and antenna gain configurations of the radio, Whether to
continue? [Y/N]:Y
Info: This operation may take a few seconds. Please wait for a moment.. done.
[AC-wlan-ap-1]quit
```

#step[Вывод на экран информации о текущей AP:]

```
[AC]wlan
[AC-wlan-view]display ap all
Info: This operation may take a few seconds. Please wait for a moment.done.
Total AP information:
nor  : normal          [2]
--------------------------------------------------------------------------------
ID   MAC            Name Group     IP              Type      State STA Uptime
--------------------------------------------------------------------------------
0    00e0-fccc-1a80 ap1  ap-group1  192.168.100.205 AP2050DN  nor   0   48S
1    00e0-fc51-4890 ap2  ap-group1  192.168.100.164 AP2050DN  nor   0   1M:15S
--------------------------------------------------------------------------------
Total: 2
```

=== Настройка параметров сервисов WLAN

#step[Создание профиля безопасности HCIA-WLAN и настройка политики безопасности:]

```
[AC-wlan-view]security-profile name HCIA-WLAN
[AC-wlan-sec-prof-HCIA-WLAN]security wpa-wpa2 psk pass-phrase HCIA-Datacom aes
[AC-wlan-sec-prof-HCIA-WLAN]quit
```

#step[Создание профиля SSID HCIA-WLAN и задание имени SSID HCIA-WLAN:]

```
[AC-wlan-view]ssid-profile name HCIA-WLAN
[AC-wlan-ssid-prof-HCIA-WLAN]ssid HCIA-WLAN
Info: This operation may take a few seconds, please wait.done.
[AC-wlan-ssid-prof-HCIA-WLAN]quit
```

#step[Создание профиля VAP HCIA-WLAN, настройка режима передачи данных и сервисного VLAN и применение профиля безопасности и профиля SSID к профилю VAP:]

```
[AC-wlan-view]vap-profile name HCIA-WLAN
[AC-wlan-vap-prof-HCIA-WLAN]forward-mode direct-forward
[AC-wlan-vap-prof-HCIA-WLAN]service-vlan vlan-id 101
Info: This operation may take a few seconds, please wait.done.

[AC-wlan-vap-prof-HCIA-WLAN]security-profile HCIA-WLAN
Info: This operation may take a few seconds, please wait.done.

[AC-wlan-vap-prof-HCIA-WLAN]ssid-profile HCIA-WLAN
Info: This operation may take a few seconds, please wait.done.
[AC-wlan-vap-prof-HCIA-WLAN]quit
```

#step[Установление привязки профиля VAP к группе AP и применение конфигурации профиля VAP HCIA-WLAN к радиомодулю 0 и радиомодулю 1 точек доступа в группе AP:]

```
[AC-wlan-view]ap-group name ap-group1
[AC-wlan-ap-group-ap-group1]vap-profile HCIA-WLAN wlan 1 radio all
Info: This operation may take a few seconds, please wait...done.
[AC-wlan-ap-group-ap-group1]quit
```

== Проверка

Перед проверкой нужно подключиться к WLAN. Пароль: HCIA-Datacom.

#image("images/2_STA1.png", width: 100%)

```
STA>ping 10.0.1.1
Ping 10.0.1.1: 32 data bytes, Press Ctrl_C to break
From 10.0.1.1: bytes=32 seq=1 ttl=255 time=140 ms
From 10.0.1.1: bytes=32 seq=2 ttl=255 time=125 ms
From 10.0.1.1: bytes=32 seq=3 ttl=255 time=125 ms
From 10.0.1.1: bytes=32 seq=4 ttl=255 time=125 ms
From 10.0.1.1: bytes=32 seq=5 ttl=255 time=141 ms

--- 10.0.1.1 ping statistics ---
5 packet(s) transmitted
5 packet(s) received
0.00% packet loss
round-trip min/avg/max = 125/131/141 ms
```

```
[AC]display station all
Rf/WLAN: Radio ID/WLAN ID
Rx/Tx: link receive rate/link transmit rate(Mbps)
--------------------------------------------------------------------------------
STA MAC         AP ID  Ap name  Rf/WLAN  Band  Type  Rx/Tx  RSSI  VLAN
5489-981f-4024  0      ap1      0/1      2.4G  -     -/-    -     101
IP address: 192.168.101.253    SSID: HCIA-WLAN
--------------------------------------------------------------------------------
Total: 1 2.4G: 1 5G: 0
```

== Вывод

В ходе выполнения данной лабораторной работы мы сконфигурировали WLAN с
помощью контроллера доступа (AC) и точек доступа AP, чтобы обеспечить доступ
STA к WLAN.
