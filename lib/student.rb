require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_reader :id
  attr_accessor :name, :grade 

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade

  end

  def self.create_table

    sql = "CREATE TABLE IF NOT EXISTS students(
            id Integer PRIMARY KEY,
            name TEXT,
            grade Integer 
    )"


    DB[:conn].execute(sql)

  end

  def self.drop_table
    
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)

  end

  def save

    if self.id
      self.update
    else
      sql = "INSERT INTO students(name, grade)
            values(?, ?)
            "

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

  end

  def update

    sql = "UPDATE students 
          SET name = ?, 
          grade = ?
          where id = ?"


    DB[:conn].execute(sql, self.name, self.grade, @id)

  end

  def self.create(name, grade)

    new_student = Student.new(name, grade)
    new_student.save
    new_student

  end

  def self.new_from_db(row)

    Student.new(row[0], row[1], row[2])

  end

  def self.find_by_name(name)

    sql = "SELECT * FROM students 
          where name = ?
          LIMIT 1"


    Student.new_from_db(DB[:conn].execute(sql, name)[0])

  end

end
