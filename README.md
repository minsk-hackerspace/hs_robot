
Робот удалённого присутствия
======================================

Прототип #1 онлайн: http://91.215.176.168:8081


Обзор прототипа #1
------------------

### Hardware

Модули:
- Шасси от китайского робота-танка
- 3.7V аккум от USB power bank с родно платой для зарядки
- Повышающий регулируемый импульсный преобразователь напряжения для двигателей (подключается напрямую к аккуму)
- Arduino motor-shield
- Raspberry Pi B+
- 5Mp CSI камера на Omnivision 5647


### Software

Работает 3 сервера:
- web/connector.rb - управляет двигателями, слушает комманды от сервера web-интерфейса, порт 2000
- web/main.rb - web-интерфейс, порт 8081, принимает команды от браузерного javascript и транслирует их на 2000 порт
- mjpeg-streamer, порт 8080

Web-интерфейс отдаёт главную страницу (web/view/index.haml) в которой iframe в который подгружается страница от mjpeg-streamer с порта 8080.  
Для работы необходимо два открытых порта: 8080 и 8081

#### Video-streaming

Подробное описание способов видеостриминга в Documentation/video.md  
Самым быстрым оказался mjpeg-streamer вот отсюда: [https://github.com/jacksonliam/mjpg-streamer]  
Он сейчас и используется.  

#### WEB-интерфейс

Web-интерфейс построен на базе web-фреймворка Sinatra

#### Middleware

web/connector.rb управляет GPIO с помощью кода из web/robot/  
Который использует стандартный GPIO интерфейс linux - /sys/class/gpio

[http://habrahabr.ru/post/236251/](Habr: Linux: кнопки, светодиоды и GPIO)  
[https://www.kernel.org/doc/Documentation/gpio/sysfs.txt](Linux Documentation: GPIO Sysfs Interface for Userspace)


#### Startup scripts

На RPi в /etc/rc.local добавлен запуск скрипта:
- startup/robot.sh middleware start
- startup/robot.sh web start
- startup/robot.sh video start

Оба скприпта - запускают команды в screen и выводят вывод команд в логи:
- /var/log/connector.screen.log
- /var/log/main.screen.log
- /var/log/mjpeg.screen.log
