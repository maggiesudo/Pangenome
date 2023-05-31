#######################################
#### Created by Hawlader Al-Mamun #####
#######################################

install.packages("dplyr")
install.packages("stringer")
library(stringr)
library(dplyr)

dt = read.table("PAV_table_transposed.txt", header=T)


rownames(dt) = dt[,1]
dt = dt[,-1]
write.csv(dt,"df.csv")

df = read.csv("df.csv",row.names = 1)

row_sum = rowSums(df)
countries = str_sub(colnames(dt),-3,-1)


head(dt)
#create small dt for each country
# Malaysia = dt %>% select(Individual | ends_with("MAL"))
# Thailand = dt %>% select(Individual | ends_with("THA"))
# Myanmar = dt %>% select(Individual | ends_with("MYA"))

#Core gene >> look for genes that have the value '1' in Malaysia, Thailand and Myanmar
core_genes = df[which(row_sum == ncol(df)),]
dim(core_genes)
core_genes = rbind(countries,core_genes)
write.csv(core_genes,"core_genes.csv")
#Variables genes >> look for genes that have both value '1' and '0' in Malaysia, Thailand #and Myanmar
var_genes = df[which(row_sum < ncol(df)),]
dim(var_genes)
var_genes = rbind(countries,var_genes)
write.csv(var_genes,"var_genes.csv")

#Variable genes (based on location) >> look for genes that are found in one country but #not in the rest e.g. Malaysia gene1 have both '1' and '0' in samples, but '0' (completely #absent) for all samples from Thailand and #Myanmar
df_MAL = df[,which(countries=="MAL")]
df_THA = df[,which(countries=="THA")]
df_MYA = df[,which(countries=="MYA")]

row_sum_MAL = rowSums(df_MAL)
row_sum_THA = rowSums(df_THA)
row_sum_MYA = rowSums(df_MYA)

#genes present in MAL but not other
index = which(row_sum_MAL>0 & row_sum_MYA==0 & row_sum_THA==0)
length(index)              
only_MAL = df[index,]
only_MAL = rbind(countries,only_MAL)
write.csv(only_MAL,"Only_MAL.csv")

#genes present in THA but not other
index = which(row_sum_MAL==0 & row_sum_MYA==0 & row_sum_THA>0)
length(index)              
only_THA = df[index,]
only_THA = rbind(countries,only_THA)
write.csv(only_THA,"Only_THA.csv")

#genes present in THA but not other
index = which(row_sum_MAL==0 & row_sum_MYA>0 & row_sum_THA==0)
length(index)              
only_MYA = df[index,]
only_MYA = rbind(countries,only_MYA)
write.csv(only_MYA,"Only_MYA.csv")
