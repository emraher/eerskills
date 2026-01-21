# Load the library
library(dplyr)
library(readr)

# Read the data
df <- read_csv("data.csv")

# Filter the data
df1 <- df %>% filter(x > 0)

# Process the data
result <- df1 %>% 
  group_by(cat) %>% 
  summarize(m = mean(val)) %>%
  arrange(desc(m))

# Print the result
print(result)

# Define a function
my_func <- function(x, y) {
  x + y
}
