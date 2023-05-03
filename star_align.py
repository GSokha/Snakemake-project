import subprocess
import os
def pair_reads(*args):
    pairs = {}
    for sample in args:
        if '_R1_' in sample:
            prefix1 = sample.split("_R1_")[0]
        else:
            prefix1 = sample.split("_R2_")[0]
        read1 = prefix1 + "_R1_001.fastq"
        read2 = prefix1 + "_R2_001.fastq"
        pairs[read1] = read2
    return pairs

pairs =  pair_reads(*snakemake.input.trimmed)

for read1, read2 in pairs.items():
    basename1 = os.path.basename(read1)
    basename2 = os.path.basename(read2)
    outputs1=os.path.splitext(basename1)[0] + '.'
    outputs2 = os.path.splitext(basename1)[0] + '.'
    subprocess.run("bash STAR --genomeDir /home/quantori/snake/index/ --readFilesIn /home/quantori/snake/trimmed_read/{out} /home/quantori/snake/trimmed_read/{out2} --outFileNamePrefix /home/quantori/snake/{outputs} --outSAMtype BAM SortedByCoordinate".format(out=basename1, out2=basename2, outputs=outputs1),shell=True)

