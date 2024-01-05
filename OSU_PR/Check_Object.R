library(Matrix)
library(Seurat)
library(ggplot2)
library(tidyverse)
library(gridExtra)

args <- commandArgs(trailingOnly=T)
scn_path <- args[1]
outdir <- args[2]

result <- jsonlite::fromJSON(file.path(scn_path,"exp_data.json"))
total_counts <- result$totalCounts
data_ <- rhdf5::h5read(file.path(scn_path,"data.h5"),"X")
dims_ <- rhdf5::h5readAttributes(file = file.path(scn_path,"data.h5"), 
                                 name = "X")$shape
expData <- Matrix::sparseMatrix(p = data_$indptr, j = data_$indices, 
                                x = as.numeric(data_$data), 
                                dimnames = list(result$features, result$barcodes),
                                dims=c(dims_[2],dims_[1]), repr="R", index1=FALSE)
plotData <- (jsonlite::fromJSON(file.path(scn_path,"plot_data.json"))$data) %>% 
  as.data.frame

dimreduction <- plotData[, c(1,2)]
seurat_obj = CreateSeuratObject(expData, meta.data = plotData)
seurat_obj[['umap']] =CreateDimReducObject(embeddings = as.matrix(dimreduction), 
                                           key = "UMAP_", 
                                           assay = DefaultAssay(seurat_obj))
head(seurat_obj@meta.data)
avg.exp <- AverageExpression(seurat_obj,group.by= "Cluster",return.seurat=T)

markers <- c("Gpr34","P2ry12","Ccl3","Ccl4","Dab2","Mrc1","Gpnmb","Axl","Ifitm2","Igitm3","Ly6c1","Cd3e","Cd4","Tnfrsf4","Cd8a","Ncr1","Cd79a","Camp","Alas2","Gp1bb") 

gobs <- lapply(markers, function(i){
  DoHeatmap(avg.exp,features = i,size=3.5,draw.lines = F,angle = 90)+NoLegend()+ scale_fill_gradientn(colors = c("blue", "white", "red"))
})
g <- grid.arrange(grobs = gobs, ncol = 2)
ggsave(filename = paste0(outdir,"/AVGEXP_OSU.pdf"),plot = g,height = 60,width = 40,units = "cm")


g <- FeaturePlot(seurat_obj,features = c("Gpr34","P2ry12"),reduction = "umap")
ggsave(filename = paste0(outdir,"/Check_Object_OSU.pdf"),plot = g,height = 30,width = 40,units = "cm")
