version 1.0

workflow CalculateStudentGPA {
    meta {
        description: "Calculate the GPA (average) for a student."
    }

    input {
        Array[Float]    subject_scores
    }

    call CalculateAverage {
        input:
            scores  =   subject_scores
    }

    output {
        Float gpa   = CalculateAverage.average  
    }
}

task CalculateAverage {
    input {
        Array[Float]   scores
    }
    Int num_scores = length(scores)

    command <<<
        python -c "print((~{sep="+" scores})/~{num_scores})"

    >>>
    

    runtime {
        docker: "broadinstitute/horsefish"
    }

    output {
        Float average = read_float(stdout())
    }
}