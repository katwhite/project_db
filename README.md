# project_db
 
# Структура проекта

База состоит из таблиц:    
- `type` - тип номера(одноместный/двуместный/etc.),    
- `status` - статус номера(занят/на ремонте/свободен),    
- `rooms` - номера, содержащие вторичный ключ на таблицы `type` и `status`,    
- `customers` - постояльцы,    
- `occupied` - занятые номера с датой заезда и выезда (включая бронь на будущее и постояльцев, которые оставались в гостинице в прошлом). Вторичный ключ на `customers` и `rooms`,    
- `pay` - статус оплаты одного посещения, имеет вторичный ключ на `occupied` и `customers`.    

В проект входят два представления:    

- `not_payed` - показывает постояльцев, ещё не оплативших проживание,
- `free_rooms` - показывает свободные номера.    

В файле `scheme.jpg` можно увидеть схему связи таблиц.

В файле `project.sql`:    
- Создание таблиц (1-58 строчки),    
- Заполнение таблиц данными(60-98 строчки),    
- Типовые операции (100-124 строчки),    
- Создание представлений (126-137 строчки).    

# Типовые операции

## Исправление ошибки      
```update customers set phone = '3334449' where name = 'Dean' and lastname = 'Thomas';```    
## Обновление статуса номера     
```update rooms set status_id = 3 where number = 4;```    

## Добавление нового постояльца     
```insert into customers (name, lastname, phone) values
('Colin', 'Creevey', '3210987');    
select * from customers where name = 'Colin' and lastname = 'Creevey';    
insert into occupied (room_id, customer_id, coming_date, leaving_date) values
(1, 5, '2020-06-28', '2020-07-09');    
insert into pay (customer_id, pay_status, occupied_id) values
(5, 1, 5);
```

## Ежедневное обновление занятых/свободны номеров     
Если заехали сегодня, то сменить статус на "occupied":    
```update rooms, occupied set rooms.status_id = 2 where occupied.coming_date = curdate() and occupied.room_id = rooms.id;```    

Если выехали сегодня, то сменить статус на "free":    
`update rooms, occupied set rooms.status_id = 1 where occupied.leaving_date = curdate() and occupied.room_id = rooms.id;`     

## Подтверждение оплаты     
`update pay set pay_status = 1 where customer_id = 1;`    

