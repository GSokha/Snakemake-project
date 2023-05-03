configfile: "inputs.json"

rule all:
    input:
        multiqc_html="multiqc/multiqc_report.html",
        out=expand("trimmed_read/{sample}.fastq", sample=config["samples"]),
        html_trimmed=expand("trimmed_fastqc/{sample}_fastqc.html", sample=config['samples']),
        zip_trimmed=expand("trimmed_fastqc/{sample}_fastqc.zip", sample=config['samples']),
        trimmed_multiqc_html="multiqc_trimmed/multiqc_report.html",
        indeces="index/Genome",
        out_bam=expand("{sample}.Aligned.sortedByCoord.out.bam", sample=config["out_star"]),
        out_index_bam=expand("{sample}.Aligned.sortedByCoord.out.bam.bai", sample=config["out_star"]),
        collibri_out_counts="counts_collibri.txt",
        kappa_out_counts="counts_kapa.txt",
        bam_folder=directory("bam_folder/")

rule fastqc:
    input:
        "data/{sample}.fastq.gz"
    output:
        html="results/{sample}_fastqc.html",
        zip="results/{sample}_fastqc.zip"
    shell:
        "fastqc data/{wildcards.sample}.fastq.gz -o results/"

rule multiqc:
    input:
        zip_qc=expand("results/{sample}_fastqc.zip", sample=config["samples"])
    output:
        multiqc_html="multiqc/multiqc_report.html",
        
    shell:
        "multiqc {input.zip_qc} -s -f -o multiqc/"


rule trim:
    input:
        original = expand("data/{sample}.fastq.gz",sample=config["samples"])
    output:
        out="trimmed_read/{sample}.fastq"

    script:
        "tools/trimming.py"

rule fastqc_trimmed:
    input:
        trimmed_fa="trimmed_read/{sample}.fastq"
    output:
        html="trimmed_fastqc/{sample}_fastqc.html",
        zip="trimmed_fastqc/{sample}_fastqc.zip"
    shell:
        "fastqc trimmed_read/{wildcards.sample}.fastq -o trimmed_fastqc/"

rule multiqc_trimmed:
    input:
        trimmed_fa=expand("trimmed_fastqc/{sample}_fastqc.zip", sample=config["samples"])
    output:
        trimmed_multiqc_html="multiqc_trimmed/multiqc_report.html",
        
    shell:
        "multiqc {input.trimmed_fa} -s -f -o multiqc_trimmed/"

rule star_align_index:
    input:
        fasta="data/play_data_ref_annot/chr19_20Mb.fa",
        gtf="data/play_data_ref_annot/chr19_20Mb.gtf"
    output:
        indeces="index/Genome"
    shell:
        "STAR --runMode genomeGenerate --genomeDir index --genomeFastaFiles {input.fasta} --sjdbGTFfile {input.gtf} --genomeSAindexNbases 11"

rule star_align:
    input:
        trimmed=expand("trimmed_read/{sample}.fastq", sample=config["samples"]),
    output:
        out_bam="{sample}.Aligned.sortedByCoord.out.bam"

    script:
        "star_align.py"

rule bam_index:
    input:
        out_bam=expand("{sample}.Aligned.sortedByCoord.out.bam", sample=config["out_star"])
    output:
        out_index_bam="{sample}.Aligned.sortedByCoord.out.bam.bai"
    script:
        "tools/index.py"

rule counts:
    input:
        out_bam=expand("{sample}.Aligned.sortedByCoord.out.bam", sample=config["out_star"])
    output:
        collibri_out_counts="counts_collibri.txt",
        kappa_out_counts="counts_kapa.txt"
    script:
        "tools/counts.py"

rule clean:
    input:
        out_bam=expand("{sample}.Aligned.sortedByCoord.out.bam", sample=config["out_star"]),
        out_index_bam=expand("{sample}.Aligned.sortedByCoord.out.bam.bai", sample=config["out_star"])

    output:
        bam_folder=directory("bam_folder/")
    shell:
        "mkdir bam_folder | mv {input.out_bam} bam_folder/ | mv *.out bam_folder/ | mv *.SJ.out.tab bam_folder/ | mv *.bai bam_folder/ "
