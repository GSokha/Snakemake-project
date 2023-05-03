import subprocess
import os
data = snakemake.input.out_bam

collibri_files = []
kapa_files = []

for files in data:
    if files.startswith('Collibri'):
        collibri_files.append(files)
    elif files.startswith('KAPA'):
        kapa_files.append(files)

# Join all Collibri file names with a space separator
collibri_files_str = " ".join(collibri_files)
kapa_files_str = " ".join(kapa_files)

# Run featureCounts on all Collibri files simultaneously
subprocess.run("featureCounts -p -t exon -g gene_id -a /home/quantori/snake/data/play_data_ref_annot/chr19_20Mb.gtf -o counts_collibri.txt {collibri_files_str} -s 1 ".format(collibri_files_str=collibri_files_str),shell=True)

subprocess.run("featureCounts -p -t exon -g gene_id -a /home/quantori/snake/data/play_data_ref_annot/chr19_20Mb.gtf -o counts_kapa.txt {kapa_files_str} -s 2 ".format(kapa_files_str=kapa_files_str),shell=True)
