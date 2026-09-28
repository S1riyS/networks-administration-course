#set document(title: "ЛР4.2 Настройка локального механизма AAA")
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
    Лабораторная работа №4.2\
    «Настройка локального механизма AAA»
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
#image("images/topology.png")

= Конфигурация

== Задание имен устройствам

```
[R1] sysname R1
[R2] sysname R2
```

== Настройка IP-адресов для маршрутизаторов R1 и R2
```
[R1]interface g0/0/2
[R1-GigabitEthernet0/0/2]ip addr 10.0.12.1 24

[R2]interface g0/0/2
[R2-GigabitEthernet0/0/2]ip addr 10.0.12.2 24
```

== Настройка схемы AAA

```
[R2]aaa
[R2-aaa]authentication-scheme datacom
Info: Create a new authentication scheme.
[R2-aaa-authen-datacom]authentication-mode local
[R2-aaa-authen-datacom]quit
[R2-aaa]authorization-scheme datacom
Info: Create a new authorization scheme.
[R2-aaa-author-datacom]authorization-mode local
[R2-aaa-author-datacom]quit
```

#pagebreak()

== Создание домена и применение к нему схемы AAA

```
[R2]aaa
[R2-aaa]domain datacom
Info: Success to create a new domain.
[R2-aaa-domain-datacom]authentication-scheme datacom
[R2-aaa-domain-datacom]authorization-scheme datacom
```

== Настройка локальных пользователей
```
[R2-aaa]local-user hcia@datacom password cipher HCIA-Datacom
Info: Add a new user.
[R2-aaa]local-user hcia@datacom service-type telnet
[R2-aaa]local-user hcia@datacom privilege level 3
```

== Включение функции telnet на R2
```
[R2-aaa]telnet server enable
 Error: TELNET server has been enabled
[R2]user-interface vty 0 4
[R2-ui-vty0-4]authentication-mode aaa
```

= Проверка конфигурации

```
<R1>telnet 10.0.12.2
  Press CTRL_] to quit telnet mode
  Trying 10.0.12.2 ...
  Connected to 10.0.12.2 ...

Login authentication


Username:hcia@datacom
Password:
<R2>dis users
  User-Intf    Delay    Type   Network Address     AuthenStatus    AuthorcmdFlag
  0   CON 0   00:02:30                                   pass                   
  Username : Unspecified

+ 129 VTY 0   00:00:00  TEL    10.0.12.1                 pass                   
  Username : hcia@datacom        

```