\c bobo;

INSERT INTO users
(user_id, password, user_email, fullname, create_at)
VALUES 
('john123','password', 'john@gmail.com','John Roger', CURRENT_TIMESTAMP),
('jay1', 'password', 'jay@gmail.com','jay young', CURRENT_TIMESTAMP),
('can1', 'password', 'can@yahoo.com','Canny Donald', CURRENT_TIMESTAMP),
('Mike1','password', 'mike1@yahoo.com','play big', CURRENT_TIMESTAMP);

INSERT INTO topics 
(category, topic_text, topic_image, user_id,create_at)
VALUES
('sports','Whos the best NBA Player of all time?', 'http://en.wikipedia.org/wiki/Michael_Jordan#/media/File:Michael_Jordan_in_2014.jpg', 1,CURRENT_TIMESTAMP),
('software', 'whats most interesting computer language?','http://en.wikipedia.org/wiki/Computer#/media/File:Thinking_Machines_Connection_Machine_CM-5_Frostburg_2.jpg', 2,CURRENT_TIMESTAMP),
('dance', 'Who is well known dance instructor in nyc?', 'http://en.wikipedia.org/wiki/Salsa_%28dance%29#/media/File:Salsa_en_Cali.jpg', 3,CURRENT_TIMESTAMP);

INSERT INTO comments
(topic_id, user_id, comments_text, create_at) 
VALUES
(1,1,'I think it is MJ',CURRENT_TIMESTAMP),
(2,2,'I think it is Ruby',CURRENT_TIMESTAMP),
(3,3, 'Check out this person, Joel', CURRENT_TIMESTAMP);


