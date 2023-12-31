% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codecat.R
\name{codebook}
\alias{codebook}
\title{Define a codebook for a collection of variables}
\usage{
codebook(...)
}
\arguments{
\item{...}{One or more data coding schemes}
}
\value{
A list of tibbles
}
\description{
Define a codebook for a collection of variables
}
\examples{
codebook(
  code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
  code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
)
}
