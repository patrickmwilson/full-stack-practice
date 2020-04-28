DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS questions_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

INSERT INTO 
    users (fname,lname)
VALUES
    ('Patrick', 'Wilson'),
    ('James', 'Wilson'),
    ('Henry', 'Wilson');


CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
    questions(title, body, author_id)
VALUES 
    ('Age?',
    'How old are you?',
    (SELECT id FROM users WHERE fname = 'Patrick' AND lname = 'Wilson'));

INSERT INTO 
    questions(title, body, author_id)
VALUES
    ('Favorite food?', 
    'What is your favorite food to eat?',
    (SELECT id FROM users WHERE fname = 'James'));

INSERT INTO 
    questions(title, body, author_id)
VALUES
    ('Why?', 
    'Why are you answering these questions?', 
    (SELECT id FROM users WHERE fname = 'Henry'));


CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows(user_id, question_id)
VALUES 
    ((SELECT id FROM users WHERE fname = 'James' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Age?'));

INSERT INTO 
    question_follows(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Patrick' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Why?'));

INSERT INTO 
    question_follows(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Henry' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Favorite food?'));


CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
    replies(question_id, parent_reply_id, author_id, body)
VALUES 
    ((SELECT id FROM questions WHERE title = 'Age?'),
    NULL,
    (SELECT id FROM users WHERE fname = 'James' AND lname = 'Wilson'),
    "I am 14");

INSERT INTO 
    replies(question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Why?'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Patrick' AND lname = 'Wilson'),
    "I am trying to learn SQL");

INSERT INTO 
    replies(question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Favorite food?'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Henry' AND lname = 'Wilson'),
    "My favorite food is pizza!");

INSERT INTO 
    replies(question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Favorite food?'),
    (SELECT id FROM replies WHERE body = 'My favorite food is pizza!'),
    (SELECT id FROM users WHERE fname = 'Patrick' AND lname = 'Wilson'),
    "Pizza sucks!");


CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
    question_likes(user_id, question_id)
VALUES 
    ((SELECT id FROM users WHERE fname = 'James' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Age?'));

INSERT INTO 
    question_likes(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Patrick' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Why?'));

INSERT INTO 
    question_likes(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Henry' AND lname = 'Wilson'),
    (SELECT id FROM questions WHERE title = 'Favorite food?'));