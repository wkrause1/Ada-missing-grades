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
    grades_array: grades;
    percent_total: Natural;
end record;
type test_grades is record
    num_grades: Natural;
    grades_array: grades;
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
end make_records;


begin
null;
end missing_scores;


