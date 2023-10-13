\name{get_dictionary}
\alias{get_dictionary}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Perform a proportion test
}
\description{
Performs a proportion test on a data from a table created with make_tab
}
\usage{
get_prop_test(proportions, samples, confidence)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{proportions}{
Vector of proportions
}
  \item{samples}{
Vector of samples
}
  \item{confidence}{
Confidence level
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A vector with 1 where the first value is significantly larger and 2 if the second value if significantly larger
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
todo
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
