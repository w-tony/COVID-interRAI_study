# Load libraries & functions ----
library(tidyverse)
library(readxl)
library(car)
library(lubridate)

# interRAI data: last assessment extraction ----

# Initialise the interRAI data whilst removing the day of birth
interRAI_read.df <- read_csv("Z:/interRAI LTCF downloaded Jan23.csv",
                             col_types=cols(
                               Date_Of_Birth=col_date("%d/%m/%Y"),
                               assessment_date=col_date("%d/%m/%Y")
                             ))
interRAI_read.df$Date_Of_Birth <- format(interRAI_read.df$Date_Of_Birth, "%m/%Y")
interRAI_read.df[c("gender", "Marital_Status", "District", "Ethnicity")] <- 
  lapply(interRAI_read.df[c("gender", "Marital_Status", "District", "Ethnicity")], factor)
levels(interRAI_read.df$gender) <- c("Female", "Indeterminate", "Male", NA, "Unknown")
levels(interRAI_read.df$Marital_Status) <- c("Other", "Married/Civil union/Defacto", "Other", "Other", "Other", "Other", NA)

# Re-configure the demographic groups into: (1) European, (2) Māori, (3) Pacific Peoples, (4) Asian, 
#                                           (5 & 6), Middle Eastern/Latin American/African & Other Ethnicity, (9) Unknown [Residual Categories]
#                                           This ethnicity code is more consistent with the ones from MoH.
interRAI_read.df$Ethnicity <- recode(interRAI_read.df$Ethnicity,
                                     "c('New Zealand European', 'Other European', 'European NFD')='European';
                                     'Maori'='Māori';
                                     c('Samoan', 'Cook Island Maori', 'Tongan', 'Niuean', 'Tokelauan', 'Fijian', 'Other Pacific Peoples', 'Pacific Peoples NFD')='Pacific Peoples';
                                     c('Asian NFD', 'Southeast Asian', 'Chinese', 'Indian', 'Other Asian')='Asian';
                                     c('Middle Eastern', 'Latin American', 'African', 'Other Ethnicity')='Middle Eastern/Latin American/African/Others';
                                     c('Refused to Answer', 'Response Unidentifiable', 'Not stated', 'Dont Know')='Unknown'")

# ...Need to remove the "unknown" ethnicity
interRAI_read.df <- droplevels(interRAI_read.df[!interRAI_read.df$Ethnicity == "Unknown",])

# Re-value iJ7: self-rated health values
interRAI_read.df$iJ7 <- recode(interRAI_read.df$iJ7,
                               "0='Excellent';
                               1='Good';
                               2='Fair';
                               3='Poor';
                               8='Could not (would not) respond'")

# Re-value Scale_ADLHierarchy
interRAI_read.df$Scale_ADLHierarchy <- recode(interRAI_read.df$Scale_ADLHierarchy,
                                              "0='0 (Independent)';
                                              c(1, 2)='1-2 (Mild to moderately dependent)';
                                              c(3, 4, 5, 6)='3-6 (Severely dependent)'")

# Re-value both the "falls" (iJ1) and the "falls in the last 30 days" (iJ1g) columns
interRAI_read.df$iJ1 <- recode(interRAI_read.df$iJ1,
                               "c(0, 1)='No falls';
                               c(2, 3)='≥1 fall'")
interRAI_read.df$iJ1g <- recode(interRAI_read.df$iJ1g,
                                "0='No falls';
                                c(1, 2)='≥1 fall'")

# Consolidate the information from falls in the last 30 days (iJ1g)
# into the missing values of falls (iJ1)
interRAI_read.df$iJ1 <- ifelse(interRAI_read.df$iJ1 == "NULL", interRAI_read.df$iJ1g, interRAI_read.df$iJ1)

# Re-value Scale_CPS
interRAI_read.df$Scale_CPS <- recode(interRAI_read.df$Scale_CPS,
                                     "0='0 (Intact)';
                                     c(1, 2)='1-2 (Borderline or mild cognitive impairment)';
                                     c(3, 4, 5, 6)='3-6 (Moderate to severe cognitive impairment)'")

# Re-value Scale_DRS
interRAI_read.df$Scale_DRS <- recode(interRAI_read.df$Scale_DRS,
                                     "c(0, 1, 2)='0-2 (No to minimal)';
                                     c(3, 4, 5)='3-5 (Moderate)';
                                     c(6, 7, 8, 9, 10, 11, 12, 13, 14)='6+ (Severe)'")

# Re-value Scale_AggressiveBehaviour
interRAI_read.df$Scale_AggressiveBehaviour <- recode(interRAI_read.df$Scale_AggressiveBehaviour,
                                                     "0='0 (Nil)';
                                                     c(1, 2, 3, 4)='1-4 (Mildly aggressive behaviour)';
                                                     c(5, 6, 7, 8, 9, 10, 11, 12)='5+ (Moderate to severely aggressive behaviour)'")

# Re-value Scale_Pain
interRAI_read.df$Scale_Pain <- recode(interRAI_read.df$Scale_Pain,
                                      "0='0 (No pain)';
                                      c(1, 2)='1-2 (Slight daily pain)';
                                      c(3, 4)='3-4 (Excruciating daily pain)'")

# Re-value Scale_CHESS
interRAI_read.df$Scale_CHESS <- recode(interRAI_read.df$Scale_CHESS,
                                       "c(0, 1)='0-1 (Stable)';
                                       c(2, 3)='2-3 (Unstable)';
                                       c(4, 5)='4-5 (Highly unstable)'")

# Re-value iF1a: participation in social activities
interRAI_read.df$iF1a <- recode(interRAI_read.df$iF1a,
                                "0='Never';
                                1='>30 days ago';
                                c(2, 3, 4)='≤30 days ago';
                                8='Unable to determine'")

# NA values in iF1a to "unable to determine"
interRAI_read.df["iF1a"][is.na(interRAI_read.df["iF1a"])] <- "Unable to determine"

# Re-value iF1b: visit with a long-standing social relation or family member
interRAI_read.df$iF1b <- recode(interRAI_read.df$iF1b,
                                "0='Never';
                                1='>30 days ago';
                                c(2, 3, 4)='≤30 days ago';
                                8='Unable to determine'")

# NA values in iF1b to "unable to determine"
interRAI_read.df["iF1b"][is.na(interRAI_read.df["iF1b"])] <- "Unable to determine"

# Re-value iF1d: says of indicates he/she feels lonely
interRAI_read.df$iF1d <- recode(interRAI_read.df$iF1d,
                                "0='No';
                                1='Yes'")

# Re-value iF8a: strengths - strong and supportive relationship with family
interRAI_read.df$iF8a <- recode(interRAI_read.df$iF8a,
                                "0='No';
                                1='Yes'")

# Re-value iF8b: strengths - consistent positive outlook
interRAI_read.df$iF8b <- recode(interRAI_read.df$iF8b,
                                "0='No';
                                1='Yes'")
# Re-value iF8c: strengths - finds meaning in day-to-day life
interRAI_read.df$iF8c <- recode(interRAI_read.df$iF8c,
                                "0='No';
                                1='Yes'")

# Re-value iG6a: hours of exericse (within what time frame?)
interRAI_read.df$iG6a <- recode(interRAI_read.df$iG6a,
                                "0='None';
                                1='<1 hour';
                                2='1-2 hours';
                                3='3-4 hours';
                                4='>4 hours'")

# Re-value iG6b: days went out (within 3 days?)
interRAI_read.df$iG6b <- recode(interRAI_read.df$iG6b,
                                "0='No days out';
                                1='Did not go, but usually goes out over a 3-day period';
                                c(2, 3)='1 or more days'")

# Re-value iJ8a: smokes tobacco daily
interRAI_read.df$iJ8a <- recode(interRAI_read.df$iJ8a,
                                "0='No';
                                c(1, 2)='Yes'")

# Function to find mode by group
calc_mode <- function(x) {
  distinct_values <- unique(x)
  distinct_tabulate <- tabulate(match(x, distinct_values))
  distinct_values[which.max(distinct_tabulate)]
}

# Take the final interRAI assessments of each unique individual aged between 60 to 105 (inclusive)
# and select only the most informative columns.
interRAI_read.df <- interRAI_read.df[, c("clientkey", "formid", "age", "gender", "Marital_Status", "Ethnicity", "assessment_date", "iJ7",
                                         "Scale_ADLHierarchy", "iJ1", "Scale_CPS", "Scale_DRS", "Scale_AggressiveBehaviour", "Scale_Pain",
                                         "Scale_CHESS", "iF1a", "iF1b", "iF1d", "iF8a", "iF8b", "iF8c", "iG6a", "iG6b", "iJ8a")] %>%
  rename_at(vars(c("Ethnicity", "gender", "Marital_Status", "iJ7", "Scale_ADLHierarchy", "iJ1", "Scale_CPS",
                   "Scale_DRS", "iF1d", "Scale_AggressiveBehaviour", "iF1a", "iF1b", "iF8a", "iF8b", "iF8c",
                   "iG6a", "iG6b", "Scale_CHESS", "Scale_Pain", "iJ8a")), ~
              c("Ethnicity_adjusted", "gender_group", "Marital_group", "self_rated_health", "ADLHierarchy_3class",
                "Falls_2class", "CPS_3class", "DRS_3class", "loneliness", "Aggressive_3class", "Participation_days",
                "Visit_days", "relationship_family", "positive_outlook", "Finds_meaning", "Hours_exercise",
                "Days_went_out", "CHESS", "pain", "Smoking")) %>%
  filter(between(age, 60, 105)) %>%
  group_by(clientkey) %>%
  mutate(gender_group=ifelse(is.na(gender_group), calc_mode(gender_group), gender_group),
         Marital_group=ifelse(is.na(Marital_group), calc_mode(Marital_group), Marital_group)) %>%
  ungroup()

interRAI_read.df["gender_group"][is.na(interRAI_read.df["gender_group"])] <- 4
interRAI_read.df["Marital_group"][is.na(interRAI_read.df["Marital_group"])] <- 1
interRAI_read.df[c("gender_group", "Marital_group")] <- lapply(interRAI_read.df[c("gender_group", "Marital_group")], factor)
levels(interRAI_read.df$gender_group) <- c("Female", "Indeterminate", "Male", "Unknown")
levels(interRAI_read.df$Marital_group) <- c("Other", "Married/Civil union/Defacto")

# Split into Precovid and Omicron; do not split into final assessments as of now
precovid.df <- subset(interRAI_read.df, assessment_date >= "2018-08-17" & assessment_date <= "2019-08-16") %>%
  group_by(clientkey) %>%
  mutate(Total_assessments = n())
omicron.df <- subset(interRAI_read.df, assessment_date >= "2021-08-17" & assessment_date <= "2022-08-16") %>%
  group_by(clientkey) %>%
  mutate(Total_assessments = n())

# Mortality data ----

# Read both the uncoded and coded mortality data
mortality_coded_read.df <- read_csv("Z:/Mortality data/mos4269_coded.csv",
                                col_types=cols(
                                  DATE_OF_DEATH=col_date("%d/%m/%Y")
                                ))
mortality_uncoded_read.df <- read_csv("Z:/Mortality data/mos4269_uncoded.csv",
                                  col_types=cols(
                                    DATE_OF_DEATH=col_date("%d/%m/%Y")
                                  ))

# Remove duplicate CLIENTKEY identifier from the uncoded data thereby keeping only the first occurrence
mortality_uncoded_read.df <- mortality_uncoded_read.df[!duplicated(mortality_uncoded_read.df$CLIENTKEY),]

# Create an outer table join to fill details from the coded data
mortality.df <- merge(mortality_uncoded_read.df, mortality_coded_read.df, 
                      by=c("CLIENTKEY", "DATE_OF_DEATH", "AGE_AT_DEATH_YRS"), all.x=TRUE)

# Extract meaningful columns from the dataframe; only select deaths from precovid & omicron periods
mortality.df <- mortality.df[ ,c("CLIENTKEY", "DATE_OF_DEATH", "AGE_AT_DEATH_YRS")]
mortality_precovid.df <- subset(mortality.df, DATE_OF_DEATH >= "2018-08-16" & DATE_OF_DEATH <= "2019-08-17")
mortality_omicron.df <- subset(mortality.df, DATE_OF_DEATH >= "2021-08-16" & DATE_OF_DEATH <= "2022-08-17")

# Append the date of death onto the precovid & omicron data; remove rows with assessment dates
# later than the date of death by hardcoding
precovid_late <- merge(precovid.df, mortality_precovid.df, by.x="clientkey", by.y="CLIENTKEY", all.x=TRUE) %>%
  filter(assessment_date > DATE_OF_DEATH) %>%
  pull(formid)
omicron_late <- merge(omicron.df, mortality_omicron.df, by.x="clientkey", by.y="CLIENTKEY", all.x=TRUE) %>%
  filter(assessment_date > DATE_OF_DEATH) %>%
  pull(formid)
precovid.df <- precovid.df[!precovid.df$formid %in% precovid_late, ] %>%
  group_by(clientkey) %>%
  slice(which.max(assessment_date))
omicron.df <- omicron.df[!omicron.df$formid %in% omicron_late, ] %>%
  group_by(clientkey) %>%
  slice(which.max(assessment_date))

# Memory cleanup for mortality data
rm(mortality_coded_read.df, mortality_uncoded_read.df, mortality.df)

# COVID case status and immunisation data ----

# Read data as .txt files
covid_case_status_read.df <- read.delim("Z:/COVID-19 data/Gary Cheung COVID case status.txt")
covid_immunisation_read.df <- read.delim("Z:/COVID-19 data/Gary Cheung COVID immunisations.txt")

# From the interRAI Omicron data, append the date of the last assessment onto the covid cases data
covid_case_status_read.df <- merge(covid_case_status_read.df, omicron.df[ ,c("clientkey", "assessment_date")], by.x="ClientKey", by.y="clientkey", all.x=TRUE)

# No duplicates in case status data; proceed to numerate through the number of recorded cases
covid_case_status_read.df <- covid_case_status_read.df %>%
  # Enable group-wise operations
  group_by(ClientKey) %>%
  # Convert datatype to date-time
  mutate(CASE_REPORT_DT=dmy(CASE_REPORT_DT),
         # Assumption: if infection status is NA then the individual is not infected
         INFECTION_STATUS = ifelse(is.na(INFECTION_STATUS), 0, INFECTION_STATUS),
         # Get the total number of all-time infections
         Total_infections=max(INFECTION_STATUS),
         # Count the total number of infections during Omicron per individual
         Total_omicron_infections=ifelse(
           # Operate only on the omicron-defined period and where the case report date comes before or on the final assessment date
           between(CASE_REPORT_DT, as.Date("2021-08-17"), as.Date("2022-08-16")) & CASE_REPORT_DT <= assessment_date,
           # Take the maximum infection status of each individual; otherwise the individual did not have an infection
           INFECTION_STATUS, NA),
         # Replace NA with 0
         Total_omicron_infections = ifelse(is.na(Total_omicron_infections), 0, Total_omicron_infections)) %>%
  # Take one row of each individual
  slice(which.max(Total_omicron_infections)) %>%
  ungroup() %>%
  select(ClientKey, Total_infections, Total_omicron_infections)

# Using the same omicron data, append the same item onto the immunisation data
covid_immunisation_read.df <- merge(covid_immunisation_read.df, omicron.df[ ,c("clientkey", "assessment_date")], by.x="ClientKey", by.y="clientkey", all.x=TRUE)

# Remove duplicate dates from the immunisation data
covid_immunisation_read.df <- covid_immunisation_read.df %>%
  # Remove NA rows
  drop_na(VACCINATION_DATE, VACCINATION_TYPE, DOSENUMBER) %>%
  # Convert the vaccination as a date-type
  mutate(VACCINATION_DATE = as.Date(VACCINATION_DATE, format="%d/%m/%Y")) %>%
  # Hard code the removal of duplicated vaccination records on 2022-08-04 and 5 doses
  filter(all(!(VACCINATION_DATE=="4/08/2022" & DOSENUMBER == 5)),
         VACCINATION_DATE <= assessment_date) %>%
  # By-group operation
  group_by(ClientKey) %>%
  # Keep only the distinct dose numbers
  distinct(DOSENUMBER, .keep_all=TRUE) %>%
  # Gather the number of rows by group which acts as the total number of doses taken
  summarise(Total_vaccination_doses=n()) %>%
  # Ungroup the data
  ungroup()

# Merge both the case statuses and immunisation data together
covid.df <- merge(covid_case_status_read.df, covid_immunisation_read.df, "ClientKey", all.x=TRUE, all.y=TRUE) %>%
  mutate(Total_infections = ifelse(is.na(Total_infections), 0, Total_infections))

# Memory cleanup for COVID data
rm(covid_case_status_read.df, covid_immunisation_read.df)

# Hospitalisation data  ----

# Read the hospitalisation data
Hospitalisation.df <- read_csv("Z:/Hospitalisation data/Hospitalisation data.csv",
                             col_types=cols(
                              EVENT_START_DATE=col_date("%d/%m/%Y"),
                              EVENT_END_DATE=col_date("%d/%m/%Y")
                             ),
                             col_select=-OP_ACDTE)

# Re-format the CLINICAL CODE column using the generic ICD-10-CM categories
Hospitalisation.df$CLINICAL_CODE_a <- substring(Hospitalisation.df$CLINICAL_CODE,1,1)
Hospitalisation.df$CLINICAL_CODE_b <- as.numeric(substring(Hospitalisation.df$CLINICAL_CODE,2,3))

Hospitalisation.df <- within(Hospitalisation.df, { 
  Disease_type <- NA 
  Disease_type[CLINICAL_CODE_a == "A"|CLINICAL_CODE_a == "B"] <- "a_Certain infectious and parasitic diseases" 
  Disease_type[CLINICAL_CODE_a == "C"|CLINICAL_CODE_a == "D" & CLINICAL_CODE_b <=49] <- "b_Neoplasms" 
  Disease_type[CLINICAL_CODE_a == "D" & CLINICAL_CODE_b > 49] <- "c_Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism" 
  Disease_type[CLINICAL_CODE_a == "E"] <- "d_Endocrine, nutritional and metabolic diseases" 
  Disease_type[CLINICAL_CODE_a == "F"] <- "e_Mental, Behavioral and Neurodevelopmental disorders" 
  Disease_type[CLINICAL_CODE_a == "G"] <- "f_Diseases of the nervous system" 
  Disease_type[CLINICAL_CODE_a == "H" & CLINICAL_CODE_b <= 59] <- "g_Diseases of the eye and adnexa"
  Disease_type[CLINICAL_CODE_a == "H" & CLINICAL_CODE_b > 59] <- "h_Diseases of the ear and mastoid process"
  Disease_type[CLINICAL_CODE_a == "I"] <- "i_Diseases of the circulatory system" 
  Disease_type[CLINICAL_CODE_a == "J"] <- "j_Diseases of the respiratory system" 
  Disease_type[CLINICAL_CODE_a == "K"] <- "k_Diseases of the digestive system" 
  Disease_type[CLINICAL_CODE_a == "L"] <- "l_Diseases of the skin and subcutaneous tissue" 
  Disease_type[CLINICAL_CODE_a == "M"] <- "m_Diseases of the musculoskeletal system and connective tissue" 
  Disease_type[CLINICAL_CODE_a == "N"] <- "n_Diseases of the genitourinary system" 
  Disease_type[CLINICAL_CODE_a == "O"] <- "o_Pregnancy, childbirth and the puerperium" 
  Disease_type[CLINICAL_CODE_a == "Q"] <- "p_Congenital malformations, deformations and chromosomal abnormalities" 
  Disease_type[CLINICAL_CODE_a == "R"] <- "q_Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified" 
  Disease_type[CLINICAL_CODE_a == "S"|CLINICAL_CODE_a == "T"] <- "r_Injury, poisoning and certain other consequences of external causes" 
  Disease_type[CLINICAL_CODE_a == "U"] <- "s_Emergency use of U07" 
  Disease_type[CLINICAL_CODE_a == "Z"] <- "t_Factors influencing health status and contact with health services" 
  
} )

# Split the hospitalisation periods into precovid and omicron and count number of hospitalisations
# per individual
Hospitalisation_precovid.df <- subset(Hospitalisation.df, EVENT_START_DATE >= "2018-08-17" & EVENT_END_DATE <= "2019-08-16")
Hospitalisation_precovid.df <- merge(Hospitalisation_precovid.df, precovid.df[ ,c("clientkey", "assessment_date")], by.x="ClientKey", by.y="clientkey", all.x=TRUE) %>%
  filter(EVENT_END_DATE <= assessment_date) %>%
  group_by(ClientKey) %>%
  summarise(Total_hospitalisations = n())

Hospitalisation_omicron.df <- subset(Hospitalisation.df, EVENT_START_DATE >= "2021-08-17" & EVENT_END_DATE <= "2022-08-16")
Hospitalisation_omicron.df <- merge(Hospitalisation_omicron.df, omicron.df[ ,c("clientkey", "assessment_date")], by.x="ClientKey", by.y="clientkey", all.x=TRUE) %>%
  filter(EVENT_END_DATE <= assessment_date) %>%
  group_by(ClientKey) %>%
  summarise(Total_hospitalisations = n())

# Merge of data ----

# Firstly absorb the mortality & hospitalisation data into the both the precovid data
precovid.df <- merge(precovid.df, mortality_precovid.df, by.x="clientkey", by.y="CLIENTKEY", all.x=TRUE, all.y=FALSE)
precovid.df <- merge(precovid.df, Hospitalisation_precovid.df, by.x="clientkey", by.y="ClientKey", all.x=TRUE, all.y=FALSE) %>%
  mutate(Total_hospitalisations = ifelse(is.na(Total_hospitalisations), 0, Total_hospitalisations),
         Death = ifelse(is.na(DATE_OF_DEATH), FALSE, TRUE))

# Merge the covid, mortality & hospitalisation data with the omicron data
omicron.df <- merge(omicron.df, covid.df, by.x="clientkey", by.y="ClientKey", all.x=TRUE, all.y=FALSE)
omicron.df <- merge(omicron.df, mortality_omicron.df, by.x="clientkey", by.y="CLIENTKEY", all.x=TRUE, all.y=FALSE)
omicron.df <- merge(omicron.df, Hospitalisation_omicron.df, by.x="clientkey", by.y="ClientKey", all.x=TRUE, all.y=FALSE) %>%
  mutate(Death = ifelse(is.na(DATE_OF_DEATH), FALSE, TRUE)) %>%
  mutate_at(c("Total_vaccination_doses", "Total_infections", "Total_hospitalisations"), ~replace_na(., 0))

# Extract some rows from after precovid and before omicron for predictions.
predictions.df <- subset(interRAI_read.df, assessment_date >= "2019-08-17" & assessment_date <= "2021-08-16") %>%
  group_by(clientkey) %>%
  slice(which.max(assessment_date)) %>%
  ungroup(clientkey) %>%
  arrange(assessment_date)


precovid_test.df <- head(predictions.df, n = nrow(precovid.df) * 0.10)
omicron_test.df <- tail(predictions.df, n = nrow(omicron.df) * 0.10)

# Memory cleanup for the interRAI data
rm(covid.df, calc_mode, mortality_omicron.df, omicron_late, precovid_late, predictions.df)

# Save the data
write.csv(precovid.df, "C:/Users/twu849/Documents/COVID-interRAI_study/precovid_final.csv", row.names=FALSE)
write.csv(omicron.df, "C:/Users/twu849/Documents/COVID-interRAI_study/omicron_final.csv", row.names=FALSE)
write.csv(precovid_test.df, "C:/Users/twu849/Documents/COVID-interRAI_study/precovid_test.csv", row.names=FALSE)
write.csv(omicron_test.df, "C:/Users/twu849/Documents/COVID-interRAI_study/omicron_test.csv", row.names=FALSE)