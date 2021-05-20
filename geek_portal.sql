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

-- 9.Показать описание плагина (мы выбираем номер плагина и по нему смотрим описание)
-- Описанием здесь считается команда и его скрипт
SELECT `idplugin`,`gamecube`,`description`,`commands`,`scripts` 
FROM `plugin` 
join `tool` on idplugin = plugin_id;

-- 10. Показать игровые события (и всех его участников)
SELECT `name` as 'members',`title`,`description` 
FROM `members_of_role_game_event`
JOIN `user` on `user_id` = `iduser`
JOIN `role_game_event` on `role_game_event_id` = `idrole_game_event`;


-- АНАЛИТИЧЕСКИЕ ЗАПРОСЫ -- 
-- 11. Показать, сколько статей в выбранном фандоме (Фандоме "Stell ball run")
SELECT COUNT(*) as 'Articles in fandom',`name` 
FROM `forum` join `fandom` on `fandom_id` = `idfandom`
where 
fandom_id=9;

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
-- ИЗМЕНЕНИЕ НЕКОРРЕКТНЫХ ДАННЫХ (UPDATE) --
-- 16.(1) Изменение некорректных данных
UPDATE `geek_portal`.`article` 
SET `text` = 'Let me introduce you my comrades' 
WHERE `idarticle` = '8';

-- 17.(2) Изменение текста статьи
UPDATE `geek_portal`.`article` 
SET `text` = 'I\'m Jack Hidden, and this is my blog.' 
WHERE (`idarticle` = '9');

-- 18.(3) Изменение текста статьи
UPDATE `geek_portal`.`article` 
SET `title` = 'Lifehacks in "Jojo: Golden Eye" Part 1', `text` = 'Bon Jiorno, my friends! I\'m Coule Joestar.' 
WHERE (`idarticle` = '11');

-- 19.(4) Изменение заголовка статьи
UPDATE `geek_portal`.`article` 
SET `title` = 'Lifehacks in "Jojo: Golden Eye" Part 2', `text` = 'Bon Jiorno, my friends! ' 
WHERE (`idarticle` = '12');

-- 20.(5) Изменение названия чата
UPDATE `geek_portal`.`chat` 
SET `chat_name` = 'Discord pals from Server' 
WHERE (`idchat` = '10');

-- УДАЛЕНИЕ НЕКОРРЕКТНЫХ ДАННЫХ (Delete) --
-- 21.(1) Удалить сообщение, чьё id
delete from `message` where `idmessage` =10;

-- 22.(2) Удалить статьи, чьи заголовки содержат слово "Text"
delete from `article` where `title` like '%Text%';

-- 23.(3) Удалить события, чье содержание стандартно
delete from `event` where `text` like '%Welcome to the Our Event!%';


-- Работа с датами и строками --

-- 24.(1) просмотр сообщений за 2001 год
select * from `message` where `date` like '%2001%';

-- 25.(2) за январь
select * from `message` where monthname(`date`) = 'January';

-- 26.(3) написание сообщения
insert into `message` (`user_id`,`chat_id`,`date`,`text`) values(6,9,now(),'Timur is here');

-- 27.(4) просмотр всех сообщений, где есть hello
select * from `message` where `text` like '%hello%';


-- КОПИРОВАНИЕ ДАННЫХ -- 

-- 30.(1) Копирование скриптов в описание новых плагинов
insert into `plugin`(`description`) select `scripts` from `tool`;

-- 31.(2) копирование описания персонажей в сообщения
insert into `message`(`text`,`user_id`,`chat_id`,`date`) 
select `description`,`user_id`,`rchat_id`,now() from `character`;

-- 32.(3) Добавление участников в чаты (через персонажей)
insert into `chat_members`(`chat_id`,`user_id`)
select `rchat_id`,`character`.`user_id` from`character` where `rchat_id`!=`user_id`;


-- СОЕДИНЕНИЕ ТАБЛИЦ ДЛЯ СТАТИСТИКИ И ВЫБОРКА (JOIN"ы) -- 

-- 33.(1) Вывод всех сообщений, напечатанных пользователями.
select `iduser`,`name`,`gender`,`date`,`text` as 'Message' 
from `user` inner join `message` on `iduser` = `user_id`;

-- 34.(2) Показ сообщений, напечатанных конкретным пользователем.
select `iduser`,`name`,`gender`,`date`,`text` 
from `user` join `message` on `iduser` = `user_id` 
where  `iduser`=4; 

-- 35.(3) Показ пользователей, которые создавали и не создавали персонажей
select * from `user` left join `character` on `user_id` = `iduser`;

-- 36.(4) Показать пользователей, убивших своих персонажей
select `email`,`user`.`name` as 'Username',`gender`,`rchat_id`,`character`.`name` as 'char_name',`life_status`,`description`
from `user` 
right join `character` on `iduser` = `user_id` 
and `life_status` =0;

-- 37.(5) Показать пользователей, кто записал системные инициалы персонажа (символ С и порядковый номер)
select * from `user` left join `character` on `iduser` = `user_id` and `initials` like '%C%';

-- 38.(6) Показать, в каких чатах обитают персонажи
select `rchat_id`,`user_id`,`name` as 'Character name',`life_status`,`idchat`,`chat_name` 
from `character` right join `chat` on `rchat_id`=`idchat`
union
(select `rchat_id`,`user_id`,`name` as 'Character name',`life_status`,`idchat`,`chat_name`  
from `character` left join `chat` on `rchat_id` = `idchat`);

-- 39.(7) Показать, в каких чатах участвуют пользователи
select * from `user` left join `chat_members` on `user_id`=`iduser`;

-- 40.(8) Показать, в каких событиях участвуют пользователи
select * from `event` right join `user` on `user_id` = `iduser`;

-- 41.(9) К каким фандомам относятся события
select * from `event` right join `fandom` on `fandom_id` = `idfandom`;

-- 42.(10) К каким событиям, а соответсвенно фандомам относятся пользователи
select `fandom_id`,`date`,`links`,`text`,`user`.`name` as 'User name',`idfandom`,`category`,`fandom`.`name` as 'Fandom name' 
from `event` 
right join `user` on `iduser` = `user_id`
right join `fandom` on `fandom_id` = `idfandom`;

-- 43.(11) К каким фандомам относятся форумы
select `section`,`forum_name`,`category`,`name` as 'Fandom name' 
from `forum` 
right join `fandom` on `fandom_id` = `idfandom`;

-- 44.(12) К каким форумам относяться статьи
select `date`,`title` as 'Article title',`links`,`section`,`forum_name` 
from `article` 
right join `forum` on `forum_id` = `idforum`;

-- 45.(13) Показать чаты, где используются плагины
select `id` as 'RoleChat ID',`idplugin`,`Description`
from `role_chat` 
right join `using_tool` on `role_chat`.id = `using_tool`.rchat_id
right join `plugin` on `using_tool`.`plugin_id` = `idplugin`;

-- 46.(14) Показать, какие инструменты используются в плагинах
select `Description`, `commands`,`gamecube`,`scripts`
from `plugin`
left join `tool` on `idplugin` = `plugin_id`;

-- 47.(15) Показать, на каких фандомах основы ролевые чаты
select `id` as 'Rolechat id',`category`,`name` as 'Fandom name'
from `role_chat`
right join `fandom_based_rchats` on `role_chat`.`id` = `fandom_based_rchats`.`rchat_id`
right join `fandom` on `fandom_id` = `idfandom`;

-- 48.(16) Показать сообщения, которые отсылались в ролевых чатах, основанных на фандомах
select `date`,`text` as 'Message',`category`,`name` as 'Fandomname'
from `message` 
right join `fandom_based_rchats` on `rchat_id`=`chat_id`
right join `fandom` on `fandom_id`=`idfandom`;

-- 49.(17) Показать пользователя и его сообщение в чатах, основанных на фандомах
select `chat_id` as 'Number of chat',`date`,`user`.`name` as 'Username',`gender`,`text` as 'Text of message',`fandom`.`name` as 'Fandom name',`category`
from `message` 
right join `fandom_based_rchats` on `rchat_id`=`chat_id`
right join `fandom` on `fandom_id`=`idfandom`
left join `user` on `user_id` = `iduser`;

-- 50.(18) Показать, к каким форумам, которые основаны на фандомах, относятся статьи
select `date`,`section` as 'Forum section',`forum_name`,`title`,`text` as 'Text of article',`category` as 'Fandom Category',`fandom`.`name` as 'Fandom name'
from `article`
right join `forum` on `forum_id`=`idforum`
right join `fandom` on `fandom_id` = `idfandom`;

-- 51.(19) Показать сообщения, набранные персонажами
select `date`,`character`.`name` as 'Name if character',`life_status`,`description`, `text` as 'Character message'
from `character`
left join `role_message` on `character_id` = `character`.`id`;

-- 52.(20) Показать пользователей, чьи персонажи отправляли сообщения
select `date`,`user`.`name` as 'Username',`gender`,`character`.`name` as 'Char name',`life_status`,`description`,`text` as 'Message from char'
from `user`
left join `character` on `user_id` = `iduser`
left join `role_message` on `character_id` = `character`.`id`;
-- Группировка по разным признакам (Group by) -- 

-- Объединение таблиц (Union) --

-- Выборка с all, any, exists -- 
-- (1) Показать пользователей, кто оставил ссылку в событии 
-- Условимся, что в рамках данной работы одно событие - это одна ссылка
select `iduser`,`name`from `user` 
where exists
(select `links` from `event` where `links` is not null 
and
`user_id`=`iduser`);

-- (2) Вывести пользователей, кто писал сообщения, содержащие слово "text"
select `iduser`,`name` from `user` 
where `iduser`= any
(select `user_id` from `message` where `text` like '%text%');

-- (3) Показать все плагины,которые не используют никаких инструментов
select * from `plugin` 
where `idplugin` > all
(select `id` from `tool`);

-- Group_Concat и прочие функции --


-- Сложные многослойные запросы --
