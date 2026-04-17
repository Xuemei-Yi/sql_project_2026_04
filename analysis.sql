--1.平台总体运营总览
SELECT
   COUNT(DISTINCT u.user_id) AS 总用户数,
   COUNT(DISTINCT o.order_id) AS 总订单数,
   SUM(o.payment) AS 总GMV,
   ROUND(AVG(o.payment),2) AS 客单价
FROM users u LEFT JOIN orders o on u.user_id=o.user_id;

--2.用户行为分布统计
SELECT 
   behavior_type,
   COUNT(*) AS 行为总次数,
   COUNT(DISTINCT user_id)AS 参与用户数
FROM user_behavior
GROUP BY behavior_type
ORDER BY 参与用户数 DESC;
/*注释：
行为总次数→ 看平台热不热闹，用户活跃度高不高
参与用户数→ 看多少人在用这个功能
如果小明一个人加购100次，行为总次数是100，参与用户数却只有1，这显然是很不理想的情况*/


--3.用户转化漏斗（核心指标）
SELECT
  COUNT(DISTINCT CASE WHEN behavior_type="pv" THEN user_id END) AS 浏览用户数, 
  COUNT(DISTINCT CASE WHEN behavior_type IN("cart","fav") THEN user_id END) AS 加购收藏用户数,
  COUNT(DISTINCT CASE WHEN behavior_type="buy" THEN user_id END) AS 购买用户数,
  ROUND(
COUNT(DISTINCT CASE WHEN behavior_type="buy" THEN user_id END)/
COUNT(DISTINCT CASE WHEN behavior_type="pv" THEN user_id END),2) AS 整体转化率 FROM user_behavior;

--4.热销商品top10
SELECT i.item_id,
      i.category_id,
      COUNT(o.order_id) AS 销量,
      SUM(o.payment) AS商品GMV 
      FROM items i LEFT JOIN orders o ON i.item_id=o.item_id GROUP BY i.item_id,i.category_id ORDER BY 销量 DESC LIMIT 10;
    
--5.各城市消费能力排行
SELECT
u.city,
COUNT(DISTINCT u.user_id)AS 城市用户数,
COUNT(o.order_id) AS 城市订单数,
SUM(o.payment) AS 城市GMV,
ROUND(AVG(o.payment),2) AS 城市客单价
FROM users u JOIN orders o ON u.user_id=o.user_id
GROUP BY u.city
ORDER BY 城市GMV DESC;

--6.用户复购率分析
SELECT
COUNT(DISTINCT CASE WHEN 订单数>=2 THEN user_id END) AS 复购用户数,
COUNT(DISTINCT user_id) AS 总购买用户数,
ROUND(
COUNT(DISTINCT CASE WHEN 订单数>=2 THEN user_id END)/
COUNT(DISTINCT user_id),2) AS 复购率
FROM (
  SELECT user_id,COUNT(order_id) AS 订单数
   FROM orders GROUP BY user_id
  ) AS t;

--7.每日订单与GMV趋势
SELECT
DATE(buy_time) AS 日期,
COUNT(order_id) AS 订单数,
SUM(payment) AS 每日GMV,
ROUND(AVG(payment),2) AS 当日客单价
FROM orders
GROUP BY DATE(buy_time)
ORDER BY 日期;
