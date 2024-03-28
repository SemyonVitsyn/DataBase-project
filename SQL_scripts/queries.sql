-- Рейтинг отелей в Испании

SELECT 
    hotel_name as hotel, 
    rating
FROM hotel
WHERE country = 'Spain'
ORDER BY rating DESC

-- Отель с максимальной посуточная ценой за номер

SELECT 
    h.hotel_name AS hotel,
    r.cost as cost 
FROM room r
JOIN hotel h ON r.hotel_id = h.hotel_id 
ORDER BY r.cost DESC
LIMIT 1

-- В каком количество отзывов на номер встретилось слово good

SELECT 
    room.room_id AS room, 
    COUNT(*) as good_count
FROM room
JOIN booking b ON b.room_id = room.room_id
JOIN review ON b.booking_id = review.booking_id
WHERE LOWER(review.comment) LIKE '%good%'
GROUP BY room.room_id
ORDER BY good_count DESC 

-- Сколько изменений было для бронирования комнаты

SELECT DISTINCT 
	r.room_id AS room, 
	COUNT(*) OVER (PARTITION BY r.room_id) AS changes
FROM room r
JOIN booking_logs l ON l.room_id = r.room_id
ORDER BY changes, r.room_id

-- Самый активный guest

SELECT 
    g.first_name, 
    g.last_name, 
    COUNT(*) AS count
FROM guest g
JOIN booking b ON b.guest_id = g.guest_id
GROUP BY g.guest_id, g.first_name, g.last_name
ORDER BY count DESC

-- Количество завершенных бронирований

SELECT 
    COUNT(*) as count
FROM booking b
JOIN status s ON b.status = s.status_id
WHERE s.description = 'Complete'

-- В каких отелях есть комната с телевизором

SELECT 
    hotel_name AS hotel
FROM hotel h
WHERE ANY (
    SELECT r.room_id
    FROM room r
    JOIN room_type t ON r.type = t.type_id
    WHERE h.hotel_id = r.hotel_id AND t.description LIKE '%TV%'
)
ORDER BY hotel_name 

-- Отели, где даже самый плохой номер имеет рейтинг не менее 4.3

SELECT 
    h.hotel_name AS hotel, 
    MIN(r.rating) AS min
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name
HAVING MIN(r.rating) >= 4.3
ORDER BY min DESC, hotel

-- Люди, которые не оставляли отзывы c оценкой ниже 4

SELECT 
    first_name, 
    last_name
FROM guest
WHERE guest_id IN (
    SELECT b.guest_id
    FROM booking b
    JOIN review r ON b.booking_id = r.booking_id
    GROUP BY b.guest_id
    HAVING min(r.hotel_score) >= 4 AND min(r.room_score) >= 4
)
ORDER BY last_name, first_name

-- Популярность типа комнат

SELECT 
    COUNT(*) as count,
    description
FROM room_type t
JOIN room r ON r.type = t.type_id
JOIN booking b ON b.room_id = r.room_id
GROUP BY t.type_id, t.description
ORDER BY count DESC