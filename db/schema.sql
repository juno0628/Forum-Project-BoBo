DROP DATABASE IF EXISTS bobo;
CREATE DATABASE bobo;
\c bobo;


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

