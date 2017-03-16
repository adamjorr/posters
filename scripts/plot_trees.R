#!usr/bin/env Rscript
#Rscript plot_trees.R

library('ape')
library('phytools')
library('dendextend')

gatk_file <- 'data/gatk.nwk'
disco_file <- 'data/discosnp.nwk'

gtree <- read.tree(gatk_file)
pdf('figures/gatk_tree.pdf',8,8)

#Fix labels
gtree$tip.label = unlist(lapply(gtree$tip.label, FUN=function(x) strsplit(x,'_')[[1]][1]))
gtree$tip.label = gsub("M2c","M3a",gtree$tip.label) #fix an oopsie
m <- regexpr("[0-9]+",gtree$tip.label)
gtree$tip.label = regmatches(gtree$tip.label,m)

gtree$edge.length<-NULL
gtree<-root(gtree,c('5','4','3','2','1'),resolve.root=TRUE)
gtree<-rotate(gtree,c('6','7'))
gtree<-rotate(gtree,c('8','6'))
gtree<-rotate(gtree,c('7','8'))
gtree<-rotate(gtree,c('1','4'))
gtree<-rotate(gtree,c('3','1'))

plot(gtree,type="cladogram",direction="upwards", no.margin = TRUE, cex = 4,,edge.width=5,srt=-90,adj=.5,label.offset=.2)
dev.off()

# pdf('figures/gatk_tree_rotated.pdf',8,8)
# plot(gtree,no.margin = TRUE, cex = 2, adj = .5, srt = -90)
# dev.off()

dtree <- read.tree(disco_file)
pdf('figures/disco_tree.pdf',8,8)
dtree$tip.label = unlist(lapply(dtree$tip.label, FUN=function(x) strsplit(x,'_')[[1]][1]))
dtree$tip.label = gsub("M2c","M3a",dtree$tip.label) #fix an oopsie
m <- regexpr("[0-9]+",dtree$tip.label)
dtree$tip.label = regmatches(dtree$tip.label,m)

dtree$edge.length<-NULL
dtree <- root(dtree,c('1','2','3','4','5'),resolve.root=TRUE)
dtree<-rotate(dtree,c('4','1'))
dtree<-rotate(dtree,c('6','7'))
dtree<-rotate(dtree,c('6','8'))
# dtree <- rotate(dtree,c('7','5'))
# dtree <- rotate(dtree,c('5','6'))
# dtree<-rotate(dtree,c('6','7'))
plot(dtree,type="cladogram",direction="upwards", no.margin = TRUE, cex =4,edge.width=5,srt=-90,adj=.5,label.offset=.2)
dev.off()

ttree <- read.tree('data/true_topology.nwk')
ttree <- rotate(ttree,c('6','7'))
ttree <- rotate(ttree,c('1','4'))
ttree <- rotate(ttree,c('1','3'))
ttree <- rotate(ttree,c('5','6'))
ttree <- rotate(ttree,c('7','8'))
pdf('figures/true_tree.pdf',8,8)
plot(ttree,type="cladogram",direction="upwards",no.margin=TRUE,cex=4,edge.width=5,srt=-90,adj=.5,label.offset=.2)
dev.off()

# gtree$edge.length<-NULL
# dtree$edge.length<-NULL
# ghc <- as.hclust(gtree)
# dhc <- as.hclust(dtree)
# gdendo <- as.dendogram(ghc)
# ddendo <- as.dendogram(dhc)
# pdf('../figures/tanglegram.pdf',8,8)
# tanglegram(gdendo,ddendo)

# dev.off()
q()
