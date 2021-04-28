suppressWarnings(library(optparse))

suppressWarnings(library(ggplot2))
suppressWarnings(library(reshape2))

# ============Argument Parse=============
option_list = list(
  make_option(c('-i', '--infile'), default=NULL, help='The input file.'),
  make_option(c('-o', '--outfile'), default=NULL, help='The output file.'),
  make_option(c('--title'), default='Boxplot', help='The main title[default "%default"].'),
  make_option(c('--xlab'), default='X label', help='The x axis label[default "%default"].'),
  make_option(c('--ylab'), default='Y label', help='The y axis label[default "%default"].'),
  make_option(c('--width'), default=1280, type='integer', help='The width of the picture.'),
  make_option(c('--height'), default=720, type='integer', help='The height of the picture.')
)

parser <- OptionParser(option_list=option_list, epilogue='\tContact: suqingdong@novogene.com\n')
opts <- parse_args(parser)

library(showtext)
showtext_auto()

infile <- opts$infile
outfile <- opts$outfile
title <- opts$title
xlab <- opts$xlab
ylab <- opts$ylab
width <- opts$width
height <- opts$height

if( is.null(infile)||is.null(outfile) ) {
  cat('Usage: Rscript boxplot.R -h for more help informations.\n')
  quit('no')
}



# ====================Fig boxplot and save============================
png(outfile, width=width, height=height, type='cairo')

d <- read.table(infile, sep = '\t', row.names=1, header=T)
mtd <- melt(t(d))


p <- ggplot(mtd, aes(Var2, value, fill=Var2)) + 
  geom_boxplot() +
  labs(x=xlab, y=ylab, title=title)

p + theme(
	axis.text=element_text(size=15, color='#001122'), 
	axis.title=element_text(size=20), 
	plot.title=element_text(size=30, hjust=0.5), 
	legend.title=element_blank(), 
	legend.text=element_text(size=12)
)

dev.off()
