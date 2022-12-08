USE nba_game_scores;



-- A procedure for creating a user tuple.
-- Args:
--     account_name VARCHAR(64): A unique user account name.
--     password VARCHAR(64): User password. Must be at least 8 characters long.
-- Returns 1 if successful, else throws an error.
DROP PROCEDURE IF EXISTS create_user;

DELIMITER //
CREATE PROCEDURE create_user(IN new_account_name VARCHAR(64), IN new_password VARCHAR(64))
this_proc:BEGIN
	-- Validates required args are present.
	IF new_account_name IS NULL OR new_password IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;

	INSERT INTO user (account_name, password)
    VALUES (new_account_name, new_password);
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM user;
CALL create_user('eastern_watcher', '12345678');
CALL create_user('western_watcher', '12345678');
CALL create_user('watching_east', '12345678');



-- A procedure for updating a user tuple.
DROP PROCEDURE IF EXISTS update_user;

DELIMITER //
CREATE PROCEDURE update_user(IN existing_account_name VARCHAR(64), IN new_account_name VARCHAR(64), IN new_password VARCHAR(64))
this_proc:BEGIN
	IF existing_account_name IS NULL OR new_account_name IS NULL OR new_password IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates new account name is either unchanged or some unique new value.
	ELSEIF existing_account_name != new_account_name AND EXISTS (SELECT * FROM user WHERE account_name = new_account_name)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New account name must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE user
    SET account_name = new_account_name, password = new_password
    WHERE account_name = existing_account_name;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM user;
CALL update_user('eastern_watcher', 'eastern_watcher', '12345679');
CALL update_user('western_watcher', 'western_watcher_2', '12345678');



-- A procedure for deleting a user tuple.
DROP PROCEDURE IF EXISTS delete_user;

DELIMITER //
CREATE PROCEDURE delete_user(IN existing_account_name VARCHAR(64))
this_proc:BEGIN
	IF existing_account_name IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates the account name is in the database.
	ELSEIF NOT EXISTS (SELECT * FROM user WHERE account_name = existing_account_name)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account name non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM user
    WHERE account_name = existing_account_name;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM user;
CALL delete_user('western_watcher_2');



-- A trigger that updates plays table when a game tuple is inserted.
DROP TRIGGER IF EXISTS plays_after_plays_in_insert;

DELIMITER //

CREATE TRIGGER plays_after_plays_in_insert AFTER INSERT
ON plays_in
FOR EACH ROW
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE temp_player_id INT DEFAULT 0;
	DECLARE players_in_game_cursor CURSOR FOR (SELECT player_id FROM plays_for WHERE team_name = NEW.team_name);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    OPEN players_in_game_cursor;
    
    iterate_players: LOOP
    FETCH players_in_game_cursor INTO temp_player_id;
	IF finished = 1 THEN 
		LEAVE iterate_players;
	END IF;
	INSERT INTO plays(date, stadium, player_id) VALUE (NEW.date, NEW.stadium, temp_player_id);
    END LOOP iterate_players;
    
    CLOSE players_in_game_cursor;
   
END //

DELIMITER ;

-- SELECT * FROM plays;



-- A procedure for creating a game tuple. Note that both home team and away team are needed during creation, though they are not stored in 'game' table.
-- Args:
--     date DATE: Game date.
--     stadium VARCHAR(64): Game stadium.
--     home_team_score INT: Home team final score.
--     away_team_score INT: Away team final score.
-- Returns 1 if successful, else throws an error.
DROP PROCEDURE IF EXISTS create_game;

DELIMITER //
CREATE PROCEDURE create_game(
    IN date DATE,
    IN home_team_name VARCHAR(32),
    IN away_team_name VARCHAR(32),
    IN home_team_score INT,
    IN away_team_score INT
)
this_proc:BEGIN
	DECLARE game_stadium VARCHAR(64);

	-- Validates required args are present.
	IF date IS NULL OR home_team_name IS NULL OR away_team_name IS NULL OR home_team_score IS NULL OR away_team_score IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;
    
    -- Validates the stadium name used.
    IF NOT EXISTS (SELECT * FROM team WHERE team_name IN (home_team_name, away_team_name))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 team name does not match any known teams.';
    LEAVE this_proc;
    END IF;
    
    SET game_stadium = (SELECT home_stadium FROM team WHERE team_name = home_team_name);

    INSERT INTO game (date, stadium, home_team_score, away_team_score)
    VALUES (date, game_stadium, home_team_score, away_team_score);
    
    INSERT INTO plays_in (date, stadium, team_name)
    VALUES (date, game_stadium, home_team_name);

    INSERT INTO plays_in (date, stadium, team_name)
    VALUES (date, game_stadium, away_team_name);

    SELECT 1;
END//

DELIMITER ;

CALL create_game('2019-12-25', 'Celtics', 'Lakers', 100, 100);
CALL create_game('2020-12-25', 'Celtics', 'Lakers', 100, 98);
CALL create_game('2021-12-25', 'Celtics', 'Lakers', 120, 88);
CALL create_game('2022-12-25', 'Celtics', 'Bulls', 77, 88);
-- SELECT * FROM plays;
-- SELECT * FROM game;
-- SELECT * FROM plays_in;
-- DELETE FROM game WHERE date < '2022-12-31';
-- DELETE FROM plays_in WHERE date < '2022-12-31';



-- A procedure for updating a game tuple.
DROP PROCEDURE IF EXISTS update_game;

DELIMITER //
CREATE PROCEDURE update_game(
	IN existing_date DATE,
    IN existing_stadium VARCHAR(64),
	IN new_date DATE,
    IN new_stadium VARCHAR(64),
    IN new_home_team_score INT,
    IN new_away_team_score INT
)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR new_date IS NULL OR new_stadium IS NULL OR new_home_team_score IS NULL OR new_away_team_score IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates new PK is either unchanged or some unique new value.
	ELSEIF (existing_date != new_date OR existing_stadium != new_stadium) AND EXISTS (SELECT * FROM game WHERE date = new_date AND stadium = new_stadium)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New date and stadium value pair must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE game
    SET date = new_date, stadium = new_stadium, home_team_score = new_home_team_score, away_team_score = new_away_team_score
    WHERE date = existing_date AND stadium = existing_stadium;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM game;
CALL update_game('2020-12-25', 'TD Garden', '2020-12-25', 'TD Garden', 110, 80);



-- A procedure for deleting a game tuple.
DROP PROCEDURE IF EXISTS delete_game;

DELIMITER //
CREATE PROCEDURE delete_game(IN existing_date DATE, IN existing_stadium VARCHAR(64))
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates the primary keys are in the database.
	ELSEIF NOT EXISTS (SELECT * FROM game WHERE date = existing_date AND stadium = existing_stadium)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date-stadium value pair non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM game
    WHERE date = existing_date AND stadium = existing_stadium;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM game;
CALL delete_game('2019-12-25', 'TD Garden');



-- A procedure for creating a player_game_stat tuple.
-- Args:
--     date DATE: Game date.
--     stadium VARCHAR(64): Game stadium.
-- 	   player_id INT: ID of the player this tuple records.
-- 	   total_score INT: Player's total points scored at the game.
--     minutes_played INT: Player's total minutes played at the game.
--     two_total INT: Player's total number of two-pointers attempted at the game.
--     two_goal INT: Player's total number of two-pointers scored at the game.
--     three_total INT: Player's total number of three-pointers attempted at the game.
--     three_goal INT: Player's total number of three-pointers scored at the game.
--     free_throw_total: Player's total number of free throws attempted at the game.
--     free_throw_goal INT: Player's total number of free throws scored at the game.
--     rebounds INT: Player's number of rebounds captured at the game.
--     assists INT: Player's assists made at the game.
--     blocks INT: Player's blocks made at the game.
--     steals INT: Player's steals made at the game.
-- Returns 1 if successful, else throws an error.
DROP PROCEDURE IF EXISTS create_player_game_stat;

DELIMITER //
CREATE PROCEDURE create_player_game_stat(
    date DATE,
    stadium VARCHAR(64),
    player_id INT,
    minutes_played INT,
    two_total INT,
    two_goal INT,
    three_total INT,
    three_goal INT,
    free_throw_total INT,
    free_throw_goal INT,
    rebounds INT,
    assists INT,
    blocks INT,
    steals INT
)
this_proc:BEGIN
	-- Validates required args are present.
	IF date IS NULL OR stadium IS NULL OR player_id IS NULL OR minutes_played IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;

    -- Validates the game PK used.
    IF NOT EXISTS (SELECT * FROM game WHERE stadium = stadium AND date = date)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stadium and date do not match any known game.';
    LEAVE this_proc;
    END IF;

    -- Validates the player PK used.
    IF NOT EXISTS (SELECT * FROM player WHERE player_id = player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player ID does not match any known players.';
    LEAVE this_proc;
    END IF;

    INSERT INTO player_game_stat (date, stadium, player_id, minutes_played, two_total, two_goal, three_total, three_goal, free_throw_total, free_throw_goal, rebounds, assists, blocks, steals)
    VALUES (date, stadium, player_id, minutes_played, two_total, two_goal, three_total, three_goal, free_throw_total, free_throw_goal, rebounds, assists, blocks, steals);

    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM player_game_stat;
CALL create_player_game_stat('2020-12-25', 'TD Garden', 1, 40, 15, 7, 3, 1, 1, 1, 5, 5, 2, 0);
CALL create_player_game_stat('2020-12-25', 'TD Garden', 2, 39, 13, 6, 0, 0, 3, 3, 0, 0, 0, 0);
CALL create_player_game_stat('2020-12-25', 'TD Garden', 4, 42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- SELECT * FROM player_game_stat;



-- A procedure for updating a player_game_stat tuple.
DROP PROCEDURE IF EXISTS update_player_game_stat;

DELIMITER //
CREATE PROCEDURE update_player_game_stat(
	existing_date DATE,
    existing_stadium VARCHAR(64),
    existing_player_id INT,
    new_date DATE,
    new_stadium VARCHAR(64),
    new_player_id INT,
    new_minutes_played INT,
    new_two_total INT,
    new_two_goal INT,
    new_three_total INT,
    new_three_goal INT,
    new_free_throw_total INT,
    new_free_throw_goal INT,
    new_rebounds INT,
    new_assists INT,
    new_blocks INT,
    new_steals INT
)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR existing_player_id IS NULL OR new_date IS NULL OR new_stadium IS NULL OR new_player_id IS NULL
    OR new_minutes_played IS NULL OR new_two_total IS NULL OR new_two_goal IS NULL OR new_three_total IS NULL OR new_free_throw_total IS NULL OR new_free_throw_goal IS NULL
    OR new_rebounds IS NULL OR new_assists IS NULL OR new_blocks IS NULL OR new_steals IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    
	-- Validates new PK is either unchanged or some unique new value.
	ELSEIF (existing_date != new_date OR existing_stadium != new_stadium OR existing_player_id != new_player_id)
    AND EXISTS (SELECT * FROM player_game_stat WHERE date = new_date AND stadium = new_stadium AND player_id = new_player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New PK value pair must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE player_game_stat
    SET date = new_date, stadium = new_stadium, player_id = new_player_id, minutes_played = new_minutes_played, two_total = new_two_total,
	two_goal = new_two_goal, three_total = new_three_total, three_goal = new_three_goal, free_throw_total = new_free_throw_total, free_throw_goal = new_free_throw_goal,
	rebounds = new_rebounds, assists = new_assists, blocks = new_blocks, steals = new_steals
    WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM player_game_stat;
CALL update_player_game_stat('2020-12-25', 'TD Garden', 4, '2020-12-25', 'TD Garden', 4, 40, 15, 7, 3, 3, 1, 1, 5, 5, 2, 0);



-- A procedure for deleting a player_game_stat tuple.
DROP PROCEDURE IF EXISTS delete_player_game_stat;

DELIMITER //
CREATE PROCEDURE delete_player_game_stat(IN existing_date DATE, IN existing_stadium VARCHAR(64), IN existing_player_id INT)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR existing_player_id IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    
	-- Validates the primary keys are in the database.
	ELSEIF NOT EXISTS (SELECT * FROM player_game_stat WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PK value pair non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM player_game_stat
    WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id;
    
    SELECT 1;
END//

DELIMITER ;

-- SELECT * FROM player_game_stat;
CALL delete_player_game_stat('2020-12-25', 'TD Garden', 2);



-- A procedure that list all games played by a particular team
DROP PROCEDURE IF EXISTS all_games;

DELIMITER //

CREATE PROCEDURE all_games(input_team_name VARCHAR(32))
BEGIN
	SELECT *
    FROM game
    WHERE (date, stadium) IN (
		SELECT date, stadium
		FROM plays_in AS pi
		WHERE pi.team_name = input_team_name);
END//

DELIMITER ;

CALL all_games('Celtics');



-- A procedure that list game average stats of a player.
DROP PROCEDURE IF EXISTS player_game_avg;

DELIMITER //

CREATE PROCEDURE player_game_avg(input_player_id INT)
BEGIN
	SELECT AVG(minutes_played), AVG(two_total), AVG(two_goal), AVG(three_total)
    , AVG(three_goal), AVG(free_throw_total), AVG(free_throw_goal), AVG(rebounds)
    , AVG(assists), AVG(blocks), AVG(steals)
    FROM player_game_stat
    WHERE player_id = input_player_id;
END//

DELIMITER ;

CALL player_game_avg(1);



-- A function that identifies the current team of a player.
DROP FUNCTION IF EXISTS current_team;

DELIMITER //

CREATE FUNCTION current_team(input_player_id INT)
RETURNS VARCHAR(32)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE current_team VARCHAR(32);
    
    SELECT team_name
    INTO current_team
    FROM plays_for
    WHERE player_id  = input_player_id;

    RETURN current_team;
END//

DELIMITER ;

SELECT current_team(1);
SELECT current_team(4);



-- A function that identifies the number of games played bv a team.
DROP FUNCTION IF EXISTS games_by_team;

DELIMITER //

CREATE FUNCTION games_by_team(input_team_name VARCHAR(32))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE games_count INT;
    
    SELECT COUNT(*)
    INTO games_count
    FROM plays_in
    WHERE team_name = input_team_name;

    RETURN games_count;
END//

DELIMITER ;

SELECT games_by_team('Celtics');
SELECT games_by_team('Lakers');



-- A function that identifies the current head coach name of a team.
DROP FUNCTION IF EXISTS team_head_coach;

DELIMITER //

CREATE FUNCTION team_head_coach(input_team_name VARCHAR(32))
RETURNS VARCHAR(64)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE head_coach_name VARCHAR(64);
    
    SELECT coach_id
    INTO head_coach_name
    FROM has AS h
    NATURAL JOIN coach AS c
    WHERE h.team_name = input_team_name
    AND h.end_date IS NULL;

    RETURN head_coach_name;
END//

DELIMITER ;

SELECT team_head_coach('Celtics');
SELECT team_head_coach('Lakers');


-- A function that identifies the conference and current conference standing of a team.
DROP FUNCTION IF EXISTS team_conf_standing;

DELIMITER //
CREATE FUNCTION team_conf_standing(input_team_name VARCHAR(32))
RETURNS VARCHAR(64)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE conf_standing INT;
	DECLARE conf_div VARCHAR(64);

    SELECT conference_standing
    INTO conf_standing
    FROM team
    WHERE team_name = input_team_name;

    SELECT conference
    INTO conf_div
    FROM team
    WHERE team_name = input_team_name;

    RETURN CONCAT(conf_div, ' ', conf_standing);
END//

DELIMITER ;

SELECT team_conf_standing('Celtics');
SELECT team_conf_standing('Lakers');