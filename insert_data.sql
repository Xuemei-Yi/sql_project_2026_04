--插入160条用户数据
insert into users values(1,22,"北京"),(2,25,"上海"),(3,23,"广州"),(4,24,"深圳"),(5,26,"杭州"),(6,21,"成 都"),(7,29,"重庆"),(8,27,"南京"),(9,30,"武汉"),(10,24,"西安");

insert into users select user_id+10,age,city from users;

insert into users select user_id+20,age,city from users;

insert into users select user_id+40,age,city from users;

insert into users select user_id+80,age,city from users limit20;

--插入40条商品数据
INSERT INTO items VALUES(1,101,99.9),(2,101,199),(3,102,59),(4,102,129),(5,103,79);

INSERT INTO items SELECT item_id+5, category_id, price+10 FROM items;

INSERT INTO items SELECT item_id+10, category_id, price+5 FROM items;

INSERT INTO items SELECT item_id+20, category_id, price+15 FROM items;


--插入600条订单数据
INSERT INTO orders (user_id, item_id, buy_time, payment)
SELECT
FLOOR(1+RAND()*160),
FLOOR(1+RAND()*40),
NOW() - INTERVAL FLOOR(RAND()*30) DAY,
ROUND(50+RAND()*200,2)
FROM items a JOIN items b LIMIT 600;


--插入1600条用户行为数据
insert into user_behavior(user_id,item_id,behavior_type,ts)
select
(1+floor(rand()*160)),
(1+floor(rand()*40)),
elt(floor(1+rand()*4),"pv","cart","fav","buy"),
now() - interval 30 day from items a join items b limit 1600;
