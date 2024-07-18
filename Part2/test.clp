(deftemplate student
    (slot name)
    (slot id)
    (slot grade)
    (slot gpa))

(deffacts student-facts
    (student (name "John Doe") (id 1) (grade 9) (gpa 3.5))
    (student (name "Jane Doe") (id 2) (grade 10) (gpa 3.7))
    (student (name "Mary Smith") (id 3) (grade 11) (gpa 3.9))
    (student (name "Peter Jones") (id 4) (grade 12) (gpa 4.0)))

(defrule print-students-with-same-name
    ?input <- (read name)
    (student (name ?name&:(eq ?name ?input)))
    =>
    (printout t "Students with the same name are: " crlf)
    (printout t ?name crlf))
