# ----------------------------------------------
# load required packages
# ----------------------------------------------
if(!suppressWarnings(require(shiny))) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(leaflet))) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(shinycssloaders))) install.packages("shinycssloaders", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(plotly))) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(ggthemes))) install.packages("ggthemes", repos = "http://cran.us.r-project.org")

ui <- navbarPage("Covid19Veiw",
    windowTitle = "Covid19Veiw",
    #########################################
    # Covid19 in South-Korea
    #########################################
    tabPanel(
        'South-Korea',
        fluidPage(
            # Load a different font for the app
            tags$head(
                tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Source+Sans+Pro")
                # tags$style(
                #     HTML('#sidebar {background-color: #dec4de;}')
                # )
            ),
            
            # This is to explain you have a CSS file that custom the appearance of the app
            includeCSS("www/style.css") ,
            fluidRow( align="center",
                      br(),
                      helpText(
                          strong("Covid19 in South-Korea", style="color:black; font-size:30pt")
                      ),
                      helpText(
                          "Version 1.0"
                      ),
                      hr()
            ),
            fluidRow( h6(textOutput("reactive_update"), align = "right")
            ),
            fluidRow(column(width = 2, offset=0),
                column(width = 2, offset=0, 
                       h3('Confirmed Cases', align = "center"),
                       h2(textOutput("reactive_case_count"), align = "center")),
                column(width = 2, offset=0, 
                       h3('Death Cases', align = "center"),
                       h2(textOutput("reactive_death_count"), align = "center")),
                column(width = 2, offset=0, 
                       h3('Death Rate', align = "center"),
                       h2(textOutput("reactive_deathrate_count"), align = "center")),
                column(width = 2, offset=0, 
                       h3('Isolation clearance', align = "center"),
                       h5(textOutput("reactive_clear_count"), align = "center")),
                column(width = 2, offset=0)
            ),
            fluidRow(
                column(width = 12, offset=0, align="center",br(),
                        leafletOutput(outputId = "kormap",width='100%',height=500) %>% withSpinner (color= "#e8574f"))
                # column(width = 4, offset=0, align="center",br(),                       
                #         plotlyOutput(outputId = "AgePie",height=500) %>% withSpinner( color= "#e8574f")
                # )
            )),

            fluidRow(column(width = 12,offset=0, align="center",hr(),br(),
                            h1("7 days forecast"),
                            h6('This model generates a forecast of the development of COVID-19 for 7 days in the future in South-Korea.'),
                            h6('This is intended to be used as one of many signals to help first responders in healthcare, the public sector, and other impacted organizations be better prepared for what lies ahead.')
                            ),
                column(width = 12,offset=0, align="center",br(),
                       # Sidebar layout with input and output definitions ----
                       h3("Confirmed Cases - Cumulative"),
                       # Output: Histogram ----
                       plotlyOutput(outputId = "ConfirmedBarPlot",height=400) %>% withSpinner( color= "#e8574f")
                )
            ),
        
        # Footer
        fluidRow( align="center" ,
                  br(), br(),
                  column(4, offset=4,
                         hr(),
                         br(), br(),
                         "Source code available on", strong(a("Github",  href="https://github.com/ominiv/Covid19View")),".",
                         br(),
                         "Copyright ominiv",
                         br(), br(),br()
                         
                  ),
                  br(),br()
        )
        
        ),
    
    #########################################
    # Covid19 in world
    #########################################
    tabPanel(
        'World',
        fluidPage(
            fluidRow( align="center",
                      br(),
                      helpText(
                          strong("Covid19 in World", style="color:black; font-size:30pt")
                      ),
                      helpText(
                          "Version 1.0"
                      ),
                      hr()
            ),
            fluidRow(column(width = 12,offset=0, align="center",
                # Output: worldmap ----
                leafletOutput(outputId = "worldmap",width='100%',height=500) %>% withSpinner( color= "#e8574f")
            )),
            fluidRow( 
                hr(),br(),
                column(width = 12, align="center" , dataTableOutput('worldtable'))
            ),        
            # Footer
            fluidRow( align="center" ,
                      br(), br(),
                      column(4, offset=4,
                             hr(),
                             br(), br(),
                             "Source code available on", strong(a("Github",  href="https://github.com/ominiv/Covid19View")),".",
                             br(),
                             "Copyright ominiv",
                             br(), br(),br()
                             
                      ),
                      br(),br()
            )
        )
    )
)


