version 1.0

workflow CalculateStudentGPA {
    meta {
        description: "Calculate the GPA (average) for a student and get first line of submitted essay."
    }

    input {
        Array[Float]    subject_scores
        File            essay_file
    }

    call CalculateAverage {
        input:
            scores  =   subject_scores
    }

    call WriteReportFile {
        input:
            essay   = essay_file,
            gpa     = CalculateAverage.average
    }

    output {
        Float gpa   = CalculateAverage.average
        File report = WriteReportFile.report     
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