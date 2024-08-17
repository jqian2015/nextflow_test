
params.input_cram = "gs://gatk-test-data/wgs_cram/NA12878_20k_hg38/NA12878.cram"
params.input_dict = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict"
params.input_fasta = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta"
params.input_fasta_index = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai"
params.sample_name = "NA12878"
sample_name=params.sample_name

process CramToBam2 {

    container="us.gcr.io/broad-gatk/gatk:latest"
    cpus = 2
    memory = '4 GB'

    input:
    path input_dict
    path input_fasta
    path input_fasta_index
    path input_cram
    val sample_name 
    output:
    tuple val(sample_name), path("${sample_name}.bam"), path("${sample_name}.bai"), emit: bam_files

    script:
    """
    set -eo pipefail
    samtools view -h -T ${input_fasta} ${input_cram} |
    samtools view -b -o ${sample_name}.bam -
    samtools index -b ${sample_name}.bam
    mv ${sample_name}.bam.bai ${sample_name}.bai

    """
}

workflow {
    CramToBam2(
        file(params.input_dict),
        file(params.input_fasta),
        file(params.input_fasta_index),
        file(params.input_cram),
        params.sample_name
    )
}

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}
