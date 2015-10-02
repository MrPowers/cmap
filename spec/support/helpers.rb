module Helpers
  def seed_human_lab_data(connection)
    connection.exec("DROP TABLE IF EXISTS human_lab_data;")
    connection.exec("CREATE TABLE human_lab_data ( age integer, nationality text, created_at date );")
    add_data_query = %q{
      INSERT INTO human_lab_data (age, nationality, created_at) VALUES
      (66, 'american', '2013-09-01'),
      (69, 'american', '2015-09-01'),
      (10, 'american', '2013-09-01'),
      (5, 'american', '2015-07-01'),
      (10, 'american', '2015-08-01'),
      (30, 'german', '2015-09-01'),
      (15, 'crazy', '2014-01-01'),
      (99, 'ireland', '2014-01-01'),
      (100, 'finland', '2014-01-01');
    }
    connection.exec(add_data_query)
  end
end
