install.packages("dplyr")
library(dplyr)
install.packages("purrr")
library(purrr)
install.packages("pheatmap")
library(pheatmap)

data <-read.table(file="PAV_table_renamed_THA_MAL_MYA_samples_transposed_nonTE_131223_clean.tsv",header=TRUE, sep = "\t")
data_Malaysia <- data %>% select(-contains(c('THA', 'MYA')))
my_df_MAL <- as.data.frame(data_Malaysia)
write.csv(my_df_MAL, "nonTE_genes_MAL_samples.csv")
#remove the CV and WR samples from nonTE_genes_all_samples. keep only weedy rice samples
data_Thai <- data %>% select(-contains(c('MAL', 'MYA')))
my_df_THAI <- as.data.frame(data_Thai)
write.csv(my_df_THAI, "nonTE_genes_THA_samples.csv")
data_MYA <- data %>% select(-contains(c('THA', 'MAL')))
my_df_MYA <- as.data.frame(data_MYA)
write.csv(my_df_MYA, "nonTE_genes_MYA_samples.csv")
dt_MAL_weedy <- read.csv("nonTE_genes_MAL_samples.csv", header = TRUE, row.names = 1)
dt_MYA_weedy <- read.csv("nonTE_genes_MYA_samples.csv", header = TRUE, row.names = 1)
dt_THA_weedy <- read.csv("nonTE_genes_THA_samples.csv", header = TRUE, row.names = 1)


dt_genecount_MAL_weedy <- dt_MAL_weedy %>%
  mutate(Gene_count = rowSums(.)) %>%
  mutate(Malaysia = (Gene_count / 90) * 100)
dt_genecount_THA_weedy <- dt_THA_weedy %>%
  mutate(Gene_count = rowSums(.)) %>%
  mutate(Thailand = (Gene_count / 36) * 100)
dt_genecount_MYA_weedy <- dt_MYA_weedy %>%
  mutate(Gene_count = rowSums(.)) %>%
  mutate(Myanmar = (Gene_count / 11) * 100)
#The name of the file is misleading. The following csv actually still have THA and MYA samples. 
write.csv(dt_genecount_MAL_weedy,"dt_genecount_MAL_weedy.csv")
write.csv(dt_genecount_THA_weedy,"dt_genecount_THA_weedy.csv")
write.csv(dt_genecount_MYA_weedy,"dt_genecount_MYA_weedy.csv")

#Create input file for heatmap
MAL_gene_frequency <- dt_genecount_MAL_weedy %>% select(Malaysia)
Thai_gene_frequency <- dt_genecount_THA_weedy %>% select(Thailand)
MYA_gene_frequency <- dt_genecount_MYA_weedy %>% select(Myanmar)
MAL_gene_frequency$RowNames <- rownames(MAL_gene_frequency)
Thai_gene_frequency$RowNames <- rownames(Thai_gene_frequency)
MYA_gene_frequency$RowNames <- rownames(MYA_gene_frequency)



merged_gene_frequency <- reduce(list(MAL_gene_frequency, Thai_gene_frequency, MYA_gene_frequency), function(x, y) {
  merge(x, y, by = "RowNames", all = TRUE)
})

specific_char <- "LOC"
starts_with_char <- grepl(paste0("^", specific_char), merged_gene_frequency$RowNames)
sorted_gene_frequency <- merged_gene_frequency[order(!starts_with_char, merged_gene_frequency$RowNames), ]

#Set the row names
rownames(sorted_gene_frequency) <- sorted_gene_frequency$RowNames
sorted_gene_frequency <- sorted_gene_frequency %>% select(-RowNames)
sorted_gene_frequency_transposed <- t(sorted_gene_frequency)
sorted_gene_frequency_heatmap_input <-as.data.frame(sorted_gene_frequency_transposed)
jpeg(filename = "heatmap_PAV.jpg", width = 800, height = 600)
pheatmap(sorted_gene_frequency_transposed,
         cluster_rows = FALSE,    # Do not cluster rows, keep the order as is
         cluster_cols = FALSE,     # Cluster columns
         show_rownames = TRUE,    # Show row names
         show_colnames = FALSE,    # Show column names
         main = "PAV pattern of SEA weedy rice",
         color = colorRampPalette(c("white","violet"))(100))  # Adjust color scale as needed
dev.off()
