DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS topics;
DROP TABLE IF EXISTS users;

create table users (
	id SERIAL PRIMARY KEY,
	user_id VARCHAR NOT NULL,
	password VARCHAR NOT NULL,
	user_email VARCHAR NOT NULL,
	fullname VARCHAR NOT NULL,
	create_at TIMESTAMP
);

create table topics (
	id SERIAL PRIMARY KEY,
	category VARCHAR NOT NULL,
	topic_text VARCHAR NOT NULL,
	user_id INTEGER REFERENCES users(id),
	vote INTEGER default 0,
	location TEXT, 
	create_at TIMESTAMP default CURRENT_TIMESTAMP
);

create table comments (
	id SERIAL PRIMARY KEY,
	topic_id INTEGER NOT NULL REFERENCES topics(id),
	user_id INTEGER NOT NULL REFERENCES users(id),
	comments_text VARCHAR NOT NULL,
	location TEXT, 
	create_at TIMESTAMP default CURRENT_TIMESTAMP
);

create table votes (
	id SERIAL PRIMARY KEY,
	topic_id INTEGER NOT NULL REFERENCES topics(id),
	user_id INTEGER NOT NULL REFERENCES users(id),
	vote INTEGER default 0,
	create_at TIMESTAMP default CURRENT_TIMESTAMP
);

INSERT INTO users
(user_id, password, user_email, fullname, create_at)
VALUES 
('john123','password', 'john@gmail.com','John Roger', CURRENT_TIMESTAMP),
('jay1', 'password', 'jay@gmail.com','jay young', CURRENT_TIMESTAMP),
('can1', 'password', 'can@yahoo.com','Canny Donald', CURRENT_TIMESTAMP),
('Mike1','password', 'mike1@yahoo.com','play big', CURRENT_TIMESTAMP);

INSERT INTO topics 
(category, topic_text,user_id,create_at)
VALUES
('sports','Who is the best NBA Player of all time?', 1,CURRENT_TIMESTAMP),
('software', 'what is most interesting computer language?', 2,CURRENT_TIMESTAMP),
('dance', 'Who is popular dance instructor in nyc?', 3,CURRENT_TIMESTAMP);

INSERT INTO comments
(topic_id, user_id, comments_text, create_at) 
VALUES
(1,1,'I think it is MJ',CURRENT_TIMESTAMP),
(2,2,'I think it is Ruby',CURRENT_TIMESTAMP),
(3,3, 'Check out this person, Joel', CURRENT_TIMESTAMP);


