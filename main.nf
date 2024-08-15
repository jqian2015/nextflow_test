
manifest {
    name = 'nextflow_test'
    version = '1.0.0'
}

// Misc Parameters
params.COHORT = "AOU"

// CUSTOM
params.STUDY_DESIGN = "CUSTOM"



include { test1 } from './workflows/test1.nf'
include { test2 } from './workflows/test2.nf'

log.info """\
         ${workflow.manifest.name} v${workflow.manifest.version}
         ==========================
         Cohort Type  : ${params.COHORT}
         Study Design : ${params.STUDY_DESIGN}
         
         ==========================
         """
         .stripIndent()


workflow  {
    nextflow_test()
}
