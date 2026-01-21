# ANALYSIS OF DATA
library(dplyr)
library(readr)

# Load data from csv
df <- read_csv("data.csv")

# Filtering data for positive values
data_filtered <- df %>% filter(x > 0)

# Grouping by category and calculating mean
result <- data_filtered %>% 
  group_by(cat) %>% 
  summarize(m = mean(val)) %>%
  arrange(desc(m))

# Print final result
print(result)

# Process data function
process <- function(data) {
  # This function processes data
  res <- data * 2
  return(res)
}
