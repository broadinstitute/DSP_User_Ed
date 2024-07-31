version 1.0

workflow CalculateStudentGPA {
    meta {
        description: "Calculate the GPA (average) for a student and get first line of submitted essay."
    }

    input {
        Float   math_score
        Float   language_score
        Float   science_score
        Int     num_scores
        File    essay_file
    }

    call CalculateAverage {
        input:
            math_score      = math_score,
            language_score  = language_score,
            science_score   = science_score,
            num_scores      = num_scores
    }

    call WriteReportFile {
        input:
            essay           = essay_file,
            gpa             = CalculateAverage.average
    }

    output {
        Float   gpa = CalculateAverage.average
        File    report = WriteReportFile.report
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

task WriteReportFile {
    input {
        File    essay
        Float   gpa
    }

    command {
        
        echo -e "Total GPA:" > report.txt
        echo -e "~{gpa}" >> report.txt
        echo "Essay Title:" >> report.txt
        head -1 ~{essay} >> report.txt
    }

    runtime {
        docker: "broadinstitute/horsefish"
    }

    output {
        File    report = "report.txt"
    }
}