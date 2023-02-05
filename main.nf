#! /usr/bin/env nextflow
//define channels from input file
Channel 
    .fromPath(params.inputlist)
    .ifEmpty {exit 1, "Cannot find input file : ${params.inputlist}"}
    .splitCsv(skip:1)
    .map{tumour_sample_platekey,sv, sigs -> [tumour_sample_platekey, file(sv), file(sigs)]}
    .set{ ch_input }


//run the script to make MTR input on above file paths
process  CloudOS_MTR_input{
    container = 'dockeraccountdani/fitms2:latest' 
    tag"$tumour_sample_platekey"
    publishDir "${params.outdir}/$tumour_sample_platekey", mode: 'copy'
    
    input:
    set val(tumour_sample_platekey), file(sv), file(sigs) from ch_input

    output:
    file "*_rearrangement_catalogues.pdf"
    //file "*_rearrangement_catalogue.csv"
    //file "output.txt"
    //file "*_sv_bedpe_check.csv"
    //file "exposures.tsv"
    path "rearrangement_sigs_results_vcftobedpe_pr8/*"
    
    script:
    """
    fitms_nf_rearrangements.R '$tumour_sample_platekey' '$sv' '$sigs'
    """ 
}
