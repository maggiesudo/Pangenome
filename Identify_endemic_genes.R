
install.packages("dplyr")
install.packages("stringer")
library(stringr)
library(dplyr)

#Column =genes, rows = Samples. Fist row of PAV data are sample names, second row is the rice type e.g. weedy, cultivar or wild.  
df_rice_type = read.csv("data.csv",row.names = 1)
rice_type = df_rice_type[1,]

df_rice_type = df_rice_type[-1,]
write.csv(df_rice_type,"df_rice_type.csv")
df_rice_type = read.csv("df_rice_type.csv", header=T)
rownames(df_rice_type) = df_rice_type[,1]
df_rice_type = df_rice_type[,-1]

df_Weedy = df_rice_type[,which(rice_type=="WEEDY")]
df_Wild = df_rice_type[,which(rice_type=="WILD")]
df_Cul = df_rice_type[,which(rice_type=="CUL")]
#df_Cul = df_Cul[-1,]
#df_Weedy = df_Weedy[-1,]
#df_Wild = df_Wild[-1,]


#To save the data for every rice type 
write.csv(df_Weedy,"df_weedy.csv")
write.csv(df_Wild,"df_wild.csv")
write.csv(df_Cul,"df_cul.csv")

#Read them into R again
dt_Weedy = read.csv("df_weedy.csv",row.names = 1)
dt_Wild = read.csv("df_wild.csv",row.names = 1)
dt_Cul = read.csv("df_cul.csv",row.names = 1)

#Row sum of each gene 
row_sum_WEEDY = rowSums(dt_Weedy)
row_sum_WILD = rowSums(dt_Wild)
row_sum_CUL = rowSums(dt_Cul)

#genes present in Weedy but not other
index = which(row_sum_WEEDY>0 & row_sum_WILD==0 & row_sum_CUL==0)
length(index)              
only_Weedy = df_rice_type[index,]
only_Weedy = rbind(rice_type, only_Weedy)
write.csv(only_Weedy,"Only_weedy.csv")

#genes present in Cultivar but not other
index = which(row_sum_WEEDY==0 & row_sum_WILD==0 & row_sum_CUL>0)
length(index)              
only_Cul = df_rice_type[index,]
only_Cul = rbind(rice_type, only_Cul)
write.csv(only_Cul,"Only_cul.csv")

#genes present in Wild but not other
index = which(row_sum_WILD>0 & row_sum_WEEDY==0 & row_sum_CUL==0)
length(index)              
only_Wild = df_rice_type[index,]
only_Wild = rbind(rice_type, only_Wild)
write.csv(only_Wild,"Only_wild.csv")


