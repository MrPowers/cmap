module Helpers
  def seed_human_lab_data(connection)
    connection.exec("CREATE SCHEMA IF NOT EXISTS some_schema;")
    connection.exec("DROP TABLE IF EXISTS some_schema.human_lab_data;")
    connection.exec("CREATE TABLE some_schema.human_lab_data (id integer, age integer, nationality text, created_at date, parent_id integer );")
    add_data_query = %q{
      INSERT INTO some_schema.human_lab_data (id, age, nationality, created_at,parent_id) VALUES
      (1,66, 'american', '2013-09-01',null),
      (2,69, 'american', '2015-09-01',null),
      (3,10, 'american', '2013-09-01',1),
      (4,5, 'american', '2015-07-01',6),
      (5,10, 'american', '2015-08-01',2),
      (6,30, 'german', '2015-09-01',8),
      (7,15, 'crazy', '2014-01-01',null),
      (8,99, 'ireland', '2014-01-01',null),
      (9,100, 'finland', '2014-01-01',null);
    }
    connection.exec(add_data_query)
  end
end
