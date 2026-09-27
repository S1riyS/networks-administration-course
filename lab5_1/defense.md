# ЛР5.1 — шпаргалка для защиты

Топология: R1 (`10.0.12.1/24`) — FTP-клиент, R2 (`10.0.12.2/24`) — FTP-сервер. Соединение: `GE0/0/2 ↔ GE0/0/2`.

## 0. Подготовить перед защитой

R1:

```text
save test1.cfg
y
```

R2:

```text
save test2.cfg
y
```

Если предложена перезапись существующего файла — ответить `y`.

## 1. Адресация и связность

R1:

```text
display ip interface brief
ping 10.0.12.2
display ip routing-table
```

Показать: `GE0/0/2` — `10.0.12.1`, `up/up`; ping без потерь; сеть `10.0.12.0/24` имеет тип `Direct`.

R2:

```text
display ip interface brief
display ftp-server
display current-configuration configuration aaa
```

Показать: `GE0/0/2` — `10.0.12.2`, `up/up`; FTP запущен; у `ftp-client` есть `service-type ftp`, `privilege level 15`, `ftp-directory flash:/`.

## 2. Исходное состояние файлов

R1:

```text
dir
```

Показать `test1.cfg`.

R2:

```text
dir
```

Показать `test2.cfg`.

## 3. Вход по FTP с R1

```text
ftp 10.0.12.2
```

Ввести по запросам:

```text
User: ftp-client
Password: Huawei@123
```

Показать `230 User logged in` и приглашение `[R1-ftp]`.

Не закрывая сеанс, при необходимости показать на R2:

```text
display ftp-server users
```

Если команда не поддерживается, использовать `display ftp-server`.

## 4. Операции с файлами на R1

В режиме `[R1-ftp]` выполнять по одной:

```text
ascii
dir
get test2.cfg
delete test2.cfg
y
put test1.cfg
dir
bye
```

Что показать:

- после `get` — `226 Transfer complete`, файл передан R2 → R1;
- после `delete` — `250 DELE command successful`, удалён файл на R2;
- после `put` — `226 Transfer complete`, файл передан R1 → R2;
- последний FTP-`dir` — на R2 есть `test1.cfg`, но нет `test2.cfg`;
- после `bye` — `221 Server closing` и приглашение `<R1>`.

Если `get` спрашивает о перезаписи локального файла — ответить `y`.

## 5. Итоговая проверка

R1:

```text
dir
```

Должны быть `test1.cfg` и скачанный `test2.cfg`.

R2:

```text
dir
```

Должен быть загруженный `test1.cfg`; `test2.cfg` отсутствует.

Итоговая фраза: «R1 скачал конфигурацию R2, удалил исходный файл с FTP-сервера и загрузил на R2 собственную конфигурацию. Изменение каталогов подтверждает передачу файлов в обоих направлениях».

## Короткие ответы на вопросы

- **Почему ping недостаточно?** Он проверяет только IP-доступность, но не FTP, AAA и передачу файлов.
- **`get` / `put`?** `get`: R2 → R1; `put`: R1 → R2.
- **Зачем `ftp server enable`?** FTP-сервер по умолчанию выключен.
- **Зачем `ftp-directory flash:/`?** Это разрешённый пользователю каталог; без него вход не работает.
- **Почему privilege 15?** Разрешает файловые операции; по методичке требуется уровень не ниже 3.
- **Почему ASCII?** `.cfg` — текст; прошивки и архивы передаются в binary.
- **Порты FTP?** TCP 21 — управление, TCP 20 — данные в активном режиме.
- **Режим по умолчанию?** Активный.
- **Безопасен ли FTP?** Нет, данные не шифруются; в реальной сети лучше SFTP.
- **`save test1.cfg` и `save`?** Первое создаёт файл для FTP; второе сохраняет загрузочную конфигурацию (`vrpcfg.zip`).

## Минимальный набор команд

```text
# R1
display ip interface brief
ping 10.0.12.2
dir
ftp 10.0.12.2

# R1 в FTP
ascii
dir
get test2.cfg
delete test2.cfg
put test1.cfg
dir
bye

# R2
display ftp-server
display current-configuration configuration aaa
dir
```
