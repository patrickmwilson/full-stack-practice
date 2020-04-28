require 'sqlite3'
require_relative 'question_db_connection'
require_relative 'user'

class Reply

    attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body

    def self.all 
        data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
        data.map {|datum| Reply.new(datum)}
    end

    def self.find_by_id(id)
        reply = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_user_id(user_id)
        replies = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map {|reply| Reply.new(reply)}
    end

    def self.find_by_question_id(question_id)
        replies = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map {|reply| Reply.new(reply)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end

    def insert 
        raise "#{self} already in database" if self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.question_id, self.parent_reply_id, self.author_id, self.body)
            INSERT INTO
                replies(question_id, parent_reply_id, author_id, body)
            VALUES
                (?, ?, ?, ?)
        SQL
    end

    def update
        raise "#{self} not in database" unless self.id 
        QuestionDBConnection.instance.execute(<<-SQL, self.question_id, self.parent_reply_id, self.author_id, self.body, self.id)
            UPDATE
                replies
            SET
                question_id = ?, parent_reply_id = ?, author_id = ?, body = ?
            WHERE
                id = ?
        SQL
    end

    def author
        User.find_by_id(self.author_id)
    end

    def question 
        Question.find_by_id(self.question_id)
    end

    def parent_reply
        return nil unless self.parent_reply_id
        Reply.find_by_id(self.parent_reply_id)
    end

    def child_replies
        children = QuestionDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil unless children.length > 0
        children.map {|child| Reply.new(child)}
    end

end