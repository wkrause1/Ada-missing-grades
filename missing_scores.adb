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

function compute_overall_average(s:student) return Integer is
    sum: Integer;
    begin
    sum := s.ppoints + s.qpoints + s.tpoints + s.epoints;
    return sum;
end compute_overall_average;

procedure fill_in_missing_test_grade(s: in out student) is
    begin
    for i in 1..s.tgrades.num_grades loop
        if s.tgrades.grades_array(i) = 0 then
            s.tgrades.grades_array(i) := s.eaverage;
        end if;
    end loop;
end fill_in_missing_test_grade;


function computer_letter_grade (s: student) return Character is
    grade: Character;
    begin
    if s.overall_average >= 90 then
        grade := 'A';
    elsif s.overall_average >= 80 then
        grade := 'B';
    elsif s.overall_average >= 70 then
        grade := 'C';
    elsif s.overall_average >= 60 then
        grade := 'D';
    else
        grade := 'F';
    end if;
    return grade;
end computer_letter_grade;

procedure make_records(programs: out program_grades; quizzes: out quiz_grades; tests: out test_grades; exams: out exam_grades) is
begin
get(programs.num_grades);
get(programs.percent_total);
get(quizzes.num_grades);
get(quizzes.percent_total);
get(tests.num_grades);
get(tests.percent_total);
get(exams.num_grades);
get(exams.percent_total);
skip_line;
end make_records;

procedure make_students(stu_array: in out student_array; programs: program_grades; quizzes: quiz_grades; tests: test_grades; exams: exam_grades; stu_count: out Integer) is
temp: student;
stu_array_index: Natural:=1;
counter: Integer;
tempNum: Integer;
begin
stu_count := 0;
while not end_of_file loop
counter:=1;
get_line(temp.name, temp.letters_in_name);
temp.pgrades:= programs;
while not end_of_line loop
    get(tempNum);
    temp.pgrades.grades_array(counter) := tempNum;
    counter := counter + 1;
end loop;
skip_line;
counter := 1;
temp.qgrades := quizzes;
while not end_of_line loop
    get(tempNum);
    temp.qgrades.grades_array(counter) := tempNum;
    counter:= counter + 1;
end loop;
skip_line;
counter := 1;
temp.tgrades:= tests;
while not end_of_line loop
    get(tempNum);
    temp.tgrades.grades_array(counter) := tempNum;
    counter:= counter + 1;
end loop;
skip_line;
temp.egrades:= exams;
get(tempNum);
temp.egrades.exam_grade:=tempNum;
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
temp.overall_average := compute_overall_average(temp);
temp.letter_grade := computer_letter_grade(temp);
stu_array(stu_array_index) := temp;
stu_array_index := stu_array_index + 1;
stu_count := stu_count + 1;
end loop;
end make_students;

procedure print(s: student_array; stu_count: Integer) is
begin
for i in 1..stu_count loop
    put_line("Name: " & s(i).name(1..s(i).letters_in_name));
    put_line("Overall Average: " & s(i).overall_average'img);
    put_line("Letter Grade: " & s(i).letter_grade);
    put_line("Category          Weight  Average  Points   Grades ...");
    put("Programs           " & s(i).pgrades.percent_total'img &"      " & s(i).paverage'img &"     " & s(i).ppoints'img & "    ");
    for j in 1..s(i).pgrades.num_grades loop
        put(s(i).pgrades.grades_array(j)'img);
    end loop;
    new_line;
    put("Quizzes            " & s(i).qgrades.percent_total'img &"      " & s(i).qaverage'img &"     " & s(i).qpoints'img & "    ");
    for j in 1..s(i).qgrades.num_grades loop
        put(s(i).qgrades.grades_array(j)'img);
    end loop;
    new_line;
    put("Tests              " & s(i).tgrades.percent_total'img &"      " & s(i).taverage'img &"     " & s(i).tpoints'img & "    ");
    for j in 1..s(i).tgrades.num_grades loop
        put(s(i).tgrades.grades_array(j)'img);
    end loop;
    new_line;
    put("Final Exam         " & s(i).egrades.percent_total'img &"      " & s(i).eaverage'img &"     " & s(i).epoints'img & "    ");
    put(s(i).egrades.exam_grade'img);
    new_line;
    new_line;
end loop;
end print;

procedure insertion_sort(s: in out student_array; stu_count: Integer) is
    val : student;
    j: natural;
begin
    for i in 1 + 1..stu_count loop
        val := s(i);
        j := i-1;
        while j >= 1 and then s(j).overall_average < val.overall_average loop
            s(j+1) := s(j);
            j := j-1;
        end loop;
        s(j+1) := val;
    end loop;
end insertion_sort;

programs: program_grades;
quizzes: quiz_grades;
tests: test_grades;
exams: exam_grades;
stu_array: student_array;
stu_count: Integer;
begin
make_records(programs, quizzes, tests, exams);
make_students(stu_array, programs, quizzes, tests, exams, stu_count);
insertion_sort(stu_array, stu_count);
print(stu_array, stu_count);
end missing_scores;