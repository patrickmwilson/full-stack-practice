require 'sqlite3'
require_relative 'question_db_connection'
require_relative 'question'
require_relative 'user'

class QuestionLike 

    attr_accessor :id, :user_id, :question_id

    def self.all 
        data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
        data.map {|datum| QuestionLike.new(datum)}
    end

    def self.find_by_id(id)
        like = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        return nil unless like.length > 0
        QuestionLike.new(like.first)
    end

    def self.likers_for_question_id(question_id)
        Question.find_by_id(question_id).likers
    end

    def self.num_likes_for_question_id(question_id)
        Question.find_by_id(question_id).num_likes
    end

    def self.liked_questions_for_user_id(user_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                question_id
            FROM
                question_likes
            WHERE
                user_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map {|question| Question.find_by_id(question["question_id"].to_i)}
    end

    def self.most_liked(n)
        questions = QuestionDBConnection.instance.execute(<<-SQL, n)
            SELECT
                id
            FROM
                questions
            WHERE 
                id IN (
                    SELECT
                        question_id
                    FROM
                        question_likes
                    GROUP BY
                        question_id
                    ORDER BY
                        COUNT(*) DESC
                )
            LIMIT(?)
        SQL
        return nil unless questions.length > 0
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
                question_likes(user_id, question_id)
            VALUES
                (?, ?)
        SQL
    end

    def update
        raise "#{self} not in database" unless self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.user_id, self.question_id, self.id)
            UPDATE
                question_likes
            SET
                user_id = ?, question_id = ?
            WHERE
                id = ?
        SQL
    end

end