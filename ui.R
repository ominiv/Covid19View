library(shiny)
library(leaflet)
library(shinycssloaders)
ui <- navbarPage(
    'Covid19Veiw',
    # Number of Covid19 Case in Korea
    tabPanel(
        'South-Korea',
        fluidPage(
            fluidRow(column(
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
                               plotOutput(outputId = "distPlot",height=400)
                           )
                       )
                ))
            ),
    tabPanel(
        'World',
        fluidPage(
            fluidRow(column(width = 12,
                theme='bootstrap.min.css',
                # App title ----
                titlePanel("World"),
                # Main panel for displaying outputs ----
                mainPanel(
                    # Output: Histogram ----
                    leafletOutput(outputId = "worldmap",height=800)
                )
                )
            )),
            fluidRow(
                column(width = 6,div(style = "height:150px;background-color: green;", "Bottomleft")),
                column(width = 6,div(style = "height:150px;background-color: green;", "Bottomright")))
            )
)


