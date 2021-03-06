
\name{test_function}
\alias{test_function}
\title{evaluate Correctness of a function}
\usage{
test_function(test_dat ,studentFUN ,correctFUN)
}
\arguments{


\item{test_dat}{A dataframe that contains the test cases, where each row is one test case.}

\item{studentFUN}{The function to be tested}

\item{correctFUN}{ Function to be tested against}

}

\value{
The function returns a list of lists containing the argiuments to be tested on.
}
\description{
convert each row of a dataframe to a list of arguments.
}

\examples{
test1 <- function(x,y)x
test2 <- function(x,y) y + x
correct <- function(a,b) a + b
add_data <- list(list(10,20),list(0,-3))
(test_function(add_data, test1, correct))
(test_function(add_data, test2, correct))
}
