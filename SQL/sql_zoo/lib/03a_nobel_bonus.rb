# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    SELECT
      DISTINCT physics.yr
    FROM
      nobels AS physics
    WHERE
      subject = 'Physics' AND physics.yr NOT IN (
        SELECT
          chemistry.yr
        FROM
          nobels AS chemistry
        WHERE
          subject = 'Chemistry'
      )
  SQL
end
