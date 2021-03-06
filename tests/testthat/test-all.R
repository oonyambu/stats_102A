
gcd <- structure(list(
  c(
    1071, 18678, 24, 30, 98, 0, 33, 432, 462,
    -3, 462, 646, 1, 0, 4.5, -1
  ),
  c(
    462, 120, 60, 24, 99, 10, 121, 1452, 1452,
    5, 1071, 1406, 10, 12, 12, 12
  )
),
row.names = 1:16L, class = "data.frame"
)

gcd_three <- structure(list(
  c(
    1071, 18678, 24, 30, 98, 0, 33, 432, 462,
    -3, 1071, 646
  ),
  c(
    462, 120, 60, 24, 99, 10, 121, 1452, 1452,
    5, 462, 1406
  ),
  c(
    42, 30, 100, 36, 77, 13, 69, 18, 54, 4,
    4452, 4218
  )
),
class = "data.frame",
row.names = 1:12L
)

is_prime <- list(100, 1298, 1:100, 9, c(2, 97, 23, 51, 119, -1, 0, 1.5))

get_factors <- list(32, 564, 100, 98, 97, 12, 1800, 32851, 9587, -280, 280.75)

test_data <- list(
  gcd = gcd,
  gcd_three = gcd_three,
  is_prime = is_prime,
  get_factors = get_factors
)
test_data <- lapply(test_data, convt2list)


students <- "D:/Work/school/102A/students"
teacher <- "D:/Work/school/102A/homeworks/987654321_stat102a_test.R"

grade_Rscripts(students, teacher, test_data,
  c(10, 10, 5, 10),
  fun_dict = list(gcd_three = c("gcd_3", "gcd3")),
  file_name = NULL
)
