require 'sqlite3'
require_relative 'question_db_connection'
require_relative 'question'
require_relative 'user'


class QuestionFollow 

    attr_accessor :id, :user_id, :question_id

    def self.all 
        data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
        data.map {|datum| QuestionFollow.new(datum)}
    end

    def self.find_by_id(id)
        follow = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        return nil unless follow.length > 0
        QuestionFollow.new(follow.first)
    end

    def self.followers_for_question_id(question_id)
        followers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                users.id
            FROM
                users
            JOIN
                question_follows ON question_follows.user_id = users.id 
            WHERE
                question_follows.question_id = ?
        SQL
        return nil unless followers.length > 0
        followers.map {|follower| User.find_by_id(follower['id'].to_i)}
    end

    def self.followed_questions_for_user_id(user_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.id
            FROM
                questions
            JOIN
                question_follows ON question_follows.question_id = questions.id 
            WHERE
                question_follows.user_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map {|question| Question.find_by_id(question['id'].to_i)}
    end

    def self.most_followed_questions(n)
        questions = QuestionDBConnection.instance.execute(<<-SQL, n)
            SELECT
                questions.id 
            FROM
                questions
            WHERE
                questions.id IN (
                    SELECT
                        question_id
                    FROM
                        question_follows
                    GROUP BY
                        question_id
                    ORDER BY
                        count(*) DESC
                )
            LIMIT(?)
        SQL
        questions.map {|question| Question.find_by_id(question['id'].to_i)}
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def insert 
        raise "#{self} already in database" if self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.user_id, self.question_id)
            INSERT INTO
                question_follows(user_id, question_id)
            VALUES
                (?, ?)
        SQL
    end

    def update
        raise "#{self} not in database" unless self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.user_id, self.question_id, self.id)
            UPDATE
                question_follows
            SET
                user_id = ?, question_id = ?
            WHERE
                id = ?
        SQL
    end

end