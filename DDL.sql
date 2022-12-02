DROP DATABASE IF EXISTS nba_game_scores;
CREATE DATABASE IF NOT EXISTS nba_game_scores;
USE nba_game_scores;

CREATE TABLE user
(
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    account_name VARCHAR(64) NOT NULL,
    password VARCHAR(64) NOT NULL
);

CREATE TABLE team
(
	team_name VARCHAR(32) PRIMARY KEY,
    home_stadium VARCHAR(64) NOT NULL,
    conference VARCHAR(16) NOT NULL,
    conference_standing INT NOT NULL
);

CREATE TABLE coach
(
	coach_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    dob DATE
);

CREATE TABLE game
(
	game_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    stadium VARCHAR(64) NOT NULL,
    home_team VARCHAR(32) NOT NULL,
    home_team_score INT NOT NULL,
    away_team VARCHAR(32) NOT NULL,
    away_team_score INT NOT NULL
);

CREATE TABLE player
(
	player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    dob DATE
);

CREATE TABLE has
(
	team_name VARCHAR(32),  -- Posted from 'team' parent entity.
	coach_id INT,  -- Posted from 'coach' parent entity.
	start_date DATE NOT NULL,
    end_date DATE,

	CONSTRAINT has_pk PRIMARY KEY (team_name, coach_id),
    FOREIGN KEY (team_name) REFERENCES team(team_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES coach(coach_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE watches
(
	user_id INT,  -- Posted from 'user' parent entity.
    team_name VARCHAR(32),  -- Posted from 'team' parent entity.

	CONSTRAINT watches_pk PRIMARY KEY (user_id, team_name),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE plays_in
(
	game_id INT,  -- Posted from 'game' parent entity.
    team_name VARCHAR(32),  -- Posted from 'team' parent entity.

	CONSTRAINT plays_in_pk PRIMARY KEY (game_id, team_name),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name)
    ON UPDATE CASCADE ON DELETE CASCADE	
);

CREATE TABLE plays_for
(
	team_name VARCHAR(32),  -- Posted from 'team' parent entity.
	player_id INT,  -- Posted from 'player' parent entity.
	start_date DATE NOT NULL,
    end_date DATE,
    position VARCHAR(16) NOT NULL,

	CONSTRAINT plays_for_pk PRIMARY KEY (team_name, player_id),
    FOREIGN KEY (team_name) REFERENCES team(team_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE plays
(
	game_id INT,  -- Posted from 'game' parent entity.
	player_id INT,  -- Posted from 'player' parent entity.

	CONSTRAINT plays_pk PRIMARY KEY (game_id, player_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id)
    ON UPDATE CASCADE ON DELETE CASCADE	
);

-- Weak entity owned by both 'game' and 'player' entities.
CREATE TABLE player_game_stat
(
	game_id INT,  -- Posted from 'game' parent entity.
	player_id INT,  -- Posted from 'player' parent entity.
	total_score INT NOT NULL,
    minutes_played INT NOT NULL,
    two_total INT,
    two_goal DOUBLE,
    three_total INT,
    three_goal DOUBLE,
    free_throw_total INT,
    free_throw_goal DOUBLE,
    rebounds INT,
    assists INT,
    blocks INT,
    steals INT,

	CONSTRAINT plays_pk PRIMARY KEY (game_id, player_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id)
    ON UPDATE CASCADE ON DELETE CASCADE	
);




