rm(list=ls())
library('nnet')

setwd('/Users/hoanh/Desktop/Data Source/10 - VHLSS 2018/2 - Data')
library("readxl")
full_data <- read.csv('full.csv')
DBSCL <- read.csv('DBSCL_data.csv')
DBSH <- read.csv('DBSH_data.csv')

#----------------------------------------------------------------------------------------------------------------------------------------------------#
logit_full = glm(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
                   hh_has_agric + hh_income + income_avg + child_prop + older_prop + 
                   com_program + com_poor_program + com_num_poor_families + com_has_market + 
                   non_degree + secondary +  high_school + elementary_occupations+
                   vocational + professional_high_school + college + university
                  ,data= full_data)
summary(logit_full)

# install.packages("mfx")
# library(mfx)
# 
# ### Partial effect 
# partial_effect_full = logitmfx(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
#                                  hh_has_agric + hh_income + income_avg + child_prop + older_prop +
#                                  adult_prop + com_program + com_poor_program + com_num_poor_families + 
#                                  com_has_market + non_degree + secondary +  high_school + elementary_occupations+
#                                  vocational + professional_high_school + college + university, 
#                                data= DBSH, atmean = TRUE, robust = TRUE)
# print(partial_effect_full)
# 
# ### Đa cộng tuyến
# car::vif(logit_full)

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
logit_DBSH = glm(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
                   hh_has_agric + hh_income + income_avg + child_prop + older_prop +
                   com_program + com_poor_program + com_num_poor_families + com_has_market + 
                   non_degree + secondary +  high_school + elementary_occupations+
                   vocational + professional_high_school + college + university
                 ,data= DBSH, family = binomial(link = "logit"))
summary(logit_DBSH)

# ### Partial effect 
# partial_effect_DBSH = logitmfx(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
#                             hh_has_agric + hh_income + income_avg + child_prop + older_prop +
#                             adult_prop + com_program + com_poor_program + com_num_poor_families + 
#                             com_has_market + non_degree + secondary +  high_school + elementary_occupations+
#                             vocational + professional_high_school + college + university, 
#                             data= DBSH, atmean = TRUE, robust = TRUE)
# print(partial_effect_DBSH)
# 
# ### Đa cộng tuyến
# car::vif(logit_DBSH)




#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
logit_DBSCL = glm(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
                    hh_has_agric + hh_income + income_avg + child_prop + older_prop + 
                    com_program + com_poor_program + com_num_poor_families + com_has_market + 
                    non_degree + secondary +  high_school + elementary_occupations+
                    vocational + professional_high_school + college + university
                 ,data= DBSCL, family = binomial(link="logit"))
summary(logit_DBSCL)

# ### Partial effect 
# partial_effect_DBSCL = logitmfx(decision ~ age + sex + ethnicity + hhsize + hh_head_age + hh_head_age_sqr +
#                                   hh_has_agric + hh_income + income_avg + child_prop + older_prop +
#                                   adult_prop + com_program + com_poor_program + com_num_poor_families + 
#                                   com_has_market + non_degree + secondary +  high_school + elementary_occupations+
#                                   vocational + professional_high_school + college + university, 
#                                 data= DBSH, atmean = TRUE, robust = TRUE)
# print(partial_effect_DBSCL)
# 
# ### Đa cộng tuyến
# car::vif(logit_DBSCL)

































