\name{mixedrank}
\alias{mixedrank}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Sorting strings mixed with numerals
}
\description{
Sorts a set of strings with numerals in a proper way.
For example, standard sort would result in q1, q10, q11, ..., q2, q20, q22 and so on.
Mixed sort results in q1, q2, q3, ..., q9, q10, q11...
To be used in dplyr::arrange
}
\usage{
mixedrank(x)
}
\arguments{
  \item{x}{
A column of a tibble
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns the order of the input data
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

df <- data.frame(x = c("q2", "q10", "q1", "q3", "q7", "q6", "q4", "q5", "q8", "q9"))
arrange(df, mixedrank(x))

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
