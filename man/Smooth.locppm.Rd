\name{Smooth.locppm}
\alias{Smooth.locppm}
\title{
  Smooth a locally fitted Gibbs model
}
\description{
  Applies kernel smoothing to one of the components of a locally-fitted
  Gibbs point process model.
}
\usage{
\method{Smooth}{locppm}(X, ..., what = "cg")
}
\arguments{
  \item{X}{
    A locally-fitted  Gibbs point process model (object of class
    \code{"locppm"}). 
  }
  \item{\dots}{
    Arguments passed to \code{\link[spatstat.explore]{Smooth.ppp}}
    to control the smoothing.
  }
  \item{what}{
    Component to be smoothed. A character string.
    The default is to smooth the fitted coefficient vectors.
  }
}
\details{
  This function extracts the selected quantity from the fitted object
  and spatially smooths it using \code{\link[spatstat.explore]{Smooth.ppp}}.
  The result is a pixel image or a list of pixel images.
}
\value{
  A pixel image or a list of pixel images.
}
\references{
  \localpaper

  \baddrubaturnbook
}
\author{
  \adrian.
}
\seealso{
  \code{\link{locppm}},
  \code{\link[spatstat.explore]{Smooth.ppp}}
}
\examples{
  fit <- locppm(cells, sigma=0.1, use.fft=TRUE)
  plot(Smooth(fit))
}
\keyword{spatial}
\keyword{models}
\keyword{smooth}

