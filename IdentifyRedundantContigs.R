dt = read.table("redundant_contigs_300323_2",header=F)

small_dt = data.frame(V2=dt$V2,V7=dt$V7)

index = which(small_dt$V2>small_dt$V7)

tmp = small_dt$V2



small_dt$V2[index]=small_dt$V7[index]

small_dt$V7[index] = tmp[index]



x=paste0(small_dt$V2,"_",small_dt$V7)

dt = data.frame(x,dt)

x=unique(x)

for(i in 1:length(x)){
  
  index = which(dt$x==x[i])
  
  tmp = dt[index,]
  
  if(nrow(tmp)>1){
    
    tmp=tmp[tmp$V4>tmp$V9,]
    
  }
  
  if(!exists("reduced_dt")){
    
    reduced_dt = tmp
    
  }else{
    
    reduced_dt = rbind(reduced_dt,tmp)
    
  }
  
}



indx = reduced_dt$x[which(reduced_dt$V4<reduced_dt$V9)]

dt[which(dt$x %in% indx),]

reduced_dt[which(reduced_dt$V4<reduced_dt$V9),]

dim(reduced_dt)

#index = match(x,dt$x)

reduced_dt = reduced_dt[,-1]

write.table(reduced_dt,"redundant_contigs_300323_wo_duplicate.txt", row.names = F, col.names = F,quote = F,sep = "\t")
