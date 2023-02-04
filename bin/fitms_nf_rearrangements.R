#!/usr/local/bin/Rscript
library(VariantAnnotation)
library(signature.tools.lib)
args = commandArgs(trailingOnly=TRUE)
sample <- args[1]
sv <- args[2]
sigs <-args[3]

sigs <- read.csv(sigs)

##read in the bedpe file
df <- read.csv(sv)
rownames(df) <- df$X
df$X <- NULL

plotRearrSignatures(df,output_file = paste0(sample, "_rearrangement_catalogues.pdf"))


organ = "Breast"
genome.v  ="hg38"

res <-Fit(catalogues = df, 
          signatures = sigs,
          useBootstrap = TRUE, 
          nboot = 200)


#write.csv(res$exposures, 'exposures.tsv', sep='\t')
plotFit(res, 'rearrangement_sigs_results_vcftobedpe_pr8/')
