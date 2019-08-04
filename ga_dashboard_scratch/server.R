## in server.R
source("~/GoogleDriveMadlen/coding/ga-shiny_dashboard/ga_dashboard_scratch/functions.R")

# load past authenication to access correct project (not package default)
library(googleAnalyticsR) #request GA data

# set up authentication token
scopes = c("https://www.googleapis.com/auth/analytics.readonly")
auth_token <- gar_auth_service(json_file="./auth/server_secret.json", scope=scopes)

server <- function(input, output, session){
    
    # # retrieve ga_accounts
    # ga_accounts <- reactive({
    #     with_shiny(
    #         ga_account_list,
    #         shiny_access_token = auth_token
    #     )
    # })
    # 
    # view_id <- callModule(authDropdown, "auth_dropdown", ga.table = ga_accounts)
    # 
    # gadata <- reactive({
    #     req(view_id())
    #     req(input$datepicker)
    # 
    #     #gaid <- view_id()
    # 
    #     with_shiny(
    #         google_analytics,
    #         view_id(),
    #         date_range = input$datepicker,
    #         metrics = c("sessions"),
    #         dimensions = c("date"),
    #         max = -1,
    #         shiny_access_token = auth_token
    #         )
    # })

    # output$trend_plot <- renderHighchart({
    #     
    #     ## only trigger once authenticated
    #     req(gadata())
    #     
    #     # report error messages if there are any
    #     gadata <- gadata()
    #     
    #     ## creates a line chart using highcharts
    #     hchart(gadata, "line" , hcaes(x = date, y = sessions))
    #     
    # })
    
    # gadata_medium <- reactive({
    #         req(view_id())
    #         req(input$datepicker)
    #         
    #         data <- with_shiny( 
    #             google_analytics,
    #             view_id(),
    #             #date_range = input$datepicker,
    #             date_range = c(Sys.Date() - 400, Sys.Date()),
    #             dimensions = c("date"),
    #             metrics = "sessions",
    #             pivots = pivot_ga4("medium","sessions"),
    #             max = -1,
    #             shiny_access_token = auth_token
    #                              )
    #                              
    #             # change column names
    #             names(data) <- c("Date","Total","Referral","Direct","Social")
    #             # turn into long format
    #             trend_long <- gather(data, Channel, Sessions, -Date)
    #             
    #             trend_long
    #         })

    
    
    # output$trend_medium_plot <- renderHighchart({
    #     
    #     ## only trigger once authenticated
    #     req(gadata_medium())
    #     
    #     # report error messages if there are any
    #     gadata_medium <- gadata_medium()
    #     
    #     ## creates a line chart using highcharts
    #     hchart(gadata_medium, type = "line", hcaes(x = Date, y = Sessions, group = Channel))
    # })
    
    ### Usage by instution plot
    # Combine the selected variables into a new data frame
    selectedData <- reactive({
        cumview %>% filter(Name == input$institutionid) %>% 
            mutate(highlight=ifelse(Title == input$sectionid, paste(Title), "Other")) %>%
            filter(Date >= input$datepicker[1] & Date <= input$datepicker[2])
    })

    output$line_plot <- renderPlot({
            ggplot(selectedData(), aes(Date, Count, group=sectionid, color=highlight)) + geom_line() #+
            # ggtitle("Harvard page views, all years, all products") +
            # scale_size_manual(values=c(0.5, 1.5)) +
            # scale_color_manual(values = c("lightgrey", "#69b3a2"), name = "Product", labels = c('Other', Title)) +
            # geom_point(color = "firebrick", alpha = 0.3) +
            # theme(legend.position = "bottom") +
            # guides(size = FALSE) +
            #theme_bw()
        })
    
    
    # report number of turnaways in time period
    turnaways <- reactive({
        selectedData() %>%
            group_by(Title) %>%
            summarise(turnaways = sum(turnaways))
    })
    
    output$turnaways <- renderTable({ 
        turnaways()
        }, digits = 0)
    
    output$datepick <- renderText({ 
        paste("You selected date", input$datepicker[1], "to" ,input$datepicker[2])
    })
    

    
}

# Run the app
#shinyApp(ui = ui, server = server)
