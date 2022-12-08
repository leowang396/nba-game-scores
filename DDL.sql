DROP DATABASE IF EXISTS nba_game_scores;
CREATE DATABASE IF NOT EXISTS nba_game_scores;
USE nba_game_scores;

CREATE TABLE user
(
    account_name VARCHAR(64) PRIMARY KEY,
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
    date DATE,
    stadium VARCHAR(64),
    home_team_score INT NOT NULL,
    away_team_score INT NOT NULL,
    
    CONSTRAINT game_pk PRIMARY KEY (date, stadium)
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
	account_name VARCHAR(64),  -- Posted from 'user' parent entity.
    team_name VARCHAR(32),  -- Posted from 'team' parent entity.

	CONSTRAINT watches_pk PRIMARY KEY (account_name, team_name),
    FOREIGN KEY (account_name) REFERENCES user(account_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table is necessary, since we might not have historical player data for older games to link game and team.
CREATE TABLE plays_in
(
	date DATE,  -- Posted from 'game' parent entity.
	stadium VARCHAR(64),  -- Posted from 'game' parent entity.
    team_name VARCHAR(32),  -- Posted from 'team' parent entity.

	CONSTRAINT plays_in_pk PRIMARY KEY (date, stadium, team_name),
    FOREIGN KEY (date, stadium) REFERENCES game(date, stadium)
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
	date DATE,  -- Posted from 'game' parent entity.
	stadium VARCHAR(64),  -- Posted from 'game' parent entity.
	player_id INT,  -- Posted from 'player' parent entity.

	CONSTRAINT plays_pk PRIMARY KEY (date, stadium, player_id),
    FOREIGN KEY (date, stadium) REFERENCES game(date, stadium)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id)
    ON UPDATE CASCADE ON DELETE CASCADE	
);

-- Weak entity owned by both 'game' and 'player' entities.
CREATE TABLE player_game_stat
(
	date DATE,  -- Posted from 'game' parent entity.
	stadium VARCHAR(64),  -- Posted from 'game' parent entity.
	player_id INT,  -- Posted from 'player' parent entity.
    minutes_played INT NOT NULL,
    two_total INT,
    two_goal INT,
    three_total INT,
    three_goal INT,
    free_throw_total INT,
    free_throw_goal INT,
    rebounds INT,
    assists INT,
    blocks INT,
    steals INT,

	CONSTRAINT player_game_stat_pk PRIMARY KEY (date, stadium, player_id),
    FOREIGN KEY (date, stadium) REFERENCES game(date, stadium)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id)
    ON UPDATE CASCADE ON DELETE CASCADE	
);

INSERT INTO team (team_name, home_stadium, conference, conference_standing)
VALUES
('Celtics', 'TD Garden', 'East', 1),
('Lakers', 'Crypto.com Arena', 'West', 1),
('Bulls', 'United Center', 'East', 2);

INSERT INTO player (name, dob)
VALUES
('Jayson Tatum', '1990-01-01'),
('Jaylen Brown', '1990-01-01'),
('Blake Griffin', '1990-01-01'),
('LeBron James', '1990-01-01'),
('Lonzo Ball', '1990-01-01');

INSERT INTO plays_for (team_name, player_id, start_date, position)
VALUES
('Celtics', 1, '2020-01-01', 'PF'),
('Celtics', 2, '2020-01-01', 'SF'),
('Celtics', 3, '2020-01-01', 'PF'),
('Lakers', 4, '2020-01-01', 'PF'),
('Bulls', 5, '2020-01-01', 'PG');

INSERT INTO coach (name, dob)
VALUES
('Joe Mazzulla', '1970-01-01'),
('Darvin Ham', '1970-01-01'),
('Billy Donovan', '1970-01-01');

INSERT INTO has (team_name, coach_id, start_date)
VALUES
('Celtics', 1, '2020-01-01'),
('Lakers', 2, '2020-01-01'),
('Bulls', 3, '2020-01-01');

INSERT INTO user (account_name, password)
VALUES
('team_boston!', '12345678'),
('boston_basket_ball_da_best', '12345678'),
('huskies_champion', '12345678');

INSERT INTO watches (account_name, team_name)
VALUES
('team_boston!', 'Celtics'),
('team_boston!', 'Lakers'),
('boston_basket_ball_da_best', 'Celtics');
