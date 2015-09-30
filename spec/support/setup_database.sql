CREATE TABLE human_lab_data ( person_id integer, age integer, nationality text
  , parent_id integer);
INSERT INTO human_lab_data (person_id,age, nationality,parent_id)
VALUES (1,66, 'american',null)
, (2,69, 'american',null)
, (3,30, 'german',null)
, (4,15, 'colombian',5)
, (5,50, 'ireland',6)
, (6,100, 'finland',null)
, (7,3, 'american',3);
