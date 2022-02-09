library(shiny)
library(leaflet)
library(shinycssloaders)
ui <- navbarPage(
    'Covid19Veiw',
    # Number of Covid19 Case in Korea
    tabPanel(
        'South-Korea',
        fluidPage(
            # Load a different font for the app
            tags$head(
                tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Source+Sans+Pro")
            ),
            
            # This is to explain you have a CSS file that custom the appearance of the app
            includeCSS("www/test.css") ,
            
            fluidRow(
                column(
                width = 12, offset=0, align="center",
                            theme='bootstrap.min.css',
                            # App title ----
                            h2("국내 코로나 확진자 현황"),
                            # Output: KoreaMAP ----
                            leafletOutput(outputId = "kormap",width='100%',height=500) %>% withSpinner( color= "#2ecc71")
                            )

            )),
            fluidRow(
                column(width = 6,
                       # radioButtons("days", "Period :",
                       #              c("7 days" = 7,
                       #                "1 month" =30,
                       #                "2 month" = "2month",
                       #                "3 month" = "3month")),
                       # Sidebar layout with input and output definitions ----
                       sidebarLayout(
                           # Sidebar panel for inputs ----
                           sidebarPanel(
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
                            mainPanel(
                               # Output: Histogram ----
                               plotOutput(outputId = "distPlot",height=400) %>% withSpinner( color= "#2ecc71")
                            )
                       )
                ))
            ),
    tabPanel(
        'World',
        fluidPage(
            fluidRow(column(width = 12,offset=0, align="center",
                # App title ----
                h2("세계 코로나 확진자 현황"),
                # Output: worldmap ----
                leafletOutput(outputId = "worldmap",width='100%',height=500) %>% withSpinner( color= "#2ecc71")
            )),
            fluidRow(
                column(width = 6,div(style = "height:150px;background-color: green;", "Bottomleft")),
                column(width = 6,div(style = "height:150px;background-color: green;", "Bottomright")))
            )
    )
)


