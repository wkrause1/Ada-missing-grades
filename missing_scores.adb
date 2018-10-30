with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure missing_scores is

type grades is array( 1..77 ) of Natural;
type program_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => 0);
    percent_total: Natural;
end record;
type quiz_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => 0);
    percent_total: Natural;
end record;
type test_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => 0);
    percent_total: Natural;
end record;
type exam_grades is record
    num_grades: Natural := 1;
    exam_grade: Natural;
    percent_total: Natural;
end record;
type student is record
    name: String(1..40);
    letters_in_name: Natural;
    pgrades: program_grades;
    qgrades: quiz_grades;
    tgrades: test_grades;
    egrades: exam_grades;
    overall_average: float;
    letter_grade: Character;
end record;
type student_array is array(1..100) of student;


procedure make_records(programs: out program_grades; quizzes: out quiz_grades; tests: out test_grades; exams: out exam_grades) is
begin
get(programs.num_grades);
--put_line(programs.num_grades'img);
get(programs.percent_total);
--put_line(programs.percent_total'img);
get(quizzes.num_grades);
--put_line(quizzes.num_grades'img);
get(quizzes.percent_total);
get(tests.num_grades);
get(tests.percent_total);
get(exams.num_grades);
get(exams.percent_total);
skip_line;
end make_records;

procedure make_students(stu_array: in out student_array; programs: program_grades; quizzes: quiz_grades; tests: test_grades; exams: exam_grades) is
temp: student;
stu_array_index: Natural:=1;
counter: Integer;
tempNum: Integer;
begin
while not end_of_file loop
counter:=1;
get_line(temp.name, temp.letters_in_name);
--skip_line;
--put_line(temp.name);
--put_line(temp.letters_in_name'img);
temp.pgrades:= programs;
while not end_of_line loop
    get(tempNum);
    temp.pgrades.grades_array(counter) := tempNum;
    --put(temp.pgrades.grades_array(counter)'img);
    counter := counter + 1;
end loop;
skip_line;
counter := 1;
temp.qgrades := quizzes;
while not end_of_line loop
    get(tempNum);
    temp.qgrades.grades_array(counter) := tempNum;
    --put(temp.qgrades.grades_array(counter)'img);
    counter:= counter + 1;
end loop;
skip_line;
counter := 1;
temp.tgrades:= tests;
while not end_of_line loop
    get(tempNum);
    temp.tgrades.grades_array(counter) := tempNum;
    --put(temp.tgrades.grades_array(counter)'img);
    counter:= counter + 1;
end loop;
skip_line;
temp.egrades:= exams;
get(tempNum);
temp.egrades.exam_grade:=tempNum;
--put(temp.egrades.exam_grade'img);
if not end_of_file then
skip_line;
end if;
stu_array(stu_array_index) := temp;
stu_array_index := stu_array_index + 1;
end loop;
end make_students;

programs: program_grades;
quizzes: quiz_grades;
tests: test_grades;
exams: exam_grades;
stu_array: student_array;
begin
make_records(programs, quizzes, tests, exams);
make_students(stu_array, programs, quizzes, tests, exams);
--put(stu_array(4).name);
end missing_scores;


