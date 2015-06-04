DROP DATABASE IF EXISTS bobo;
CREATE DATABASE bobo;
\c bobo;


create table users (
	id SERIAL PRIMARY KEY,
	user_id VARCHAR NOT NULL,
	password VARCHAR NOT NULL,
	user_email VARCHAR NOT NULL,
	username VARCHAR NOT NULL,
	create_at TIMESTAMP
);

create table topics (
	id SERIAL PRIMARY KEY,
	topic_image VARCHAR NOT NULL,
	topic_text VARCHAR NOT NULL,
	category VARCHAR NOT NULL,
	create_at TIMESTAMP
);

create table comments (
	id SERIAL PRIMARY KEY,
	topic_id INTEGER NOT NULL REFERENCES topics(id),
	user_id INTEGER NOT NULL REFERENCES users(id),
	comments_text VARCHAR NOT NULL,
	comments_image VARCHAR NOT NULL,
	create_at TIMESTAMP
);

create table votes (
	id SERIAL PRIMARY KEY,
	comment_id INTEGER NOT NULL REFERENCES comments(id),
	user_id INTEGER NOT NULL REFERENCES users(id),
	votes INTEGER default 0,
	create_at TIMESTAMP
);

create table relevance (
	id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL REFERENCES users(id),
	topic_id INTEGER NOT NULL REFERENCES topics(id),
	topic_point	INTEGER default 0,
	comment_point INTEGER default 0,
	vote_point INTEGER default 0, 
	total_point INTEGER default 0 
);

