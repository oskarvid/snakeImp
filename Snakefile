chrList = list(range(1, 23))

rule all:
  input:
    expand("/data/hapmap-2/2.0.0/m3vcfs/hapmap_r22.chr{cr}.CEU.hg19.recode.m3vcf.gz",
        cr=chrList),
    expand("/data/hapmap-2/2.0.0/legends/hapmap_r22.chr{cr}.CEU.hg19_impute.legend.gz",
        cr=chrList),
    expand("/data/hapmap-2/2.0.0/bcfs/hapmap_r22.chr{cr}.CEU.hg19.recode.bcf",
        cr=chrList),
    expand("outputs/phased.chr{cr}.vcf.gz",
    	cr=chrList),
    expand("outputs/imputed.chr{cr}.dose.vcf.gz",
        cr=chrList),
    expand("outputs/imputed.chr{cr}.empiricalDose.vcf.gz",
        cr=chrList),
    expand("outputs/imputed.chr{cr}.info",
        cr=chrList),

rule eagle:
  input:
    vcf = "/data/inputs/impute-hg19-vcf/fixed-contig-{cr}.vcf.gz",
    bcf = "/data/hapmap-2/2.0.0/bcfs/hapmap_r22.chr{cr}.CEU.hg19.recode.bcf",
    genemap = "/data/hapmap-2/2.0.0/map/genetic_map_hg19_withX.txt.gz",
  output:
    "outputs/phased.chr{cr}.vcf.gz"
  params:
    prefix="phased.chr{cr}"
  threads:
    1
  shell:
    "/imputationserver/bin/eagle \
    --vcfTarget {input.vcf} \
    --vcfRef {input.bcf} \
    --geneticMapFile {input.genemap} \
    --allowRefAltSwap \
    --outPrefix=outputs/{params.prefix} \
    --numThreads {threads} \
    --vcfOutFormat z \
    --bpStart 1 \
    --bpEnd 25000000"

rule minimac4:
  input:
    vcf = "/data/inputs/impute-hg19-vcf/fixed-contig-{cr}.vcf.gz",
    m3vcf = "/data/hapmap-2/2.0.0/m3vcfs/hapmap_r22.chr{cr}.CEU.hg19.recode.m3vcf.gz",
    genemap = "/data/hapmap-2/2.0.0/map/genetic_map_hg19_withX.txt.gz",
  output:
    "outputs/imputed.chr{cr}.dose.vcf.gz",
    "outputs/imputed.chr{cr}.empiricalDose.vcf.gz",
    "outputs/imputed.chr{cr}.info",
  params:
    prefix="imputed.chr{cr}"
  threads:
    1
  shell:
    "/imputationserver/bin/Minimac4 \
    --refHaps {input.m3vcf} \
    --haps {input.vcf} \
    --start 1 \
    --end 20000000 \
    --window 500000 \
    --prefix outputs/{params.prefix} \
    --cpus {threads} \
    --chr {wildcards.cr} \
    --noPhoneHome \
    --format GT,DS,GP \
    --allTypedSites \
    --minRatio 0.00001 \
    --meta \
    --map {input.genemap}"
