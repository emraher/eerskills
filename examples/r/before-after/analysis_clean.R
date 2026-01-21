library(dplyr)
library(readr)

# Load and validate data
customer_data <- readr::read_csv("data/customers.csv", col_types = "cicd")

# Analyze high-value segments
segment_summary <- customer_data |>
  dplyr::filter(revenue > 0) |>
  dplyr::group_by(category) |>
  dplyr::summarize(
    mean_revenue = mean(revenue, na.rm = TRUE),
    customer_count = dplyr::n()
  ) |>
  dplyr::arrange(dplyr::desc(mean_revenue))

print(segment_summary)

#' Calculate Total with Bonus
#'
#' @param base_amount Numeric value
#' @param bonus_amount Numeric value
#' @return Total amount
calculate_total <- function(base_amount, bonus_amount) {
  total <- base_amount + bonus_amount
  return(total)
}
