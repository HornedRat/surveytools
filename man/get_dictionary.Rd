\name{get_dictionary}
\alias{get_dictionary}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get dictionary of variable labels
}
\description{
Function that takes a dataset and returns a dictionary, mapping variable names to question labels. The dataset has to come from foreign::read.spss
}
\usage{
get_dictionary(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
A data.frame, read by foreign::read.sav function
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A data frame listing the variable names and the corresponding labels
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

get_dictionary(dat)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
