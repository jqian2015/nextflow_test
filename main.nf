
params.input_cram = "gs://gatk-test-data/wgs_cram/NA12878_20k_hg38/NA12878.cram"
params.input_dict = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict"
params.input_fasta = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta"
params.input_fasta_index = "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai"
params.sample_name = "NA12878"
sample_name=params.sample_name

process CramToBam {

    container="us.gcr.io/broad-gatk/gatk:latest"

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
process ValidateBam {
    container 'broadinstitute/genomes-in-the-cloud:2.3.1-1500064817'

    input:
    tuple val(sample_name), path(bam), path(bai)

    output:
    path "${sample_name}.validation_report"

    script:
    def machine_mem_size = 15
    def command_mem_size = machine_mem_size - 1

    """
    java -Xmx${command_mem_size}G -jar /usr/gitc/picard.jar \
      ValidateSamFile \
      INPUT=$bam \
      OUTPUT=${sample_name}.validation_report \
      MODE=SUMMARY \
      IS_BISULFITE_SEQUENCED=false
    """
}
workflow {
    CramToBam(
        file(params.input_dict),
        file(params.input_fasta),
        file(params.input_fasta_index),
        file(params.input_cram),
        params.sample_name
    )
 ValidateBam(CramToBam.out.bam_files)
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
