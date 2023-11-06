#import the libraries
library(RMySQL)
library(DBI)
library(lme4)
library(performance)
library(caret)
library(pROC)
library(dplyr)

#connect R to the database
db_connection <- dbConnect(
  RMySQL::MySQL(),
  host = "",
  user = "",
  password = "",
  dbname = "mps_data"
)

#create a mapping of tactics for the models
tactic_mapping <- data.frame(tactic = c('Tactical Communications','Compliant Handcuffing','Unarmed Skills (including pressure points, strikes, restraints and take-downs)','Non-Compliant Handcuffing','Ground Restraint','Limb/Body Restraints','Spit Guard','Shield','Dog Deployed','Other/Improvised','Irritant Spray - CS Drawn','Irritant Spray - PAVA Drawn','CED (Taser) Drawn','Baton Drawn','CED (Taser) Red-Dotted','CED (Taser) Aimed','CED (Taser) Arced','AEP Aimed','Firearm Aimed','Irritant Spray - CS Used','Irritant Spray - PAVA Used','CED (Taser) Drive Stun','CED (Taser) Angle Drive Stun','CED (Taser) Fired','Dog Bite','Baton Used','Firearm Fired'), 
drawing_equipment = c(0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0), 
using_equipment = c(0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1), 
using_unarmed_force = c(0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))

#upload the mapping to the tactics dictionary

query <- "ALTER TABLE tactic_dict ADD drawing_equipment INT"
dbExecute(db_connection, query)
query <- "ALTER TABLE tactic_dict ADD using_equipment INT"
dbExecute(db_connection, query)
query <- "ALTER TABLE tactic_dict ADD using_unarmed_force INT"
dbExecute(db_connection, query)

for(i in 1:nrow(tactic_mapping)) {
    query <- sprintf(
        "UPDATE tactic_dict 
         SET drawing_equipment = %d, 
             using_equipment = %d, 
             using_unarmed_force = %d 
         WHERE tactic = '%s'", 
        tactic_mapping$drawing_equipment[i], 
        tactic_mapping$using_equipment[i], 
        tactic_mapping$using_unarmed_force[i], 
        tactic_mapping$tactic[i]
    )
    dbExecute(db_connection, query)
}

query <- "
SELECT * FROM inference_view
WHERE uof.Date_time BETWEEN '2020-04-01 00:00:00' AND '2022-03-31 23:59:59'
"
df <- dbGetQuery(db_connection, query)

#create a variable for armed response duty
df <- df %>%
  mutate(armed_main_duty = if_else(main_duty %in% c('CTSFO', 'ARV', 'AFO', 'Dog handler duty'), 1, 0)) %>%
  select(-main_duty)

#compute crime rate per borough
borough_means <- df %>%
  group_by(borough) %>%
  summarize(mean_crime_rate = mean(mps_crime_rate, na.rm = TRUE))

#compute median crime rate
median_val <- median(borough_means$mean_crime_rate, na.rm = TRUE)

#map boroughs based on a crime rate
borough_means <- borough_means %>%
  mutate(borough_category = if_else(mean_crime_rate < median_val, 0, 1))

#merge the grouping variable to a dataframe
df <- df %>%
  left_join(borough_means %>% select(borough, borough_category), by = "borough") %>%
  select(-borough)

#convert response variables to factors
df$response_weapon_drawn <- as.factor(df$response_weapon_drawn)
df$response_weapon_used <- as.factor(df$response_weapon_used)
df$response_unarmed_force_used <- as.factor(df$response_unarmed_force_used)

# convert datetime to a correct datatype
df$date_time <- as.POSIXct(df$date_time)
#split the data into test and train
df_train <- df[df$date_time >= "2021-04-01 00:00:00" & df$date_time <= "2022-03-31 23:59:59",]
df_test <- df[df$date_time < "2021-04-01 00:00:00",]

#list columns to scale
columns_to_scale <- c('primary_conduct', 'impfct_weapon', 'impfct_alcohol', 'impfct_drugs', 'impfct_mentalhealth',
                      'physical_disability', 'officer_assaulted', 'impfct_ABD', 'is_white', 'is_male', 'subject_age',
                      'ced_carrying', 'impfct_pknowledge', 'impfct_sizegenderbuild', 'reason_protectself', 'reason_protectpublic',
                      'reason_protectsubject', 'reason_protectofficers', 'location_street', 'location_hospital', 'location_mentalhealth',
                      'location_dwelling', 'census_white_ethnic', 'census_not_deprived', 'census_high_qualification', 'census_pop_density',
                       'mps_crime_rate', 'impfct_crowd', 'is_daytime', 'is_weekend')

min_max_scale <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
#scale the dataframes separately to prevent data leakage
df_train[columns_to_scale] <- lapply(df_train[columns_to_scale], min_max_scale)
df_test[columns_to_scale] <- lapply(df_test[columns_to_scale], min_max_scale)

#filter dataframes for modelling
df_train1 = filter(df_train, response_weapon_drawn == 0 & response_weapon_used == 0)
df_test1 = filter(df_test, response_weapon_drawn == 0 & response_weapon_used == 0)

df_train2 = filter(df_train, response_weapon_used == 0)
df_test2 = filter(df_test, response_weapon_used == 0)

df_train3 = filter(df_train, response_weapon_drawn == 1)
df_test3 = filter(df_test, response_weapon_drawn == 1)

#the block variable selection for first model

model_uf1 <- glmer(response_unarmed_force_used ~ 
#subject-related
primary_conduct + 
impfct_weapon + 
impfct_alcohol + 
impfct_drugs +
impfct_mentalhealth + 
physical_disability + 
officer_assaulted + 
impfct_ABD +
(1|armed_main_duty/borough_category), 
data=df_train1, family=binomial(link="logit"))
#display the regression summary
summary(model_uf1)
r2(model_uf1)
ranef(model_uf1)

#get the predicted probabilities
predicted_probs_uf1 <- predict(model_uf1, newdata = df_test1, type = "response", re.form = NULL)
#convert the factor to numeric
actual_values_uf <- as.numeric(as.character(df_test1$response_unarmed_force_used))
#compute the log loss
log_loss_uf1 <- -mean(actual_values_uf * log(predicted_probs_uf1) + 
                  (1 - actual_values_uf) * log(1 - predicted_probs_uf1))
#display the log loss
log_loss_uf1

#the code for the models in between is the same (hidden to avoid redundancy)

model_uf6 <- glmer(response_unarmed_force_used ~ 

#subject-related
primary_conduct + 
impfct_weapon + 
impfct_alcohol + 
impfct_drugs +
impfct_mentalhealth + 
# physical_disability + 
officer_assaulted + 
impfct_ABD +

#subject-demographics
is_white + 
is_male + 
subject_age + 

#officer-related
ced_carrying + 
impfct_pknowledge + 
impfct_sizegenderbuild + 
reason_protectself +
# reason_protectpublic +
reason_protectsubject + 
reason_protectofficers + 

#location
location_street + 
location_hospital +
location_mentalhealth + 
location_dwelling + 

#borough-level varibles
# census_white_ethnic + 
census_not_deprived + 
census_high_qualification + 

#external factors
impfct_crowd + 
is_daytime + 
is_weekend + 

(1|armed_main_duty/borough_category), 
data=df_train1, family=binomial(link="logit"))

summary(model_uf6)
r2(model_uf6)
ranef(model_uf6)

predicted_probs_uf6 <- predict(model_uf6, newdata = df_test1, type = "response", re.form = NULL)
log_loss_uf6 <- -mean(actual_values_uf * log(predicted_probs_uf6) + 
                  (1 - actual_values_uf) * log(1 - predicted_probs_uf6))

#check for multicollinearity
library(car)
#fit a simple logistic regression model with the same predictors
model_uf_simple <- glm(response_unarmed_force_used ~ 
                      primary_conduct + 
                      impfct_weapon + 
                      impfct_alcohol + 
                      impfct_drugs +
                      impfct_mentalhealth + 
                      officer_assaulted + 
                      impfct_ABD +
                      is_white + 
                      is_male + 
                      subject_age + 
                      ced_carrying + 
                      impfct_pknowledge + 
                      impfct_sizegenderbuild + 
                      reason_protectself +
                      reason_protectsubject + 
                      reason_protectofficers + 
                      location_street + 
                      location_hospital +
                      location_mentalhealth + 
                      location_dwelling +
                      census_not_deprived +
                      census_high_qualification + 
                      impfct_crowd + 
                      is_daytime + 
                      is_weekend, 
                    data = df_train1, family = binomial(link="logit"))
#compute VIFs
vifs <- vif(model_simple)
print(vifs)

#normality of residuals assumptions
fitted_values <- predict(model_uf6, type = "response", re.form=NA)
residuals_standardized <- residuals(model_uf6, type = "response") / (fitted_values * (1 - fitted_values))^0.5
plot <- ggplot(data = NULL, aes(x = fitted_values, y = residuals_standardized)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal() +
  ggtitle("Standardized Residuals vs. Fitted Values")
ggsave(filename = "rq1_residual_plot_uf.png", plot = plot, width = 6, height = 6, dpi = 200)

#residual plots for non-binary predictors
predictors <- c("primary_conduct", "subject_age", "census_not_deprived", "census_high_qualification")
for (pred in predictors) {
  plot <- ggplot(df_train1, aes_string(x = pred, y = residuals_standardized)) +
    geom_point() +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    ggtitle(paste("Standardized Residuals vs.", pred))
  file_name <- paste("rq1_residual_plot_uf_", pred, ".png", sep = "")
  ggsave(filename = file_name, plot = plot, width = 6, height = 6, dpi = 200)
  print(plot)
}

#model 2

model_wd1 <- glmer(response_weapon_drawn ~ 
#subject-related
primary_conduct + 
impfct_weapon + 
impfct_alcohol + 
impfct_drugs +
impfct_mentalhealth + 
physical_disability + 
officer_assaulted + 
impfct_ABD +
(1|armed_main_duty/borough_category), 
data=df_train2, family=binomial(link="logit"))

summary(model_wd1)
r2(model_wd1)
ranef(model_wd1)

predicted_probs_wd1 <- predict(model_wd1, newdata = df_test2, type = "response", re.form = NULL)
actual_values_wd <- as.numeric(as.character(df_test2$response_weapon_drawn))
log_loss_wd1 <- -mean(actual_values_wd * log(predicted_probs_wd1) + 
                  (1 - actual_values_wd) * log(1 - predicted_probs_wd1))

#the code for the models in between is the same (hidden to avoid redundancy)

model_wd6 <- glmer(response_weapon_drawn ~ 

#subject-related
primary_conduct + 
impfct_weapon + 
# impfct_alcohol + 
impfct_drugs +
impfct_mentalhealth + 
# physical_disability + 
officer_assaulted + 
# impfct_ABD +

#subject-demographics
# is_white + 
is_male + 
# subject_age + 

#officer-related
ced_carrying + 
impfct_pknowledge + 
impfct_sizegenderbuild + 
reason_protectself +
reason_protectpublic +
reason_protectsubject + 
reason_protectofficers + 

#location
location_street + 
location_hospital +
location_mentalhealth + 
location_dwelling + 

#borough-level varibles
census_white_ethnic + 
census_not_deprived +
census_high_qualification + 

#external factors
impfct_crowd + 
is_daytime + 
is_weekend + 

(1|armed_main_duty/borough_category), 
data=df_train2, family=binomial(link="logit"))

summary(model_wd6)
r2(model_wd6)
ranef(model_wd6)

predicted_probs_wd6 <- predict(model_wd6, newdata = df_test2, type = "response", re.form = NULL)
log_loss_wd6 <- -mean(actual_values_wd * log(predicted_probs_wd6) + 
                  (1 - actual_values_wd) * log(1 - predicted_probs_wd6))
log_loss_wd6

#multicollinearity check

model_wd_simple <- glm(response_weapon_drawn ~ 
primary_conduct + 
impfct_weapon + 
impfct_drugs +
impfct_mentalhealth + 
officer_assaulted + 
is_male + 
ced_carrying + 
impfct_pknowledge + 
impfct_sizegenderbuild + 
reason_protectself +
reason_protectpublic +
reason_protectsubject + 
reason_protectofficers + 
location_street + 
location_hospital +
location_mentalhealth + 
location_dwelling + 
census_white_ethnic + 
census_not_deprived +
census_high_qualification + 
impfct_crowd + 
is_daytime + 
is_weekend,
data = df_train2, family = binomial(link="logit"))

vifs <- vif(model_wd_simple)
print(vifs)

fitted_values <- predict(model_wd6, type = "response", re.form=NA)
residuals_standardized <- residuals(model_wd6, type = "response") / (fitted_values * (1 - fitted_values))^0.5

plot <- ggplot(data = NULL, aes(x = fitted_values, y = residuals_standardized)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal() +
  ggtitle("Standardized Residuals vs. Fitted Values")
ggsave(filename = "rq1_residual_plot_wd.png", plot = plot, width = 6, height = 6, dpi = 200)

predictors <- c("primary_conduct", "subject_age", "census_not_deprived", "census_high_qualification")
for (pred in predictors) {
  plot <- ggplot(df_train2, aes_string(x = pred, y = residuals_standardized)) +
    geom_point() +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    ggtitle(paste("Standardized Residuals vs.", pred))
    file_name <- paste("rq1_residual_plot_wd_", pred, ".png", sep = "")
  ggsave(filename = file_name, plot = plot, width = 6, height = 6, dpi = 200)
  print(plot)
}

#model 3

model_wu1 <- glmer(response_weapon_used ~ 

#subject-related
primary_conduct + 
impfct_weapon + 
impfct_alcohol + 
impfct_drugs +
impfct_mentalhealth + 
physical_disability + 
officer_assaulted + 
impfct_ABD +

(1|armed_main_duty/borough_category), 
data=df_train3, family=binomial(link="logit"))

summary(model_wu1)
r2(model_wu1)
ranef(model_wu1)
isSingular(model_wu1)

#the code for the models in between is the same (hidden to avoid redundancy)

model_wu6 <- glmer(response_weapon_used ~ 

#subject-related
primary_conduct + 
# impfct_weapon + 
impfct_alcohol + 
# impfct_drugs +
# impfct_mentalhealth + 
# physical_disability + 
officer_assaulted + 
impfct_ABD +

#subject-demographics
# is_white + #causes singlarity
# is_male + 
subject_age + 

#officer-related
ced_carrying + 
# impfct_pknowledge + 
impfct_sizegenderbuild + 
reason_protectself +
reason_protectpublic +
# reason_protectsubject + 
reason_protectofficers + 

#location
# location_street + 
location_hospital +
location_mentalhealth + 
# location_dwelling + 

#borough-level varibles
# census_white_ethnic + #causes singularity
# census_not_deprived + #causes singularity
# census_high_qualification + #causes singularity

#external factors
# impfct_crowd + #causes singularity
# is_daytime + 
# is_weekend + 

(1|borough_category), 
data=df_train3, family=binomial(link="logit"))

summary(model_wu6)
r2(model_wu6)
ranef(model_wu6)

predicted_probs_wu6 <- predict(model_wu6, newdata = df_test3, type = "response", re.form = NULL)
log_loss_wu6 <- -mean(actual_values_wu * log(predicted_probs_wu6) + 
                  (1 - actual_values_wu) * log(1 - predicted_probs_wu6))
log_loss_wu6

model_wu_simple <- glm(response_weapon_used ~ 
primary_conduct + 
impfct_alcohol + 
officer_assaulted + 
impfct_ABD +
subject_age + 
ced_carrying + 
impfct_sizegenderbuild + 
reason_protectself +
reason_protectpublic +
reason_protectofficers +  
location_hospital +
location_mentalhealth,
data = df_train3, family = binomial(link="logit"))
vifs <- vif(model_wu_simple)
print(vifs)

fitted_values <- predict(model_wu6, type = "response", re.form=NA)
residuals_standardized <- residuals(model_wu6, type = "response") / (fitted_values * (1 - fitted_values))^0.5
plot <- ggplot(data = NULL, aes(x = fitted_values, y = residuals_standardized)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal() +
  ggtitle("Standardized Residuals vs. Fitted Values")
ggsave(filename = "rq1_residual_plot_wu.png", plot = plot, width = 6, height = 6, dpi = 200)

predictors <- c("primary_conduct", "subject_age", "census_not_deprived", "census_high_qualification")
for (pred in predictors) {
  plot <- ggplot(df_train3, aes_string(x = pred, y = residuals_standardized)) +
    geom_point() +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    ggtitle(paste("Standardized Residuals vs.", pred))
  file_name <- paste("rq1_residual_plot_wu_", pred, ".png", sep = "")
  ggsave(filename = file_name, plot = plot, width = 6, height = 6, dpi = 200)
  print(plot)
}
