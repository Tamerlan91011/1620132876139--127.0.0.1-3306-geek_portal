-- ЗАПРОСЫ ИЗ ФУНКЦИОНАЛЬНЫХ ТРЕБОВАНИЙ --
-- ТРАНЗАКЦИОННЫЕ ЗАПРОСЫ -- 
-- 1.Добавить статью на форум
use `geek_portal`;
select * from `article`;
alter table `article` auto_increment = 10;
insert into `article` (`title`,`text`,`user_id`,`forum_id`) value ('Lifehacks in "Jojo: Golden Eye"','Bon Jiorno, my friends!...','7','9');

-- 2.Добавить новый форум внутри выбранного фандома
-- Пришлось изменить запрос, так как добавился новый фандом, но не раздел внутри уже существующего фандома
insert into `fandom` (`idfandom`,`category`,`name`) value (11,'videogames','Jojo: Golden Eye');
delete from `fandom` where `idfandom` = 11;
alter table `fandom` auto_increment = 10;
insert into `forum` (`idforum`,`section`,`forum_name`,`fandom_id`) value (11,'Guides','Jojo: Golden Eye',9);

-- 3.Добавить нового персонажа
insert into `character` (`id`,`rchat_id`,`user_id`,`name`,`initials`,`life_status`,`description`) 
value (10,6,6,'Johnny Joestar','JoJo',1,'Cool dude who use power of spin. Standuser. Name of stand: Tusk');

-- 4.Удалить имеющегося персонажа
delete from `character` 
where `name` ='Char1' and `life_status` = 0;

-- 5.Изменить персонажа (редактирование)
update `character` 
set `name` = 'Funny Valentie'
and `initials` = 'F.V.' 
and `life_status` = 1
and `description` = 'President of USA'
where `id` = 9;

-- СПРАВОЧНЫЕ ЗАПРОСЫ -- 
-- 6.Показать новости текущего фандома (с учетом изменений имеется ввиду событие (event))
select * from `event` where fandom_id = 1;

-- 7.Показать все новости (с учетом изменений имеется ввиду события)
select `text`,`date`,`links`,`name` as 'Fandom name' from `event` join `fandom` where fandom_id = fandom.idfandom;

-- 8.Показать конкретную статью (с указанным заголовком)
select `title`,`text` from article where `title` like '%Lifehacks in "Jojo: Golden Eye%';

-- 9.Показать описание плагина (мы вибираем номер плагина и по нему смотрим описание)
-- Описанием здесь считается команда и его скрипт
SELECT `idplugin`,`gamecube`,`description`,`commands`,`scripts` 
FROM `plugin` join `tool`
WHERE idplugin = plugin_id;

-- 10. Показать игровые события (и всех его участников)
SELECT `name` as 'members',`title`,`description` 
FROM geek_portal.members_of_role_game_event,geek_portal.user JOIN geek_portal.role_game_event
where user_id = iduser 
and role_game_event_id = idrole_game_event;


-- АНАЛИТИЧЕСКИЕ ЗАПРОСЫ -- 
-- 11. Показать, сколько статей в выбранном фандоме (Фандоме "Stell ball run")
SELECT COUNT(*) as 'Articles in fandom',`name` 
FROM geek_portal.forum join geek_portal.fandom 
where 
fandom_id=9
and 
idfandom = fandom_id;

-- 12. Показать, сколько всего статей (вообще во всех фандомах)
SELECT COUNT(*) as 'Sum of articles' FROM geek_portal.article;

-- 13. Сколько пользователей выбранного пола (вместо "Показать всех активных пользователей")
SELECT COUNT(*) as 'Males'
FROM geek_portal.user
where `gender` = 'M';
SELECT COUNT(*) as 'Females'
FROM geek_portal.user
where `gender` = 'F';

-- 14. Среднее количество подключенных плагинов на один чат
select count(`rchat_id`)/count(distinct `rchat_id`) from `using_tool`;

-- 15. Среднее количество персонажей, созданных одним пользователем.
select count(`id`)/count(distinct`user_id`) as 'avg num of chars to user' from geek_portal.character;

-- ПРОЧИЕ ЗАПРОСЫ -- 
-- 16. Изменение некорректных данных (UPDATE)
UPDATE `geek_portal`.`article` 
SET `text` = 'Let me introduce you my comrades' 
WHERE (`idarticle` = '8');

-- 17.
UPDATE `geek_portal`.`article` 
SET `text` = 'I\'m Jack Hidden, and this is my blog.' 
WHERE (`idarticle` = '9');

-- 18.
UPDATE `geek_portal`.`article` 
SET `title` = 'Lifehacks in "Jojo: Golden Eye" Part 1', `text` = 'Bon Jiorno, my friends! I\'m Coule Joestar.' 
WHERE (`idarticle` = '11');

-- 19.
UPDATE `geek_portal`.`article` 
SET `title` = 'Lifehacks in "Jojo: Golden Eye" Part 2', `text` = 'Bon Jiorno, my friends! ' 
WHERE (`idarticle` = '12');

-- 20.
UPDATE `geek_portal`.`chat` 
SET `chat_name` = 'Discord pals from Server' 
WHERE (`idchat` = '10');

-- Удаление некорректных данных (Delete) --
-- 21.
delete from `message` where `idmessage` =10;
-- 22.
delete from `article` where `title` like '%Text%';
-- 23.
delete from `event` where `text` like '%Welcome to the Our Event!%';


-- Работа с датами и строками --
-- (просмотр сообщений за 2001 год, за январь, написание сообщения, и просмотр всех сообщений, где есть hello)
-- 24.
select * from `message` where `date` like '%2001%';
-- 25.
select * from `message` where monthname(`date`) = 'January';
-- 26.
insert into `message` (`user_id`,`chat_id`,`date`,`text`) values(6,9,now(),'Timur is here');
-- 27.
select * from `message` where `text` like '%hello%';

-- Копирование данных -- 

-- 30. Копирование скриптов в описание новых плагинов
insert into `plugin`(`description`) select `scripts` from `tool`;
-- 31. копирование описания персонажей в сообщения
insert into `message`(`text`,`user_id`,`chat_id`,`date`) 
select `description`,`user_id`,`rchat_id`,now() from `character`;
-- 32. Добавление участников в чаты (через персонажей)
insert into `chat_members`(`chat_id`,`user_id`)
select `rchat_id`,`character`.`user_id` from`character` where `rchat_id`!=`user_id`;

-- Соединение таблиц для статистики (JOIN"ы) -- 
-- 33. Вывод всех сообщений, напечатанных пользователями.
select `iduser`,`name`,`gender`,`date`,`text` as 'Message' 
from `user` inner join `message` on `iduser` = `user_id`;

-- 34. Вывод сообщений, напечатанных конкретным пользователем.
select `iduser`,`name`,`gender`,`date`,`text` 
from `user` join `message` on `iduser` = `user_id` and `iduser`=4; 

-- 35. Показ пользователей, которые создавали и не создавали персонажей
select * from `user` left join `character` on `user_id` = `iduser`;

-- 36. Показатеть пользователей, убивших своих персонажей
select * 
from `user` 
right join `character` on `iduser` = `user_id` 
and `life_status` =0;

-- 37. Показать пользователей, кто записал системные инициалы персонажа (символ С и порядковый номер)
select * from `user` left join `character` on `iduser` = `user_id` and `initials` like '%C%';

-- 38. Показать, в каких чатах обитают персонажи
select `rchat_id`,`user_id`,`name` as 'Character name',`life_status`,`idchat`,`chat_name` 
from `character` right join `chat` on `rchat_id`=`idchat`
union
(select `rchat_id`,`user_id`,`name` as 'Character name',`life_status`,`idchat`,`chat_name`  
from `character` left join `chat` on `rchat_id` = `idchat`);

-- 39. Показать, в каких чатах участвуют пользователи
select * from `user` left join `chat_members` on `user_id`=`iduser`;
-- Группировка по разным признакам (Group by) -- 

-- Объединение таблиц (Union) --

-- Выборка с all, any, exists -- 
-- Показать пользователей, кто оставил ссылку в событии 
-- Условимся, что в рамках данной работы одно событие - это одна ссылка
select `iduser`,`name`from `user` 
where exists
(select `links` from `event` where `links` is not null 
and
`user_id`=`iduser`);

-- Вывести пользователей, кто писал сообщения, содержащие слово "text"
select `iduser`,`name` from `user` 
where `iduser`= any
(select `user_id` from `message` where `text` like '%text%');

-- Показать все плагины, чьи id будут больше всех id из инструментов
select * from `plugin` 
where `idplugin` > all
(select `id` from `tool`);

-- Group_Concat и прочие функции --


-- Сложные многослойные запросы --
