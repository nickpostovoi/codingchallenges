library(ompr)
library(ompr.roi)
library(ROI)
library(ROI.plugin.glpk)
library(tidyverse)

months <- 1:3
plants <- 1:2
prod_rate_A <- c(0.30, 0.32)
prod_rate_B <- c(0.24, 0.28)
avail_hours <- matrix(c(1400, 600, 2000, 3000, 800, 600), nrow = 2, byrow = TRUE)
demand_A <- c(8000, 16000, 6000)
demand_B <- c(2000, 10000, 10000)

model <- MIPModel() %>%

  add_variable(x[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(y[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(invX[j], j = months, type = "continuous", lb = 0) %>%
  add_variable(invY[j], j = months, type = "continuous", lb = 0) %>%

  set_objective(sum_expr(14*(x[1, j] + x[2, j]) - 10*(prod_rate_A[1]*x[1, j] + prod_rate_A[2]*x[2, j]) - 6.2*(x[1, j] + x[2, j]) - 0.46*(x[1, j] + x[2, j]) - 0.20*invX[j] +
                     18*(y[1, j] + y[2, j]) - 10*(prod_rate_B[1]*y[1, j] + prod_rate_B[2]*y[2, j]) - 7.8*(y[1, j] + y[2, j]) - 0.46*(y[1, j] + y[2, j]) - 0.20*invY[j], j = months), "max") %>%

  add_constraint(prod_rate_A[1] * x[1, 1] + prod_rate_B[1] * y[1, 1] <= avail_hours[1, 1]) %>%
  add_constraint(prod_rate_A[1] * x[1, 2] + prod_rate_B[1] * y[1, 2] <= avail_hours[1, 2]) %>%
  add_constraint(prod_rate_A[1] * x[1, 3] + prod_rate_B[1] * y[1, 3] <= avail_hours[1, 3]) %>%
  add_constraint(prod_rate_A[2] * x[2, 1] + prod_rate_B[2] * y[2, 1] <= avail_hours[2, 1]) %>%
  add_constraint(prod_rate_A[2] * x[2, 2] + prod_rate_B[2] * y[2, 2] <= avail_hours[2, 2]) %>%
  add_constraint(prod_rate_A[2] * x[2, 3] + prod_rate_B[2] * y[2, 3] <= avail_hours[2, 3]) %>%

  add_constraint(x[1, 1] + x[2, 1] >= demand_A[1]) %>%
  add_constraint(x[1, 2] + x[2, 2] + invX[1] >= demand_A[2]) %>%
  add_constraint(x[1, 3] + x[2, 3] + invX[2] == demand_A[3]) %>%
  add_constraint(y[1, 1] + y[2, 1] >= demand_B[1]) %>%
  add_constraint(y[1, 2] + y[2, 2] + invY[1] >= demand_B[2]) %>%
  add_constraint(y[1, 3] + y[2, 3] + invY[2] == demand_B[3]) %>%
  
  add_constraint(invX[1] == x[1, 1] + x[2, 1] - demand_A[1]) %>%
  add_constraint(invX[2] == x[1, 2] + x[2, 2] + invX[1] - demand_A[2]) %>%
  add_constraint(invY[1] == y[1, 1] + y[2, 1] - demand_B[1]) %>%
  add_constraint(invY[2] == y[1, 2] + y[2, 2] + invY[1] - demand_B[2])

result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))

print(result)

months <- 1:3
plants <- 1:2
prod_rate_A <- c(0.30, 0.32)
prod_rate_B <- c(0.24, 0.28)
avail_hours <- matrix(c(1400, 600, 2000, 3000, 800, 600), nrow = 2, byrow = TRUE)
demand_A <- c(8000, 16000, 6000)
demand_B <- c(2000, 10000, 10000)

model <- MIPModel() %>%

  add_variable(x[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(y[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(invX[j], j = months, type = "continuous", lb = 0) %>%
  add_variable(invY[j], j = months, type = "continuous", lb = 0) %>%
  add_variable(s[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%

  set_objective(sum_expr(14*(x[1, j] + x[2, j]) - 10*(prod_rate_A[1]*x[1, j] + prod_rate_A[2]*x[2, j]) - 6.2*(x[1, j] + x[2, j]) - 0.46*(x[1, j] + x[2, j]) - 0.20*invX[j] +
                     18*(y[1, j] + y[2, j]) - 10*(prod_rate_B[1]*y[1, j] + prod_rate_B[2]*y[2, j]) - 7.8*(y[1, j] + y[2, j]) - 0.46*(y[1, j] + y[2, j]) - 0.20*invY[j], j = months), "max") %>%

  add_constraint(prod_rate_A[1] * x[1, 1] + prod_rate_B[1] * y[1, 1] - s[1, 1] <= avail_hours[1, 1]) %>%
  add_constraint(prod_rate_A[1] * x[1, 2] + prod_rate_B[1] * y[1, 2] - s[1, 2] <= avail_hours[1, 2]) %>%
  add_constraint(prod_rate_A[1] * x[1, 3] + prod_rate_B[1] * y[1, 3] - s[1, 3] <= avail_hours[1, 3]) %>%
  add_constraint(prod_rate_A[2] * x[2, 1] + prod_rate_B[2] * y[2, 1] - s[2, 1] <= avail_hours[2, 1]) %>%
  add_constraint(prod_rate_A[2] * x[2, 2] + prod_rate_B[2] * y[2, 2] - s[2, 2] <= avail_hours[2, 2]) %>%
  add_constraint(prod_rate_A[2] * x[2, 3] + prod_rate_B[2] * y[2, 3] - s[2, 3] <= avail_hours[2, 3]) %>%

  add_constraint(x[1, 1] + x[2, 1] >= demand_A[1]) %>%
  add_constraint(x[1, 2] + x[2, 2] + invX[1] >= demand_A[2]) %>%
  add_constraint(x[1, 3] + x[2, 3] + invX[2] == demand_A[3]) %>%
  add_constraint(y[1, 1] + y[2, 1] >= demand_B[1]) %>%
  add_constraint(y[1, 2] + y[2, 2] + invY[1] >= demand_B[2]) %>%
  add_constraint(y[1, 3] + y[2, 3] + invY[2] == demand_B[3]) %>%
  
  add_constraint(invX[1] == x[1, 1] + x[2, 1] - demand_A[1]) %>%
  add_constraint(invX[2] == x[1, 2] + x[2, 2] + invX[1] - demand_A[2]) %>%
  add_constraint(invY[1] == y[1, 1] + y[2, 1] - demand_B[1]) %>%
  add_constraint(invY[2] == y[1, 2] + y[2, 2] + invY[1] - demand_B[2])

result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))

solution <- result$solution
cat("Optimal solution:", "\n")
print(solution)
print(result)

months <- 1:3
plants <- 1:2
prod_rate_A <- c(0.30, 0.32)
prod_rate_B <- c(0.24, 0.28)
avail_hours <- matrix(c(1400, 600, 2000, 3000, 800, 600), nrow = 2, byrow = TRUE)
demand_A <- c(8000, 16000, 6000)
demand_B <- c(2000, 10000, 10000)
alpha <- 100

model <- MIPModel() %>%

  add_variable(x[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(y[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%
  add_variable(invX[j], j = months, type = "continuous", lb = 0) %>%
  add_variable(invY[j], j = months, type = "continuous", lb = 0) %>%
  add_variable(s[i, j], i = plants, j = months, type = "continuous", lb = 0) %>%

set_objective(sum_expr(14*(x[1, j] + x[2, j]) - 10*(prod_rate_A[1]*x[1, j] + prod_rate_A[2]*x[2, j]) - 6.2*(x[1, j] + x[2, j]) - 0.46*(x[1, j] + x[2, j]) - 0.20*invX[j] +
                     18*(y[1, j] + y[2, j]) - 10*(prod_rate_B[1]*y[1, j] + prod_rate_B[2]*y[2, j]) - 7.8*(y[1, j] + y[2, j]) - 0.46*(y[1, j] + y[2, j]) - 0.20*invY[j] -
                     alpha * (avail_hours[1, j] - (prod_rate_A[1]*x[1, j] + prod_rate_B[1]*y[1, j]) + s[1, j] + avail_hours[2, j] - (prod_rate_A[2]*x[2, j] + prod_rate_B[2]*y[2, j]) + s[2, j]), j = months), "max") %>%

  add_constraint(prod_rate_A[1] * x[1, j] + prod_rate_B[1] * y[1, j] - s[1, j] <= avail_hours[1, j], j = months) %>%
  add_constraint(prod_rate_A[2] * x[2, j] + prod_rate_B[2] * y[2, j] - s[2, j] <= avail_hours[2, j], j = months) %>%

  add_constraint(x[1, 1] + x[2, 1] >= demand_A[1]) %>%
  add_constraint(x[1, 2] + x[2, 2] + invX[1] >= demand_A[2]) %>%
  add_constraint(x[1, 3] + x[2, 3] + invX[2] == demand_A[3]) %>%
  add_constraint(y[1, 1] + y[2, 1] >= demand_B[1]) %>%
  add_constraint(y[1, 2] + y[2, 2] + invY[1] >= demand_B[2]) %>%
  add_constraint(y[1, 3] + y[2, 3] + invY[2] == demand_B[3]) %>%
  
  add_constraint(invX[1] == x[1, 1] + x[2, 1] - demand_A[1]) %>%
  add_constraint(invX[2] == x[1, 2] + x[2, 2] + invX[1] - demand_A[2]) %>%
  add_constraint(invY[1] == y[1, 1] + y[2, 1] - demand_B[1]) %>%
  add_constraint(invY[2] == y[1, 2] + y[2, 2] + invY[1] - demand_B[2])
result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))

solution <- result$solution
cat("Optimal solution:", "\n")
print(solution)
print(result)
