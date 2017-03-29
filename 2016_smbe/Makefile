poster.pdf : poster.tex beamerthemeOrr.sty figures/gatk_tree.pdf figures/disco_tree.pdf figures/true_tree.pdf figures/both_hist.pdf
	pdflatex poster.tex

figures/gatk_tree.pdf figures/disco_tree.pdf figures/true_tree.pdf : scripts/plot_trees.R data/gatk.nwk data/discosnp.nwk
	Rscript scripts/plot_trees.R

figures/both_hist.pdf : scripts/plot_hist.R data/bowtie1_mapq_freqs.txt data/bowtie2_mapq_freqs.txt
	Rscript scripts/plot_hist.R
