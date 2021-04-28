suppressWarnings(library(optparse))
suppressWarnings(library(VennDiagram))


option_list <- list(
  make_option(c('-i', '--infile'), dest='infile', default=NULL, help='The input file.'),
  make_option(c('-o', '--outfile'), dest='outfile', default=NULL, help='The output file.'),
  make_option(c('--height'), dest='height', type='integer', default=1000, help='The height of image[default=%default].'),
  make_option(c('--width'), dest='width', type='integer', default=1000, help='The width of image[default=%default].'),
  make_option(c('--main'), dest='main', default='', help='The main title of image[default="%default"].')
)

parser <- OptionParser(option_list, usage="Rscript %prog [Options]")
opts <- parse_args(parser)

library(showtext)
showtext_auto()

infile <- opts$infile
outfile <- opts$outfile
height <- opts$height
width <- opts$width
main <- opts$main

options(bitmapType = 'cairo')

if ( is.null(infile) || is.null(outfile) ) {
  cat('Usage: Rscript venn.R -h for more help information.\n')
  quit()
}


data <- read.table(infile, header=T, sep='\t', na.strings='', fileEncoding='UTF-8')

venn.diagram(
  x = as.list(data), 
  na = 'remove',
  filename = outfile,
  imagetype = 'png',
  height = height,
  width = width,
  fill = rainbow(length(data)), 
  cex = 0.5,
  col ="transparent",
  alpha = 0.5,
  margin = 0.1,
  resolution = 300,
  cat.cex = 0.6,
  cat.col = rainbow(length(data)),
  main = main
)
