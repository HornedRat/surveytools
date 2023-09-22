\name{midpoint_string}
\alias{midpoint_string}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Convert an interval to a number
}
\description{
A function that converts a description of an interval into a number
}
\usage{
midpoint_string(string)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{string}{
A text description of an interval. For example "Between 10 and 20 USD".
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A number - a mean of the two numbers mentioned in the string, or if there is only one number - its value. For example "Between 10 and 20 USD" would return 15, "100 USD or more" would return 100.
Returns NA if the string has no numbers or has more than 2 numbers
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
s <- "Between 10 and 20 USD"

# returns 15
midpoint_string(s)

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
