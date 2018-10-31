with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

--@author Will Krause
--@version 2018-10-31
--@email wkrause1@radford.edu
--@row-col 0,3
procedure missing_scores is
zero: constant Integer:= 0;
missing_grade: constant Integer := 101;
type let_grade is (A,B,C,D,F);
subtype grade is Natural range 0..101;
type grades is array( 1..77 ) of grade;

type program_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => missing_grade);
    percent_total: Natural;
end record;

type quiz_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => missing_grade);
    percent_total: Natural;
end record;

type test_grades is record
    num_grades: Natural;
    grades_array: grades:= (others => missing_grade);
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
    paverage: Float;
    ppoints: Float;
    qgrades: quiz_grades;
    qaverage: Float;
    qpoints: Float;
    tgrades: test_grades;
    taverage: Float;
    tpoints: Float;
    egrades: exam_grades;
    epoints: Float;
    eaverage: Float;
    overall_average: Float;
    letter_grade: let_grade;
end record;

type student_array is array( 1..100 ) of student;


function compute_program_average(s: student) return Float is
    sum: Float:=0.0;
    average: Float;
    begin
    for i in 1..s.pgrades.num_grades loop
        if s.pgrades.grades_array(i) /= missing_grade then
            sum := sum + Float(s.pgrades.grades_array(i));
        end if;
    end loop;
    average := sum/ Float(s.pgrades.num_grades);
    return average;
end compute_program_average;

function compute_program_points(s:student) return Float is
    points: Float;
    begin
    points := s.paverage * Float(s.pgrades.percent_total);
    points := points / Float(100);
    return points;
end compute_program_points;

function compute_quiz_average(s: student) return Float is
    sum : Float:=0.0;
    average: Float;
    begin
    for i in 1..s.qgrades.num_grades loop
        if s.qgrades.grades_array(i) /= missing_grade then
            sum := sum + Float(s.qgrades.grades_array(i));
        end if;
    end loop;
    average := sum/Float(s.qgrades.num_grades);
    return average;
end compute_quiz_average;

function compute_quiz_points(s: student) return Float is
    points: Float;
    begin
    points := s.qaverage * Float(s.qgrades.percent_total);
    points := points / Float(100);
    return points;
end compute_quiz_points;

function compute_test_average(s: student) return Float is
    sum: Float:= 0.0;
    average: Float;
    begin
    for i in 1..s.tgrades.num_grades loop
        if s.tgrades.grades_array(i) /= missing_grade then
            sum := sum + Float(s.tgrades.grades_array(i));
        elsif s.egrades.exam_grade /= missing_grade then
            sum := sum + Float(s.egrades.exam_grade);
        end if;
    end loop;
    average := sum/Float(s.tgrades.num_grades);
    return average;
end compute_test_average;

function compute_test_points(s: student) return Float is
    points: Float;
    begin
    points := s.taverage * Float(s.tgrades.percent_total);
    points := points / Float(100);
    return points;
end compute_test_points;

function compute_exam_points(s: student) return Float is
    points: Float;
    begin
    points:= s.eaverage * Float(s.egrades.percent_total);
    points:= points / Float(100);
    return points;
end compute_exam_points;

function compute_overall_average(s:student) return Float is
    sum: Float;
    begin
    sum := s.ppoints + s.qpoints + s.tpoints + s.epoints;
    return sum;
end compute_overall_average;

procedure fill_in_missing_test_grade(s: in out student) is
    begin
    for i in 1..s.tgrades.num_grades loop
        if s.tgrades.grades_array(i) = 101 then
            s.tgrades.grades_array(i) := Integer(s.eaverage);
        end if;
    end loop;
end fill_in_missing_test_grade;


function computer_letter_grade (s: student) return let_grade is
    grade: let_grade;
    begin
    if s.overall_average >= 90.0 then
        grade := A;
    elsif s.overall_average >= 80.0 then
        grade := B;
    elsif s.overall_average >= 70.0 then
        grade := C;
    elsif s.overall_average >= 60.0 then
        grade := D;
    else
        grade := F;
    end if;
    return grade;
end computer_letter_grade;

procedure make_records(programs: out program_grades; quizzes: out quiz_grades; 
                        tests: out test_grades; exams: out exam_grades) is
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

procedure get_program_grades(s: in out student)  is
    tempNum: Integer;
    counter: Integer := 1;
begin
    while not end_of_line loop
        get(tempNum);
        s.pgrades.grades_array(counter) := tempNum;
        counter := counter + 1;
    end loop;
end get_program_grades;

procedure get_quiz_grades(s: in out student) is
    tempNum: Integer;
    counter: Integer := 1;
begin
    while not end_of_line loop
        get(tempNum);
        s.qgrades.grades_array(counter) := tempNum;
        counter := counter + 1;
    end loop;
end get_quiz_grades;

procedure get_test_grades(s: in out student) is
    tempNum: Integer;
    counter: Integer := 1;
begin
    while not end_of_line loop
        get(tempNum);
        s.tgrades.grades_array(counter) := tempNum;
        counter := counter + 1;
    end loop;
end get_test_grades;

procedure get_exam_grades(s: in out student) is
    tempNum: Integer;
begin
    if not end_of_line then
        get(tempNum);
        s.egrades.exam_grade:= tempNum;
    else
        s.egrades.exam_grade := missing_grade;
    end if;
end get_exam_grades;

procedure make_students(stu_array: in out student_array; programs: program_grades; quizzes: quiz_grades; 
                        tests: test_grades; exams: exam_grades; stu_count: out Integer) is
    temp: student;
    stu_array_index: Natural:=1;
begin
    stu_count := 0;
    while not end_of_file loop
    get_line(temp.name, temp.letters_in_name);
    temp.pgrades:= programs;
    get_program_grades(temp);
    skip_line;
    temp.qgrades := quizzes;
    get_quiz_grades(temp);
    skip_line;
    temp.tgrades:= tests;
    get_test_grades(temp);
    skip_line;
    temp.egrades:= exams;
    get_exam_grades(temp);
    if not end_of_file then
        skip_line;
    end if;
    temp.paverage := compute_program_average(temp);
    temp.qaverage := compute_quiz_average(temp);
    if temp.egrades.exam_grade /= missing_grade then
        temp.eaverage := Float(temp.egrades.exam_grade);
    else
        temp.eaverage := Float(zero);
    end if;
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
        put("Overall Average:");
        put(s(i).overall_average,3,1,0);
        new_line;
        put_line("Letter Grade: " & s(i).letter_grade'img);
        put_line("Category          Weight  Average  Points   Grades ...");
        put("Programs           " & s(i).pgrades.percent_total'img);
        put(s(i).paverage,8,1,0); 
        put(s(i).ppoints,6,1,0);
        put("   ");
        for j in 1..s(i).pgrades.num_grades loop
            if s(i).pgrades.grades_array(j) /= missing_grade then
                put(s(i).pgrades.grades_array(j)'img);
            else
                put(zero'img&"'");
            end if;
        end loop;
        new_line;
        put("Quizzes            " & s(i).qgrades.percent_total'img);
        put(s(i).qaverage,8,1,0); 
        put(s(i).qpoints,6,1,0);
        put("   ");
        for j in 1..s(i).qgrades.num_grades loop
            if s(i).qgrades.grades_array(j) /= missing_grade then
                put(s(i).qgrades.grades_array(j)'img);
            else
                put(zero'img & "'");
            end if;
        end loop;
        new_line;
        put("Tests              " & s(i).tgrades.percent_total'img);
        put(s(i).taverage,8,1,0); 
        put(s(i).tpoints,6,1,0);
        put("   ");
        for j in 1..s(i).tgrades.num_grades loop
            if s(i).tgrades.grades_array(j) /= missing_grade then
                put(s(i).tgrades.grades_array(j)'img);
            elsif s(i).egrades.exam_grade /= 101 then
                put(s(i).egrades.exam_grade'img & "'");
            else
                put(zero'img & "'");
            end if;
        end loop;
        new_line;
        put("Final Exam         " & s(i).egrades.percent_total'img);
        put(s(i).eaverage,8,1,0); 
        put(s(i).epoints,6,1,0);
        put("   ");
        if s(i).egrades.exam_grade /= missing_grade then
            put(s(i).egrades.exam_grade'img);
        else
            put(zero'img & "'");
        end if;
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
        while j >= 1 and then s(j).letter_grade > val.letter_grade loop
            s(j+1) := s(j);
            j := j-1;
        end loop;
        s(j+1) := val;
    end loop;
end insertion_sort;


--Didn't implement bubble sort. While technically stable, it did not sort correctly
--Perhaps because of my implementation of it

procedure bubble_sort(s: in out student_array; stu_count: Integer) is
    val: student;
begin
    for i in 1..stu_count loop
        for j in 1..i loop
            if s(i).letter_grade < s(j).letter_grade then
                val := s(j);
                s(j) := s(i);
                s(i) := val;
            end if;
        end loop;
    end loop;
end bubble_sort;

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