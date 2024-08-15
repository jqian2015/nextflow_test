

include { test1 } from './workflows/test1.nf'
include { test2 } from './workflows/test2.nf'



workflow  {
    test1(
        params.input_dict,
        params.input_fasta,
        params.input_fasta_index,
        params.input_cram,
        params.sample_name
    )
    test2(params.input_dict,
        params.input_fasta,
        params.input_fasta_index,
        params.input_cram,
        params.sample_name)
}
