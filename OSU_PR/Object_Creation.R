library(Seurat)
library(dplyr)
library(ggplot2)
library(data.table)
library(SCNPrep)
library(RJSONIO)
library(readr)
library(harmony)
library(stringi)
library(harmony)
#library(argparse)

args <- commandArgs(trailingOnly = T)
input.obj <- args[1]
token <- "OSU_PR_cwjwu2"
outdir <- args[2]
load(input.obj)



whole@meta.data <- whole@meta.data %>%
  mutate_if(is.character, as.factor)
# Add markers as a list with names as resolutions
markers <- lapply(seq(0.1,1,0.2),function(x){
  #Note: you can directly use the column name and skip retrieving the variable
  Idents(whole) <- paste0("RNA","_snn_res.",x)
  #lapply cannot assign names inside the function, but you can either pass a named input or name the output outside lapply
  marker <- FindAllMarkers(whole, only.pos=T)
  marker$cluster <- as.character(marker$cluster)
  marker
})
names(markers) <- paste0("res.",seq(0.1,1,0.2))

migrateSeuratObject(whole,
	            assay="RNA",
                    species="mm",
                    outdir = outdir,
                    public = F,
		    curated = F,
		    slot = 'counts',
		    marker = markers,
                    generateMarkers = F,
		    generateGMTS = F,
    		    name='OSU_PR_glioma',
                    token=token,
		    link='',
                    description = '')
file.rename(from = file.path(res.fld,"dataset.json"),to = file.path(res.fld,"zzzz.json"))
