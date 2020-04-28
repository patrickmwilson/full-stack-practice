require 'sqlite3'
require_relative 'question_db_connection'
require_relative 'questions'
require_relative 'replies'
require_relative 'question_follows'
require_relative 'question_likes'

class User

    attr_accessor :id, :fname, :lname

    def self.all 
        data = QuestionDBConnection.instance.execute("SELECT * FROM users")
        data.map {|datum| User.new(datum)}
    end

    def self.find_by_id(id)
        user = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil unless user.length > 0
        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0
        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def insert 
        raise "#{self} already in database" if self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.fname, self.lname)
            INSERT INTO
                users(fname, lname)
            VALUES
                (?, ?)
        SQL
    end

    def update
        raise "#{self} not in database" unless self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.fname, self.lname, self.id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
        SQL
    end

    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(self.id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(self.id)
    end

    def average_karma
        data = QuestionDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                COUNT(DISTINCT(questions.id))/CAST((COUNT(ql.question_id)) AS FLOAT) AS avg
            FROM
                questions
            LEFT OUTER JOIN
                question_likes AS ql ON ql.question_id = questions.id
            WHERE
                questions.author_id = ?
        SQL
        data.first['avg'].to_f
    end
end