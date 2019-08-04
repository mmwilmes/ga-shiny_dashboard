## Load packages
# Pacman packages checks if available and installs if not
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny,
               tidyverse,        
               scales,           # Useful for some number formatting in the visualizations
               highcharter,
               googleAuthR,
               shinydashboard,
               RColorBrewer
)

# set port to registered auth in Google project
options(shiny.port = 1221)

cumview <- read_delim("./data/cumulativeusage.csv", delim = ",")
cumview$ID <- as.factor(cumview$ID)
#cumview$institutionid <- as.numeric(cumview$institutionid)
#cumview_small <- cumview %>% filter(institutionid %in% c(234,1020,549,2,1,1407,13944,59958) & Date != max(cumview$Date))

institutions <- read_delim("./data/institutions.csv", delim = ",")
#institutions$InstitutionID <- as.numeric(institutions$InstitutionID)
#JOIN instiutions
cumview2 <- full_join(cumview, institutions, by = c("institutionid" = "InstitutionID"))

#cumview <- read_delim("./data/cumview_small.csv", delim = ",")
jsections <- read_delim("./data/journalsections.csv", delim = ",", col_types = cols_only(SectionID = "n", Title = "c", is_science_education = "n"))
#JOIN jsections onto cumview
cumview3 <- left_join(cumview2, jsections, by = c("sectionid" = "SectionID"))
cumview <- cumview3
