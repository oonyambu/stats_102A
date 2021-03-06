
\name{convt2list}
\alias{convt2list}
\title{convert a dataframe to a list of arguments}
\usage{
convt2list(dat,keep_par_names = FALSE)
}
\arguments{


\item{dat}{A dataframe that contains the test cases, where each row is one test case.}

\item{keep_par_names}{ A logical parameter that is used to determine whether the parameter names in the test data and the functions are the same. Default is FALSE}
}

\value{
The function returns a list of lists containing the argiuments to be tested on.
}
\description{
convert each row of a dataframe to a list of arguments.
}

\examples{

(mult_data <- data.frame(x = c(10,-3,2),y = c(20,2,-3),z = c(30,1,2)))
(convt2list(mult_data))
(convt2list(mult_data, TRUE))
}
