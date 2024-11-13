#!/usr/bin/env nextflow

params.target = "World!"

process helloWorld {
  input:
    val target
  output:
    stdout

  """
  /bin/echo Hello "$target"
  """
}

workflow {
  helloWorld(params.target)
    | view
}