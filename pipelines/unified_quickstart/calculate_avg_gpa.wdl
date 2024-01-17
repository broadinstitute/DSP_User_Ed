version 1.0

workflow CalculateStudentGPA {
    meta {
        description: "Calculate the GPA (average) for a student."
    }

    input {
        Float   math_score
        Float   language_score
        Float   science_score
        Int     num_scores
    }

    call CalculateAverage {
        input:
            math_score      = math_score,
            language_score  = language_score,
            science_score   = science_score,
            num_scores      = num_scores
    }

    output {
        Float   gpa = CalculateAverage.average
    }
}

task CalculateAverage {
    input {
        Float   math_score
        Float   language_score
        Float   science_score
        Int     num_scores
    }

    command <<<
        python -c "print((~{math_score} + ~{language_score} + ~{science_score})/~{num_scores})"

    >>>
    

    runtime {
        docker: "broadinstitute/horsefish"
    }

    output {
        Float average = read_float(stdout())
    }
}
