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
            includeCSS("www/test.css") ,
            fluidRow( align="center",
                      br(),
                      helpText(
                          strong("Covid19 Dashboard", style="color:black; font-size:30pt")
                      ),
                      helpText(
                          "Version 1.0"
                      ),
                      hr()
            ),
            fluidRow(
                column(width = 4, offset=0, 
                       h1('확진자', align = "center"),
                       h2(textOutput("reactive_case_count"), align = "center")),
                column(width = 4, offset=0, 
                       h1('사망자', align = "center"),
                       h2(textOutput("reactive_death_count"), align = "center")),
                column(width = 4, offset=0, 
                       h1('사망률', align = "center"),
                       h2(textOutput("reactive_deathrate_count"), align = "center"))
            ),
            fluidRow(column(width = 12, offset=0, 
                            h6(textOutput("reactive_update"), align = "right"))),
            fluidRow(
                column(width = 12, offset=0, align="center",
                        theme='bootstrap.min.css',
                        hr(),br(),
                        h1("국내 코로나 확진자 현황"),
                        # Output: KoreaMAP ----
                        leafletOutput(outputId = "kormap",width='100%',height=500) %>% withSpinner (color= "#2ecc71")
                        )
            )),
            fluidRow(
                column(width = 12,offset=0, align="center",
                       # Sidebar layout with input and output definitions ----
                       hr(),br(),
                       h1("코로나 바이러스 발생 추이 예측"),
                       sidebarLayout(
                           # Sidebar panel for inputs ----
                           sidebarPanel(id="sidebar",width=2,
                               # Input: Slider for the number of bins ----
                               sliderInput(
                                   inputId = "days",
                                   label = "Number of days:",
                                   min = 7,
                                   max = 100,
                                   value = 7
                               )
                           ),
                           # Main panel for displaying outputs ----
                            mainPanel(width=10,
                               # Output: Histogram ----
                               plotlyOutput(outputId = "distPlot",height=400) %>% withSpinner( color= "#2ecc71")
                            )
                       )
                )),
        
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
            fluidRow(column(width = 12,offset=0, align="center",
                h1("세계 코로나 확진자 현황"),
                # Output: worldmap ----
                leafletOutput(outputId = "worldmap",width='100%',height=500) %>% withSpinner( color= "#2ecc71")
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


