# The Hood
Gang-based RPG gamemode for SA-MP  

## Set-up  
The database and configuration are initialized automatically. Due to an error in MySQL plugin, execute this query in your database manager:
```sql
DELIMITER $$

CREATE PROCEDURE GENERATE_PHONE_NUMBER(OUT NUMBER INT)
BEGIN
    DECLARE TEMP_NUMBER INT DEFAULT 0;
    
    WHILE TEMP_NUMBER = 0 DO
        SELECT FLOOR((RAND() * (99999999 - 10000000 + 1)) + 10000000) INTO TEMP_NUMBER;
        SELECT 0 INTO TEMP_NUMBER WHERE EXISTS(SELECT NULL FROM `PLAYERS` WHERE `PHONE_NUMBER` = TEMP_NUMBER LIMIT 1);
    END WHILE;
    
    SELECT TEMP_NUMBER INTO NUMBER;
END$$

DELIMITER ;
```