require_relative "../config/environment.rb"

class Student
attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
      DROP TABLE students;
      SQL
      DB[:conn].execute(sql)
      end

      def save
        if self.id
          update
        else
          sql = <<-SQL
          INSERT INTO students(name, grade)
          VALUES (?, ?);
          SQL

          DB[:conn].execute(sql, self.name, self.grade)
          self.id = DB[:conn].execute('SELECT last_insert_rowid()')[0][0]
        end
        self
      end

      def update 
        sql = <<-SQL
        UPDATE students SET name = ?, grade = ? WHERE id = ?;
        SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)
      end

      def self.create(name, grade, id=nil)
        student = self.new(name, grade, id)
        student.save
      end

      def self.new_from_db(row)
        self.new(row[1], row[2], row[0])
      end

      def self.find_by_name(name)
        sql = <<-SQL
          SELECT * FROM students WHERE name=?;
        SQL
    
        new_from_db(DB[:conn].execute(sql, name)[0])
      end

end
