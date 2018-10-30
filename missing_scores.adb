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
    paverage: Integer;
    ppoints: Integer;
    qgrades: quiz_grades;
    qaverage: Integer;
    qpoints: Integer;
    tgrades: test_grades;
    taverage: Integer;
    tpoints: Integer;
    egrades: exam_grades;
    epoints: Integer;
    eaverage: Integer;
    overall_average: Integer;
    letter_grade: Character;
end record;
type student_array is array(1..100) of student;
function compute_program_average(s: student) return Integer is
    sum: Integer:=0;
    average: Integer;
    begin
    for i in 1..s.pgrades.num_grades loop
        sum := sum + s.pgrades.grades_array(i);
    end loop;
    average := sum/s.pgrades.num_grades;
    return average;
end compute_program_average;

function compute_program_points(s:student) return Integer is
    points: Integer;
    begin
    points := Integer(s.paverage * s.pgrades.percent_total);
    points := Integer(points / 100);
    return points;
end compute_program_points;

function compute_quiz_average(s: student) return Integer is
    sum : Integer:=0;
    average: Integer;
    begin
    for i in 1..s.qgrades.num_grades loop
        sum := sum + s.qgrades.grades_array(i);
    end loop;
    average := sum/s.qgrades.num_grades;
    return average;
end compute_quiz_average;

function compute_quiz_points(s: student) return Integer is
    points: Integer;
    begin
    points := Integer(s.qaverage * s.qgrades.percent_total);
    points := Integer(points / 100);
    return points;
end compute_quiz_points;

function compute_test_average(s: student) return Integer is
    sum: Integer := 0;
    average: Integer;
    begin
    for i in 1..s.tgrades.num_grades loop
        sum := sum + s.tgrades.grades_array(i);
    end loop;
    average := sum/s.tgrades.num_grades;
    return average;
end compute_test_average;

function compute_test_points(s: student) return Integer is
    points: Integer;
    begin
    points := Integer(s.taverage * s.tgrades.percent_total);
    points := Integer(points / 100);
    return points;
end compute_test_points;

function compute_exam_points(s: student) return Integer is
    points: Integer;
    begin
    points:= Integer(s.eaverage * s. egrades.percent_total);
    points:= Integer(points / 100);
    return points;
end compute_exam_points;

procedure fill_in_missing_test_grade(s: in out student) is
    begin
    for i in 1..s.tgrades.num_grades loop
        if s.tgrades.grades_array(i) = 0 then
            s.tgrades.grades_array(i) := s.eaverage;
        end if;
    end loop;
end fill_in_missing_test_grade;


function computer_letter_grade (s: student) return Character is
    sum : Float;
    grade: Character;
    begin
    sum := Float(s.ppoints + s.qpoints + s.tpoints + s.epoints);
    if sum >= 90.0 then
        grade := 'A';
    elsif sum >= 80.0 then
        grade := 'B';
    elsif sum >= 70.0 then
        grade := 'C';
    elsif sum >= 60.0 then
        grade := 'D';
    else
        grade := 'F';
    end if;
    return grade;
end computer_letter_grade;

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
temp.paverage := compute_program_average(temp);
temp.qaverage := compute_quiz_average(temp);
temp.eaverage := temp.egrades.exam_grade;
fill_in_missing_test_grade(temp);
temp.taverage := compute_test_average(temp);
temp.ppoints := compute_program_points(temp);
temp.qpoints := compute_quiz_points(temp);
temp.tpoints := compute_test_points(temp);
temp.epoints := compute_exam_points(temp);
temp.letter_grade := computer_letter_grade(temp);
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
put(stu_array(3).letter_grade);
end missing_scores;


