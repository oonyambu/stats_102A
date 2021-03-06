
\name{has_data}
\alias{has_data}
\title{Check whether the student created a given object}
\usage{
has_data(student_dir, data_name, mode, check = alist())
}
\arguments{
\item{student_dir}{ The directory that containts the students folders}


\item{data_name}{A character that shows the name of the object intended to be created}

\item{mode}{The mode of the object to be created. Ie the result which would be obtained if we were to run `base::mode(object)`}

\item{check}{A alist of parameters to that the object ougth to satisfy. This is given as a pair of a function and the left hans side and what it ought to satisfy on the right. Look at the examples.}
}

\value{
The function returns a dataframe with the StudentID, and whether the student created the object
}
\description{
Determine whether a student created a particular object
}

\examples{
#Assume gradebook has 150 row, 15 columns, 2 of the columns are named as 'UID' and 'Section'

# Check whether the student created a dataframe called 'gradebook'

\dontrun{has_data("../students", "gradebook", "list")}

# Check whether the student created a dataframe called 'gradebook' with atleast 150 rows

\dontrun{has_data("../students", "gradebook", "list", alist(nrow >= 150))}

# Check whether the student created a dataframe called 'gradebook' with atleast 150 rows
# must contain some specified named columns and has 15 columns

nms <- c("UID","Section")
chk <- alist(nrow >= 150, names = nms, ncol == 15)

# Note that for containing, we use a single equal sign, while for equality we use "=="
# Also note that the left hand side of the pair is a function to evaluate.
# eg ncol(gradebook)==15 is what will be computed. You can have a customed function
# on the left hand side. On the right hand is the value to be checked on

\dontrun{has_data("../students", "gradebook", "list", chk)}
}
