
\name{has_gradable_files}
\alias{has_gradable_files}
\title{Check whether a Student submitted the required files}
\usage{
has_gradable_files(student_dir, conform_Naming = NULL,
                   Rscript = TRUE, Rmd = TRUE, pdf_or_html = TRUE)
}
\arguments{

\item{student_dir}{A character string. The directory that contains student folders/files}

\item{conform_Naming}{A regex to be searched for in the names of the student files. Default is NULL}

\item{Rscript}{A logical value. Check whether the directory constains a .R file. Default is TRUE}

\item{Rmd}{A logical value. Check whether the directory constains a .Rmd file. Default is TRUE}

\item{pdf_or_html}{A logical value. Check whether the directory constains a .pdf or .html file. Default is TRUE}

}

\value{
The function returns a dataframe with id of the students column and a logical column indicating whether the student has the required files.
}
\description{
Checks whether a student submitted the required files. You can change the parameters as necessary.
}

\examples{

library(stats102A)
\dontrun{has_gradable_files("../students")}

# To check for the naming ie "987654321_stats102a_hw1"
\dontrun{has_gradable_files("../students", "^\\d{9}_stats102a_hw1\\.")}

# To check for only Rmd and pdf/html
\dontrun{has_gradable_files("../students", Rscript = FALSE)}

## End(Not run)
}
