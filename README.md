# Snakemake-project

  A project in transcriptomics. 
  
  Pre-requirements:
  fastqc
  multiqc
  bbduk (compiled in tools/ folder)
  STAR
  featureCounts
  
  Run:
  The workflow runs with the command "snakemake --core 1"
  
  Outputs:
  Final output files are counts_collibri.txt and counts_kapa.txt in the main folder.
  
  Remarks:
  External scripts utilize absolute path for the input files, so it needs to be changed to be run on another system.
