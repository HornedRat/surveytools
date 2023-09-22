\name{midpoints}
\alias{midpoints}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Convert a column of text intervals into numeric midpoints
}
\description{
Converts a variable with intervals (e.g. age variable with values such as '18-25', '26-35' etc.) into numeric variable by taking midpoints of each interval. Vectorization of midpoint_string function.
}
\usage{
midpoints(vector)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vector}{
A text vector with intervals ("Between 10 and 20 USD", "Between 20 and 30 USD", ...), for example a column from a dataset.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A vector converted into numerics
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
string_vector <- c("Between 10 and 20 people", "Between 1 and 10 people", "Between 21 and 30 people")
df <- data.frame(a = 1:3, b = string_vector)

df \%>\%
    mutate(b_num = midpoints(b))

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
