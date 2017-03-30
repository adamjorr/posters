#!usr/bin/Rscript
#Rscript plot_hist.R bowtie_1_mapq_freqs.txt
library('ggplot2')
library('reshape')
library('RColorBrewer')

file1 <- "data/bowtie1_mapq_freqs.txt"
file2 <- "data/bowtie2_mapq_freqs.txt"
file3 <- "data/bt2_bwa_mapq.txt"
file4 <- "data/bt2_ngm_mapq.txt"


#plot E. grandis mapping
f1 <- read.table(file1)
f1 <- f1[order(f1$V1),]
pdf(file='figures/generated/bowtie1_hist.pdf',16,8)
ggplot(data=f1, aes(x=V1,y=V2)) +
	geom_bar(stat="identity") +
	xlab("Mapping Quality Score") +
	ylab("Number of Reads") +
	ggtitle(expression(paste("Quality of Reads Mapped"))) +
	theme(title=element_text(size=32),
		  text=element_text(size=24),
		  axis.title.y=element_text(margin=margin(0,48,0,0)),
		  axis.title.x=element_text(margin=margin(24,0,4,0)),
		  legend.key=element_rect(size=2),
		  legend.key.size = unit(2, 'lines')
		  )
dev.off()

#plot E. melliodora 1 mapping
f2 <- read.table(file2)
f2 <- f2[order(f2$V1),]
pdf(file='figures/generated/bowtie2_hist.pdf',8,8)
ggplot(data=f2, aes(x=V1,y=V2)) +
	geom_bar(stat="identity") +
	xlab("Mapping Quality Score") +
	ylab("Number of Reads") +
	ggtitle("Quality of Reads Mapped to E. melliodora 1")
dev.off()

#Both on the same plot
pdf(file='figures/generated/both_hist.pdf',16,8)
f3 <- merge(f1,f2,by="V1")
names(f3) <- c("quality","grandis","melliodora")
f4 <- melt(f3,id.vars="quality",measure.vars=c("grandis","melliodora"))
ggplot(data=f4,aes(x=quality,y=value,fill=variable)) +
	geom_bar(stat="identity",position=position_dodge()) +
	scale_fill_brewer(guide = guide_legend(title="Reference"),
		labels=c("E. grandis","E. melliodora"),
		type="qual",palette="Dark2") +
	xlab("Mapping Quality Score") +
	ylab("Number of Reads") +
	ggtitle("Comparison of Read Mapping Quality") +
	theme(title=element_text(size=36,vjust=1),
		  text=element_text(size=24),
		  axis.title.y=element_text(margin=margin(0,48,0,0)),
		  axis.title.x=element_text(margin=margin(24,0,4,0)),
		  legend.key=element_rect(size=2),
		  legend.key.size = unit(2, 'lines')
		  )
dev.off()

#Compare BWA and NGM
pdf(file='figures/generated/aligner_comparison_hist.pdf',16,8)
f5 <- read.table(file3)
f5 <- f5[order(f5$V1),]
f6 <- read.table(file4)
f6 <- f6[order(f6$V1),]
f7 <- merge(f5,f6,by="V1")
names(f7) <- c("quality","bwa","ngm")
f8 <- melt(f7,id.vars="quality",measure.vars=c("bwa","ngm"))
ggplot(data=f8,aes(x=quality,y=value,fill=variable)) +
	geom_bar(stat="identity",position=position_dodge()) +
	scale_fill_brewer(guide = guide_legend(title="Aligner"),
		labels=c("BWA","NextGenMap"),
		type="qual",palette="Dark2") +
	xlab("Mapping Quality Score") +
	ylab("Number of Reads") +
	ggtitle("Comparison of Read Mapping Quality") +
	theme(title=element_text(size=36,vjust=1),
		  text=element_text(size=24),
		  axis.title.y=element_text(margin=margin(0,48,0,0)),
		  axis.title.x=element_text(margin=margin(24,0,4,0)),
		  legend.key=element_rect(size=2),
		  legend.key.size = unit(2, 'lines')
		  )
dev.off()

q()
