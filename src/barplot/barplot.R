suppressWarnings(library(optparse))
suppressWarnings(library(ggplot2))
suppressWarnings(library(reshape2))


option_list = list(
  make_option(c('-i', '--infile'), default=NULL, help='The input file.'),
  make_option(c('-o', '--outfile'), default=NULL, help='The output file.'),
  make_option(c('--title'), default='', help='The title of the picture.'),
  make_option(c('--xlab'), default='', help='The xlab of the picture.'),
  make_option(c('--ylab'), default='', help='The ylab of the picture.'),
  make_option(c('--width'), default=1280, type='integer', help='The width of the picture.'),
  make_option(c('--height'), default=720, type='integer', help='The height of the picture.'),
  make_option(c('--position'), default='stack', help='The position of bar["stack", "dodge" default="%default"]'),
  make_option(c('--percent'), action='store_true', default=FALSE, help='show Y lab in percent mode[default "%default"].')
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
position <- opts$position
percent <- opts$percent


if ( is.null(infile) || is.null(outfile) ) {
  cat('Usage: Rscript piechart.R -h for more help infomation\n')
  quit('no')
}

library(ggplot2)
library(ggthemes)
library(reshape2)
 
# d <- read.table(infile, header = T, row.names = 1)

d <- try( read.table(infile, header = T, row.names = 1), silent=T)
if ( 'try-error' %in% class(d) ) {
  d <- read.table(infile, header = T, row.names = 1, fileEncoding='GBK')
}


mtd <- melt(t(d))
 
png(outfile, type = 'cairo', width = width, height = height)
 
p <- ggplot(mtd, aes(Var2, value, fill = Var1)) +
  geom_bar(stat = 'identity', position = position) +
  theme_excel_new() + scale_fill_excel_new() + scale_color_excel_new() +
  labs(x = xlab, y = ylab, title = title)

p <- p + theme(
  plot.title = element_text(size=14, hjust=0.5),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  legend.title = element_blank()
)

if ( percent ) {
  p <- p + scale_y_continuous(labels = scales::percent)
}

p

dev.off()
