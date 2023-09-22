\name{write_tab}
\alias{write_tab}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
A function to write crosstabs into a xlsx file
}
\description{
Writes and nicely formats multiple crosstabs (from make_tab()) into an Excel file
}
\usage{
write_tab(tabs, filename)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{tabs}{
A LIST of tables to be written
}
  \item{filename}{
A string specifing the name of the output file
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Jakub Wiatrak
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
(sav <- system.file("files", "electric.sav", package = "foreign"))
dat <- read.spss(file=sav, to.data.frame = TRUE)

# With a banner variable

tab1 <- make_tab(dat, FIRSTCHD, banner = FAMHXCVR)
tab2 <- make_tab(dat, DAYOFWK, VITAL10, banner = FAMHXCVR)

write_tab(tabs = list(tab1, tab2), "tabs.xlsx")

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
