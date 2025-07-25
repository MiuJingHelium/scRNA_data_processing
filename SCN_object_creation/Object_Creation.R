library(Seurat)
library(dplyr)
library(ggplot2)
library(data.table)
library(SCNPrep)
library(RJSONIO)
library(readr)
#library(harmony)
library(stringi)
library(harmony)
#library(argparse)

args <- commandArgs(trailingOnly = T)

outdir <- args[1]
token <- args[2]
obj_name <- args[3]
input.obj <- args[4]


dat <- readRDS(input.obj)

# if counts are transformed using soupx, then rounding is needed.

dat@assays$RNA@layers$counts <-  ceiling(dat@assays$RNA@layers$counts) 
# dat <- JoinLayers(dat)
dat@meta.data <- dat@meta.data %>%
  mutate_if(is.character, as.factor) %>%
  dplyr::rename(
    Cluster_annotation = annotation
  )

# Add markers as a list with names as resolutions
# #annotations <- c("Cluster_celltype")
markers <- lapply(seq(0.1,1,0.1),function(x){
  #Note: you can directly use the column name and skip retrieving the variable
  Idents(dat) <- paste0("RNA","_snn_res.",x)
  #lapply cannot assign names inside the function, but you can either pass a named input or name the output outside lapply
  marker <- FindAllMarkers(dat, only.pos=T)
  marker$cluster <- as.character(marker$cluster)
  write.table(marker,
              paste0(token,"_resolution_",x,"_markers.tsv"),
              sep="\t",
              quote=F,
              row.names=F)
  marker
})
names(markers) <- paste0("res.",seq(0.1,1,0.1))

 Idents(dat) <- "Cluster_annotation"
 marker <- FindAllMarkers(dat, only.pos=T)
 marker$cluster <- as.character(marker$cluster)
write.table(marker,
            paste0(token,"_annotation_markers.tsv"),
            sep="\t",
            quote=F,
            row.names=F)
markers[["annotation"]] <- marker
  

migrateSeuratObject(dat,
	            assay="RNA",
                    species="hs",
                    outdir = outdir,
                    public = F,
		    curated = F,
		    slot = 'counts',
		    marker = markers,
                    generateMarkers = F,
		    generateGMTS = F,
    		    name=obj_name,
                    token=token,
		    link='',
                    description = '')
file.rename(from = file.path(outdir,"dataset.json"),to = file.path(outdir,"zzzz.json"))
