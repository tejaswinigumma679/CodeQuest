create database codequest_db;
use codequest_db;
create table users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    total_xp INT DEFAULT 0,
    player_level INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
create table admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);
create table missions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(30) NOT NULL,
    difficulty VARCHAR(20) NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    xp_reward INT DEFAULT 50,
    created_by INT NOT NULL,

    FOREIGN KEY (created_by)
        REFERENCES admins(id)
);
create table mission_submissions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    mission_id INT NOT NULL,
    answer VARCHAR(255) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id),

    FOREIGN KEY (mission_id)
        REFERENCES missions(id),

    UNIQUE (user_id, mission_id)
);
show tables;
select id, username, email, total_xp, player_level from users;
insert into admins (username, password)
values ('Tejaswini', '210000:e6CWbX2IE0560APhC0pFdg==:J18ntxmiYJjnMoSNa/6okiv655t+bbXUKJToOQ7WzzI=');
select id, username from admins;
select * from missions;
select id, title, category, difficulty, xp_reward
from missions
order by id desc;
select * from missions
where title = 'Delete Test Mission';
show index from mission_submissions;
select * from mission_submissions;
select username, total_xp, player_level
from users;
alter table users
add column theme_preference VARCHAR(10)
default 'dark';
select id, username, email, theme_preference
from users;
select username, theme_preference
from users;
select id, username, email
from users;
alter table admins
add column email varchar(100) unique null,
add column created_at timestamp default current_timestamp,
add column theme_preference varchar(10) not null default 'dark';
desc admins;
select * from admins;
update admins
set email = 'admin@gmail.com'
where id = 1;
update admins
set email = 'tejaswini@gmail.com'
where id = 2;