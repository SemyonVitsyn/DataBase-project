#  Моделирование базы данных для системы бронирования отелей

В данном проекте я моделирую базу данных для сервиса бронирования отелей.

**Общие сведения:**
    
 1) В hotel хранится информация об отеле (название, адрес, рейтинг).

 2) В room хранится информация о посуточной цене за номер, о его классе (одноместный, люкс и т.д.) и о том, в каком отеле он находится. 

 3) В booking хранится основная информация о бронировании.
    
 4) В guest - имя, фамилия, электронная почта и телефон пользователя.
    
 5) В review находятся отзывы пользователей на их комнату и отель в целом, на основании которых вычисляются оценки.

**2 таблицы являются версионными:**

 1) Booking версионируется в SCD4 (предыдущие версии хранятся в booking_logs). Выбрал это формат, так как мы хотим иметь быстрый доступ к актуальной информации о бронировании, однако нам так же важны предыдущие состояния бронирования для анализа и сохранения контента.

 2) Room версионируется в SCD2, т.к. нам важно знать историю изменения цен, но изменения будут не очень частыми и скорее сезонными, а потому это оптимальный формат.

БД находится в 3НФ.

Так как я занимаюсь лишь бронированием, то в таблице с комнатами хранятся не конкретные номера комната, а сущности в виде класса этой комнаты(требования предполагается описывать в room_type.description), отеля и их цены.

Типы комнат и статусы бронирований вынесены в отдельные таблицы для удобства масштабирования.

## Концептуальная модель
<img src="./pic/conceptual_model.png" width="500"/>  

## Логическая модель
<img src="./pic/logic_model.png" width="700"/>  

## Физическая модель

#### hotel
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| hotel_id | hotel ID | SERIAL | NOT NULL PRIMARY KEY |
| hotel_name |  hotel name | VARCHAR(255) | NOT NULL |
| country | country of the hotel location | VARCHAR(50) | NOT NULL |
| city | city of the hotel location | VARCHAR(50) | NOT NULL |
| address | address of the hotel | VARCHAR(100) | NOT NULL |
| rating | hotel`s rating in system | NUMERIC | $1 \leq rating \leq 5$ |

#### room
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| room_id | room ID | SERIAL | NOT NULL PRIMARY KEY |
| hotel_id | ID of the hotel where this room is located | INTEGER | NOT NULL FOREIGN KEY |
| type | room`s type (single, premium, etc.) | INTEGER | NOT NULL FOREIGN KEY |
| rating | room's rating in system | NUMERIC | $1 \leq rating \leq 5$ |
| cost | daily price for this room (USD) | NUMERIC | NOT NULL |
| valid_from | from what period is the information relevant | TIMESTAMP | NOT NULL |
| valid_to | up to what period is the information relevant | TIMESTAMP | NOT NULL |

#### booking
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| booking_id | booking ID | SERIAL | NOT NULL PRIMARY KEY |
| guest_id | guest`s ID | INTEGER | NOT NULL FOREIGN KEY |
| room_id | booked room ID | INTEGER | NOT NULL FOREIGN KEY |
| status | booking status | INTEGER | NOT NULL FOREIGN KEY |
| check_in | booking check-in time | TIMESTAMP | NOT NULL |
| check_out | booking check-out time | TIMESTAMP | NOT NULL |

#### guest
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| guest_id | guest ID | SERIAL | NOT NULL PRIMARY KEY |
| first_name | guest first name | VARCHAR(20) | NOT NULL |
| last_name | guest last name | VARCHAR(20) | NOT NULL |
| email | guest email | VARCHAR(50) | |
| phone | guest phone | VARCHAR(20) | NOT NULL |

#### review
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| review_id | review ID | SERIAL | NOT NULL PRIMARY KEY |
| booking_id |  ID of the booking for which the review is being left | INTEGER | NOT NULL FOREIGN KEY |
| comment | guest`s comment | TEXT | |
| hotel_score | guest`s score for hotel | INTEGER | $1 \leq score \leq 5$ |
| room_score | guest`s score for room | INTEGER | $1 \leq score \leq 5$ |

#### booking_logs
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| change_id | change ID | SERIAL | NOT NULL PRIMARY KEY |
| change_time | timestamp of change | TIMESTAMP | NOT NULL |
| booking_id |  ID of the relevant actual booking that was modified | INTEGER | NOT NULL FOREIGN KEY |
| guest_id | ID of the logged guest | INTEGER | NOT NULL FOREIGN KEY |
| room_id | ID of the logged room | INTEGER | NOT NULL FOREIGN KEY |
| status | ID of the logged status | INTEGER | NOT NULL FOREIGN KEY |
| check_in | logged booking check-in time | TIMESTAMP | NOT NULL |
| check_out | logged booking check-out time | TIMESTAMP | NOT NULL |  

#### room_type
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| type_id | type ID | SERIAL | NOT NULL PRIMARY KEY |
| description | room description | TEXT | |

#### status
| Field name | Description | Data type | Restrictions |
|---|---|---|---| 
| status_id | status ID | SERIAL | NOT NULL PRIMARY KEY |
| description | desription of booking status | VARCHAR(255) | |