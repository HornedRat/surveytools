\name{make_tab}
\alias{make_tab}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Generate a crosstab
}
\description{
A function that generates a crosstab with multiple variables in rows and an optional banner variable
}
\usage{
make_tab(df, ..., banner = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df}{
A data.frame with survey results. Assumed to be loaded from a .sav file
}
  \item{...}{
List of row variables
}
  \item{banner}{
Optional column variable
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A tibble percentage results of the row values. Banner value is optional
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

# No banner variable

make_tab(dat, FIRSTCHD, DAYOFWK, VITAL10)

# With a banner variable

make_tab(dat, FIRSTCHD, DAYOFWK, VITAL10, banner = FAMHXCVR)
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
