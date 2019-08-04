## ui.R
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny,
               tidyverse,        
               scales,           # Useful for some number formatting in the visualizations
               highcharter,
               googleAuthR,
               shinydashboard
)

# set port to registered auth in Google project
options(shiny.port = 1221)

# set up authentication token
scopes = c("https://www.googleapis.com/auth/analytics.readonly")
auth_token <- gar_auth_service(json_file="./auth/server_secret.json", scope=scopes)

# load past authenication to access correct project (not package default)
library(googleAnalyticsR) #request GA data


scriptHeaders <- function(inputId=NULL) {
    tagList(
        singleton(tags$head(tags$script(src = "js/gtm.js")))
    )
}



dashboardPage(skin = "blue",
              dashboardHeader(title = "Check JoVE first"),
              dashboardSidebar(
                  width = 350,
                  sidebarMenu(
                      menuItem("Dashboard", tabName = "dashboard", icon=icon("dashboard")),
                #googleAuth_jsUI("auth"),
                br(),
                authDropdownUI("auth_dropdown"),
                br(),
                dateRangeInput("datepicker", "Time range", start = "2015-05-01", startview = "year"),
                selectizeInput('institutionid', 'Institution', unique(cumview$Name), selected = unique(cumview$Name)[1]),
                selectInput('sectionid', 'Section', unique(cumview$Title), selected = unique(cumview$Title)[1])
                  )
            ),
            
            dashboardBody(
                tabItems(
                    # first tab content
                    tabItem(tabName = "dashboard",
                             fluidRow(
                                 scriptHeaders(),
                                 box(width=6, height="100px",title = "What is this?", solidHeader = T, status = "info",
                                     p("This is a demo Google Analytics dashboard using R and Shiny")
                                 )
                            ),
                            # h2("Top Level Trends"),
                            # fluidRow(
                            # 
                            #     valueBoxOutput("WoW"),
                            #     valueBoxOutput("MoM"),
                            #     valueBoxOutput("YoY")
                            # ),
                            
                            h2("Plots"),
                            fluidRow(
                                tabBox(title = "", width=12,
                                       tabPanel(title=tagList(shiny::icon("line-chart"), "Trend"),
                                        highchartOutput("trend_plot")
                                       ),
                                       
                                       tabPanel(title=tagList(shiny::icon("line-chart"), "By Medium"),
                                                helpText("Mouse over for more information."),
                                                highchartOutput("trend_medium_plot")
                                                
                                       ),
                                       tabPanel(title=tagList(shiny::icon("university"), "By Institution"),
                                                verbatimTextOutput("datepick"),
                                                plotOutput("line_plot"),
                                                h3("Turnaways per section"),
                                                tableOutput("turnaways")
                                                

                                       ),

                                       tabPanel(title=tagList(shiny::icon("laptop"), "By Device"),
                                                helpText("something here.")
                                                #highchartOutput("trend_medium_plot")
                                                
                                       )
                                       
                                ) #tabBox
                                
                            ) # fluidRow 2
                    ) # tab 1
        

            ) # tabitems
    ) #dashboardBody
) #dashboardPage