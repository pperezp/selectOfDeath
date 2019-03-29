use awto;

-- Primera versión
DELIMITER $$
CREATE PROCEDURE selectDeLaMuerte(limitNumber INT)
BEGIN 
	DECLARE nombreTabla VARCHAR(100);
    DECLARE query TEXT;
    
    DECLARE fin INTEGER DEFAULT 0;

	DECLARE tabla_cursor CURSOR FOR
		SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema='awto' LIMIT limitNumber;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
    
    OPEN tabla_cursor;
    
    get_tablas: LOOP
		FETCH tabla_cursor INTO nombreTabla;
        
		IF fin = 1 THEN
			LEAVE get_tablas;
		END IF;
        
        IF query IS NULL THEN
			SET query = CONCAT('SELECT * FROM ', nombreTabla);
		ELSE
			SET query = CONCAT(query, ', ', nombreTabla);
        END IF;
		
    END LOOP get_tablas;
    
    SELECT query;
    
    PREPARE statement FROM query; 
	EXECUTE statement; 
	DEALLOCATE PREPARE statement; 
    
    CLOSE tabla_cursor;
END$$
DELIMITER ;



-- CALL selectDeLaMuerte(3);
-- DROP PROCEDURE selectDeLaMuerte;





















-- Segunda versión
DELIMITER $$
CREATE PROCEDURE selectOfDeath(databaseName VARCHAR(100), limitNumber INT)
BEGIN 
	DECLARE tableName 	VARCHAR(100);
    DECLARE query 		TEXT;
    DECLARE endLoop 	INTEGER DEFAULT 0;

	DECLARE tableCursor CURSOR FOR
		SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = databaseName 
        LIMIT limitNumber;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endLoop = 1;
    
    OPEN tableCursor;
    mainLoop: LOOP
		FETCH tableCursor INTO tableName;
        
		IF endLoop = 1 THEN
			LEAVE mainLoop;
		END IF;
        
        SET query = CONCAT('SELECT * FROM ', tableName);
        
        PREPARE statement FROM query; 
		EXECUTE statement; 
		DEALLOCATE PREPARE statement; 
		
    END LOOP mainLoop;
    CLOSE tableCursor;
END$$
DELIMITER ; 

-- CALL selectOfDeath('awto', 3);
-- DROP PROCEDURE selectOfDeath;









