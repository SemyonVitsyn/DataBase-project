CREATE TABLE IF NOT EXISTS "hotel"
(
    hotel_id    SERIAL       NOT NULL PRIMARY KEY,
    hotel_name  VARCHAR(255) NOT NULL,
    country     VARCHAR(50)  NOT NULL,
    city        VARCHAR(50)  NOT NULL,
    address     VARCHAR(100) NOT NULL,
    rating      NUMERIC,

    CHECK (rating IS NULL OR rating BETWEEN 1 AND 5)
);

CREATE TABLE IF NOT EXISTS "room_type"
(
    type_id     SERIAL NOT NULL PRIMARY KEY,
    description TEXT
);

CREATE TABLE IF NOT EXISTS "room"
(
    room_id     SERIAL    NOT NULL PRIMARY KEY,
    hotel_id    INTEGER   NOT NULL,
    type        INTEGER   NOT NULL,
    rating      NUMERIC,
    cost        NUMERIC   NOT NULL,
    valid_from  TIMESTAMP NOT NULL DEFAULT now(),
    valid_to    TIMESTAMP NOT NULL DEFAULT '9999-12-31 23:59:59',

    CHECK (rating IS NULL OR rating BETWEEN 1 AND 5),
    CHECK (valid_from < valid_to),
    CONSTRAINT fk_hotel FOREIGN KEY (hotel_id)
                REFERENCES hotel(hotel_id),
    CONSTRAINT fk_type FOREIGN KEY (type)
                REFERENCES room_type(type_id)
);

CREATE TABLE IF NOT EXISTS "status"
(
    status_id   SERIAL NOT NULL PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS "guest"
(
    guest_id    SERIAL      NOT NULL PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(20) NOT NULL,
    email       VARCHAR(50),
    phone       VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS "booking"
(
    booking_id  SERIAL    NOT NULL PRIMARY KEY,
    guest_id    INTEGER   NOT NULL,
    room_id     INTEGER   NOT NULL,
    status      INTEGER   NOT NULL,
    check_in    TIMESTAMP NOT NULL,
    check_out   TIMESTAMP NOT NULL,

    CHECK (check_in < check_out),
    CONSTRAINT fk_guest FOREIGN KEY (guest_id)
                REFERENCES guest(guest_id),
    CONSTRAINT fk_room FOREIGN KEY (room_id)
                REFERENCES room(room_id),
    CONSTRAINT fk_status FOREIGN KEY (status)
                REFERENCES status(status_id)
);

CREATE TABLE IF NOT EXISTS "review"
(
    review_id   SERIAL  NOT NULL PRIMARY KEY,
    booking_id  INTEGER NOT NULL,
    comment     TEXT,
    hotel_score INTEGER,
    room_score  INTEGER,

    CHECK (hotel_score IS NULL OR hotel_score BETWEEN 1 AND 5),
    CHECK (room_score IS NULL OR room_score BETWEEN 1 AND 5),
    CONSTRAINT fk_booking FOREIGN KEY (booking_id)
                REFERENCES booking(booking_id)
);

CREATE TABLE IF NOT EXISTS "booking_logs"
(
    change_id   SERIAL    NOT NULL PRIMARY KEY,
    change_time TIMESTAMP NOT NULL DEFAULT now(),
    booking_id  INTEGER   NOT NULL,
    guest_id    INTEGER   NOT NULL,
    room_id     INTEGER   NOT NULL,
    status      INTEGER   NOT NULL,
    check_in    TIMESTAMP NOT NULL,
    check_out   TIMESTAMP NOT NULL,

    CHECK (check_in < check_out),
    CONSTRAINT fk_booking FOREIGN KEY (booking_id)
                REFERENCES booking(booking_id),
    CONSTRAINT fk_guest FOREIGN KEY (guest_id)
                REFERENCES guest(guest_id),
    CONSTRAINT fk_room FOREIGN KEY (room_id)
                REFERENCES room(room_id),
    CONSTRAINT fk_status FOREIGN KEY (status)
                REFERENCES status(status_id)
);