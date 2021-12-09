CREATE TABLE IF NOT EXISTS PLAYERS (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    NAME VARCHAR(24) NOT NULL,
    PASSWORD VARBINARY(61) NOT NULL,
    SEX BOOLEAN NOT NULL,
    AGE TINYINT UNSIGNED NOT NULL,
    MONEY INT NOT NULL DEFAULT 0,
    HEALTH FLOAT NOT NULL DEFAULT 100.0,
    ARMOUR FLOAT NOT NULL DEFAULT 0.0,
    HUNGER FLOAT NOT NULL DEFAULT 0.0,
    THIRST FLOAT NOT NULL DEFAULT 0.0,
    SKIN SMALLINT UNSIGNED NOT NULL,
    POS_X FLOAT NOT NULL,
    POS_Y FLOAT NOT NULL,
    POS_Z FLOAT NOT NULL,
    ANGLE FLOAT NOT NULL,
    VW INT NOT NULL DEFAULT 0,
    INTERIOR TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PHONE_NUMBER INT UNSIGNED NOT NULL DEFAULT 0,

    ADMIN TINYINT UNSIGNED NOT NULL DEFAULT 0,
    SETTINGS INT UNSIGNED NOT NULL DEFAULT 0b0,

    CURRENT_CONNECTION INTEGER UNSIGNED NOT NULL,
    PLAYED_TIME INTEGER UNSIGNED NOT NULL DEFAULT 0
);

UPDATE `PLAYERS` SET CURRENT_CONNECTION = 0;

CREATE TABLE IF NOT EXISTS CONNECTION_LOGS (
	ACCOUNT_ID INT UNSIGNED NOT NULL,
	IP_ADDRESS VARCHAR(16) NOT NULL,
	DATE DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	FOREIGN KEY(ACCOUNT_ID) REFERENCES PLAYERS(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PLAYER_VEHICLES (
    VEHICLE_ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    OWNER_ID INT UNSIGNED NOT NULL,
    MODEL SMALLINT NOT NULL,
    HEALTH FLOAT NOT NULL DEFAULT 1000.0,
    FUEL FLOAT NOT NULL DEFAULT 0.0,
    PANELS_STATUS INT NOT NULL DEFAULT 0,
    DOORS_STATUS INT NOT NULL DEFAULT 0,
    LIGHTS_STATUS INT NOT NULL DEFAULT 0,
    TIRES_STATUS INT NOT NULL DEFAULT 0,
    COLOR_ONE INT NOT NULL,
    COLOR_TWO INT NOT NULL,
    PAINTJOB INT NOT NULL DEFAULT 0,
    POS_X FLOAT NOT NULL,
    POS_Y FLOAT NOT NULL,
    POS_Z FLOAT NOT NULL,
    ANGLE FLOAT NOT NULL,
    INTERIOR INT NOT NULL DEFAULT 0,
    VW INT NOT NULL DEFAULT 0,
    COMPONENTS VARCHAR(69) NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0,0',
    PARAMS TINYINT NOT NULL DEFAULT 0b000000,

    FOREIGN KEY(OWNER_ID) REFERENCES PLAYERS(ID) ON DELETE CASCADE
);