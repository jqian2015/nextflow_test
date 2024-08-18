
# Nextflow CRAM to BAM Workflow

This Nextflow workflow converts a CRAM file to BAM and validates the resulting BAM file.

## Prerequisites

- Nextflow (21.04.0 or later)
- allofus config

## Usage, 

How to run it in the ALLOFUS workbench, without using extra -profile

```bash
nextflow run jqian2015/nextflow_test -r test221 -c ~/.nextflow/config -profile gls -with-report execution_report_test221.html 
