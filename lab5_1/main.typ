#set document(title: "ЛР5.1 Настройка FTP")
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

#let source(path, lang) = raw(read(path), lang: lang, block: true)

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
    Лабораторная работа №5.1\
    «Настройка FTP»
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

#image("img.png", width: 100%)

В работе используются два маршрутизатора Huawei AR2220, соединённые
медным Ethernet-кабелем через интерфейсы GigabitEthernet0/0/2. R1 работает
как FTP-клиент, а R2 — как FTP-сервер.

#table(
  columns: (auto, 1.7fr, 1.4fr, 1.2fr),
  stroke: 0.5pt,
  align: (left, left, left, left),
  fill: (_, row) => if row == 0 { luma(230) } else { none },
  [*Устройство*], [*Интерфейс*], [*IP-адрес / маска*], [*Назначение*],
  [R1], [GigabitEthernet0/0/2], [10.0.12.1/24], [FTP-клиент],
  [R2], [GigabitEthernet0/0/2], [10.0.12.2/24], [FTP-сервер],
)

= Конфигурация

== Настройка основных параметров R1

Маршрутизатору назначено имя R1, а интерфейсу GigabitEthernet0/0/2 —
адрес 10.0.12.1/24.

```
<Huawei>system-view
[Huawei]sysname R1
[R1]interface GigabitEthernet0/0/2
[R1-GigabitEthernet0/0/2]ip address 10.0.12.1 255.255.255.0
[R1-GigabitEthernet0/0/2]undo shutdown
[R1-GigabitEthernet0/0/2]quit
[R1]return
```

== Настройка основных параметров R2

Маршрутизатору назначено имя R2, а интерфейсу GigabitEthernet0/0/2 —
адрес 10.0.12.2/24.

```
<Huawei>system-view
[Huawei]sysname R2
[R2]interface GigabitEthernet0/0/2
[R2-GigabitEthernet0/0/2]ip address 10.0.12.2 255.255.255.0
[R2-GigabitEthernet0/0/2]undo shutdown
[R2-GigabitEthernet0/0/2]quit
```

== Проверка сетевой связности

Доступность FTP-сервера проверена с маршрутизатора R1 командой `ping`.

#source("images/screen1/screen1.txt", "text")

Получено пять ответов из пяти, потери пакетов отсутствуют. Следовательно,
IP-адресация и физическое соединение маршрутизаторов настроены правильно.

== Настройка функции FTP-сервера на R2

На R2 включена функция FTP-сервера. По умолчанию эта функция на устройствах
Huawei отключена.

```
[R2]ftp server enable
Info: Succeeded in starting the FTP server
```

== Настройка локального пользователя FTP

В представлении AAA создан пользователь `ftp-client`. Для него разрешён
доступ по FTP, установлен уровень привилегий 15 и назначен доступ к каталогу
`flash:/`.

```
[R2]aaa
[R2-aaa]local-user ftp-client password cipher Huawei@123
[R2-aaa]local-user ftp-client service-type ftp
[R2-aaa]local-user ftp-client privilege level 15
[R2-aaa]local-user ftp-client ftp-directory flash:/
[R2-aaa]quit
[R2]return
```

== Сохранение конфигурационных файлов

На R1 текущая конфигурация сохранена в файл `test1.cfg`.

```
<R1>save test1.cfg
Are you sure to save the configuration to test1.cfg? (y/n)[n]:y
Configuration file had been saved successfully
```

Наличие созданного файла подтверждено командой `dir`.

#source("images/screen2/screen2.txt", "text")

На R2 текущая конфигурация сохранена в файл `test2.cfg`.

```
<R2>save test2.cfg
Are you sure to save the configuration to test2.cfg? (y/n)[n]:y
Configuration file had been saved successfully
```

Файл `test2.cfg` присутствует в каталоге `flash:/` маршрутизатора R2.

#source("images/screen3/screen3.txt", "text")

= Выполнение операций FTP

== Подключение к FTP-серверу

С маршрутизатора R1 выполнено подключение к FTP-серверу по адресу
10.0.12.2. Для аутентификации использована созданная на R2 учётная запись
`ftp-client`.

#source("images/screen4/screen4.txt", "text")

Ответ `230 User logged in` подтверждает успешную аутентификацию и переход
в режим FTP-клиента.

== Загрузка конфигурационного файла с сервера

Для передачи текстового конфигурационного файла выбран режим ASCII. Перед
скачиванием выведено содержимое удалённого каталога R2, после чего файл
`test2.cfg` загружен на R1 командой `get`.

#source("images/screen5/screen5.txt", "text")

Сообщение `226 Transfer complete` подтверждает успешную передачу 1069 байт
с FTP-сервера на клиент.

== Удаление конфигурационного файла с сервера

После скачивания файл `test2.cfg` удалён из каталога FTP-сервера.

```
[R1-ftp]delete test2.cfg
Warning: The contents of file test2.cfg cannot be recycled.
Continue? (y/n)[n]:y
250 DELE command successful.
```

== Выгрузка конфигурационного файла на сервер

Файл `test1.cfg` передан с R1 на R2 командой `put`.

#source("images/screen6/screen6.txt", "text")

Сообщение `226 Transfer complete` подтверждает успешную передачу 846 байт
с FTP-клиента на сервер.

Содержимое удалённого каталога после выполнения операций:

#source("images/screen7/text.txt", "text")

В каталоге R2 присутствует загруженный файл `test1.cfg`, а удалённый файл
`test2.cfg` отсутствует. После проверки FTP-сеанс завершён.

```
[R1-ftp]bye
221 Server closing.

<R1>
```

= Проверка результата

== Проверка каталога R1

После завершения FTP-сеанса на R1 выполнена команда `dir`.

#source("images/screen8/text.txt", "text")

На R1 присутствуют исходный файл `test1.cfg` и загруженный с сервера файл
`test2.cfg`.

== Проверка каталога R2

На R2 также выполнена проверка содержимого каталога `flash:/`.

#source("images/screen9/text.txt", "text")

На R2 находится переданный клиентом файл `test1.cfg`. Файл `test2.cfg`
отсутствует, что подтверждает успешное выполнение операции удаления.
