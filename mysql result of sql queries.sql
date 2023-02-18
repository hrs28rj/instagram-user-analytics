DROP DATABASE IF EXISTS ig_clone;
CREATE DATABASE ig_clone;
USE ig_clone; 

CREATE TABLE users(id INTEGER AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) UNIQUE NOT NULL, created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE photos(id INTEGER AUTO_INCREMENT PRIMARY KEY, image_url VARCHAR(255) NOT NULL, user_id INTEGER NOT NULL, created_at TIMESTAMP DEFAULT NOW(), FOREIGN KEY(user_id) REFERENCES users(id));

CREATE TABLE comments (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    photo_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    photo_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    PRIMARY KEY(user_id, photo_id)
);

CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE tags (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags (
    photo_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);

INSERT INTO users (username, created_at) VALUES ('Sarthak Das', '2022-02-16 18:22:10.846'), ('Shubhajit Roy', '2017-04-02 17:11:21.417'), ('Avishek Lahiri', '2017-02-21 11:12:32.574');
INSERT INTO photos(image_url, user_id) VALUES ('a', 1), ('b', 2), ('c', 1), ('d', 3), ('e', 2);
INSERT INTO follows(follower_id, followee_id) VALUES (2, 1), (2, 3), (1, 2), (1, 3), (3, 2), (3, 1);
INSERT INTO comments(comment_text, user_id, photo_id) VALUES ('efg', 2, 1), ('pqr', 3, 2), ('xyz', 1, 3);
INSERT INTO likes(user_id,photo_id) VALUES (2, 1), (3, 2), (1, 1), (2, 3);
INSERT INTO tags(tag_name) VALUES ('sunset'), ('photography'), ('sunrise'), ('landscape');
INSERT INTO photo_tags(photo_id, tag_id) VALUES (1, 1), (1, 2), (2, 3), (3, 4);



SHOW DATABASES;
USE ig_clone;

SHOW TABLES;
SELECT COUNT(*) FROM likes;


-- 1.We want ro reward our users who have been around the longest 
-- FINDING the 5 oldest users

SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;

SELECT * 
FROM users
ORDER BY created_at 
LIMIT 5 ;

-- 2. What day of the week do most users register on ?
-- here we need to figure out when to schedule an ad campgain

SELECT 
     DAYNAME(created_at) AS day,
     count(*) as total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- 3.Identify Incative Users (USERS with no photo)
-- We want to target our incative users with an email campaign 
-- find the users who have never posted a photo

SELECT username
FROM users
LEFT JOIN photos
	ON users.id=photos.user_id
WHERE photos.id IS NULL;

-- 4.IDENTIFY MOST POPULAR PHOTO( AND USER WHO CREATED IT)
-- we runnning a new contest to see who can get the most likes on single photos
-- WHO WON??!!
SELECT 
    username,
	photos.id,
    photos.image_url, 
    count(likes.user_id) AS total
FROM photos
INNER JOIN likes 
    ON likes.photo_id=photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id 
ORDER BY total DESC
LIMIT 1;


-- 5.CALCULATE AVG NUMBER OF PHOTOS PER USER
-- Our investors want to know how many times does the average user post

-- total number of photos / total number of users
SELECT 
	(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg;
    
-- 6. most populat hashtags
-- A brand wants to know  which hashtags to use in a post
-- What are the top 5 most commonly used hashtags

SELECT 
	tags.tag_name,
	COUNT(*) AS total
FROM photo_tags
    JOIN tags
      ON photo_tags.tag_id= tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

 
SELECT tags.tag_name, 
       Count(*) AS total 
FROM   photo_tags 
       JOIN tags 
         ON photo_tags.tag_id = tags.id 
GROUP  BY tags.id 
ORDER  BY total DESC;