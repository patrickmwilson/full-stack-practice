class Employee

    attr_reader :name, :title, :salary, :boss

    def initialize(name, title, salary)
        @name = name 
        @title = title 
        @salary = salary 
        @boss = nil
    end

    def print_heirarchy
        puts "#{@name}: #{@title}, #{@salary}, #{@boss ? @boss.name : nil}"
    end

    def boss=(new_boss)
        @boss = new_boss
    end

    def bonus(multiplier)
        @salary * multiplier
    end
end

class Manager < Employee 

    def initialize(name, title, salary)
        @employees = Array.new
        super(name, title, salary)
    end

    def print_heirarchy
        super 
        unless @employees.empty?
            @employees.each do |employee|
                employee.print_heirarchy
            end
        end
    end

    def add_employee(employee)
        @employees << employee 
        employee.boss = self
    end

    def bonus(multiplier)
        self._total_salary * multiplier
    end

    protected

    attr_reader :employees

    def _total_salary
        total = 0
        self.employees.each do |subordinate|
            total += subordinate.salary 
            if subordinate.is_a?(Manager)
                total += subordinate._total_salary 
            end
        end
        total 
    end
end