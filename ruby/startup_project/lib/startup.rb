require "employee"

class Startup

    attr_reader :name, :funding, :salaries, :employees

    def initialize(name, funding, salaries)
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end

    def valid_title?(title)
        @salaries.keys.any? {|position| title == position}
    end

    def >(other)
        @funding > other.funding
    end

    def hire(name, title)
        if !self.valid_title?(title)
            raise "Title does not exist"
        else 
            @employees << Employee.new(name,title)
        end
    end

    def size
        @employees.length
    end

    def pay_employee(employee)
        if @funding >= @salaries[employee.title]
            employee.pay(@salaries[employee.title])
            @funding -= @salaries[employee.title]
        else
            raise "Insufficient funding"
        end
    end

    def payday
        @employees.each {|employee| self.pay_employee(employee)}
    end

    def average_salary
        (@employees.inject(0) {|sum, employee| sum += @salaries[employee.title]})/@employees.length
    end

    def close 
        @employees = []
        @funding = 0
    end

    def acquire(other_startup)
        @funding += other_startup.funding
        other_startup.salaries.each do |title, salary|
            @salaries[title] = salary if !@salaries.key?(title)
        end
        @employees += other_startup.employees
        other_startup.close
    end
end
