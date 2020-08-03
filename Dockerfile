FROM snakemake/snakemake

ADD imputationserver/ /imputationserver

RUN apt-get update && apt-get install -y libgomp1