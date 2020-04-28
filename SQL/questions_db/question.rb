require 'sqlite3'
require_relative 'question_db_connection'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'

class Question 

    attr_accessor :id, :title, :body, :author_id

    def self.all 
        data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
        data.map {|datum| Question.new(datum)}
    end

    def self.find_by_id(id)
        question = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        question = QuestionDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end

    def self.most_followed
        QuestionFollow.most_followed_questions(1)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def insert 
        raise "#{self} already in database" if self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.title, self.body, self.author_id)
            INSERT INTO
                questions(title, body, author_id)
            VALUES
                (?, ?, ?)
        SQL
    end

    def update
        raise "#{self} not in database" unless self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
            UPDATE
                questions
            SET
                title = ?, body = ?, author_id = ?
            WHERE
                id = ?
        SQL
    end

    def author 
        User.find_by_id(self.author_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
    end

    def likers
        users = QuestionDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                users
            JOIN
                question_likes AS ql ON ql.user_id = users.id
            WHERE
                ql.question_id = ?
        SQL
        return nil unless users.length > 0
        users.map {|user| User.new(user)}
    end

    def num_likes
        data = QuestionDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                count(*) AS num
            FROM
                question_likes
            WHERE
                question_likes.question_id = ?
        SQL
        data.first["num"].to_i
    end

end