-- СОЗДАНИЕ ТАБЛИЦ

CREATE TABLE `rooms` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`number` INT NOT NULL UNIQUE,
	`type_id` INT NOT NULL,
	`status_id` INT NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `type` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `status` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `customers` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`lastname` VARCHAR(255) NOT NULL,
	`phone` char(12) DEFAULT NULL unique,
	PRIMARY KEY (`id`)
);

CREATE TABLE `pay` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`customer_id` INT NOT NULL,
	`pay_status` INT DEFAULT '0',
    `occupied_id` int not null,
	PRIMARY KEY (`id`)
);

CREATE TABLE `occupied` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`room_id` INT NOT NULL,
	`customer_id` INT NOT NULL,
	`coming_date` DATE NOT NULL,
	`leaving_date` DATE NOT NULL,
	PRIMARY KEY (`id`)
);

ALTER TABLE `rooms` ADD CONSTRAINT `rooms_fk0` FOREIGN KEY (`type_id`) REFERENCES `type`(`id`);

ALTER TABLE `rooms` ADD CONSTRAINT `rooms_fk1` FOREIGN KEY (`status_id`) REFERENCES `status`(`id`);

ALTER TABLE `pay` ADD CONSTRAINT `pay_fk0` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`);

ALTER TABLE `pay` ADD CONSTRAINT `pay_fk1` FOREIGN KEY (`occupied_id`) REFERENCES `occupied`(`id`);

ALTER TABLE `occupied` ADD CONSTRAINT `occupied_fk0` FOREIGN KEY (`room_id`) REFERENCES `rooms`(`id`);

ALTER TABLE `occupied` ADD CONSTRAINT `occupied_fk1` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`);

-- ЗАПОЛНЕНИЕ ДАННЫМИ

insert into type (id, name) values
(1, 'one bed'),
(2, 'two beds'),
(3, 'one large bed');

insert into status (id, name) values
(1, 'free'),
(2, 'occupied'),
(3, 'under maintenance');

insert into rooms (id, number, type_id, status_id) values
(1, 202, 1, 1),
(2, 133, 2, 1),
(3, 4, 3, 1),
(4, 456, 1, 2),
(5, 777, 2, 2),
(6, 809, 3, 1),
(7, 13, 1, 3),
(8, 666, 2, 1);

insert into customers (id, name, lastname, phone) values
(1, 'Dean', 'Thomas', '9299394'),
(2, 'Simus', 'Finnigan', '9993330'),
(3, 'Polumna', 'Lavgud', '5467374'),
(4, 'Pansy', 'Parkinson', '8839465');

insert into occupied (id, room_id, customer_id, coming_date, leaving_date) values
(1, 4, 1, '2020-06-26', '2020-06-28'),
 (2, 5, 2, '2020-06-23', '2020-07-13'),
 (3, 6, 3, '2020-06-30', '2020-07-12'),
 (4, 8, 4, '2020-06-28', '2020-07-05');

 insert into pay (id, customer_id, pay_status, occupied_id) values
 (1, 1, 0, 1),
 (2, 2, 1, 2),
 (3, 3, 1, 3),
 (4, 4, 0, 4);
 
 -- ТИПОВЫЕ ОПЕРАЦИИ

update customers set phone = '3334449' where name = 'Dean' and lastname = 'Thomas';
-- если ошиблись

update rooms set status_id = 3 where number = 4;
-- если комната отправляется на ремонт

insert into customers (name, lastname, phone) values
('Colin', 'Creevey', '3210987');
select * from customers where name = 'Colin' and lastname = 'Creevey';
insert into occupied (room_id, customer_id, coming_date, leaving_date) values
(1, 5, '2020-06-28', '2020-07-09');
insert into pay (customer_id, pay_status, occupied_id) values
(5, 1, 5);
-- добавили нового постояльца
 
update rooms, occupied set rooms.status_id = 2 where occupied.coming_date = curdate() and occupied.room_id = rooms.id;

update rooms, occupied set rooms.status_id = 1 where occupied.leaving_date = curdate() and occupied.room_id = rooms.id;

 -- ежедневное обновление занятых/свободных номеров
 
update pay set pay_status = 1 where customer_id = 1;
-- когда заплатили

-- ПРЕДСТАВЛЕНИЯ

create view `not_payed` as 
select r.number as room, concat_ws(' ', c.name, c.lastname) as name, 
c.phone as phone, oc.leaving_date as leaving_date
from customers as c, rooms as r, pay as p, occupied as oc
where p.pay_status = 0 and r.status_id = 2 and oc.room_id = r.id and c.id = p.customer_id and c.id = oc.customer_id;

create view `free_rooms` as
select r.number as room, type.name as `type`, s.name as `status`
from rooms as r, type, `status` as s
where r.status_id = 1 and r.type_id = type.id and r.status_id = s.id;
