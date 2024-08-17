

nextflow.enable.dsl=2

include { CramToBam; ValidateBam } from './workflows/test1.nf'
include { CramToBam2 } from './workflows/test21.nf'
include { ValidateBam2 } from './workflows/test22.nf'

// You can define or override parameters here if needed
params.input_cram = "gs://gatk-test-data/wgs_cram/NA12878_20k_hg38/NA12878.cram"
params.input_dict = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict"
params.input_fasta = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta"
params.input_fasta_index = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai"
params.sample_name = "NA12878"

workflow {
    CramToBam(
        file(params.input_dict),
        file(params.input_fasta),
        file(params.input_fasta_index),
        file(params.input_cram),
        params.sample_name
    )

    ValidateBam(CramToBam.out.bam_files)
    
    CramToBam2(
        file(params.input_dict),
        file(params.input_fasta),
        file(params.input_fasta_index),
        file(params.input_cram),
        params.sample_name
    )
    
    ValidateBam2(CramToBam2.out.bam_files)

    // If you want to view the output of ValidateBam
    // ValidateBam.out.view()
}
