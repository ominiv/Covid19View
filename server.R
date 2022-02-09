# load required packages
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(raster)) install.packages("raster", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!require(rmapshaper)) install.packages("rmapshaper", repos = "http://cran.us.r-project.org")

load('./DATA/Korea_total_covid19.Rdata')
if(sum(grepl(format(Sys.Date()-1,'%Y-%m-%d'),total$createDt)) == 0){
  source('dailly-update-korea.R')
  source('dailly-update-world.R')
}

server <- function(input, output) {
    #########################################
    # Covid19 in South-Korea
    #########################################
    # Cumulative number of corona infected
    load('./DATA/Korea_total_covid19.Rdata')
  
    output$distPlot <- renderPlot({
      days <-  1:input$days
      #days <- 1:7
      x <- total[days,]
      p <- ggplot(data=x, aes(x=createDt ,y=defCnt)) + 
        geom_bar(stat = 'identity', width=0.5, fill='darkred')+
        theme_bw()+
        theme(axis.text.x=element_text(angle=45, hjust=1))+
        scale_y_continuous(labels = scales::comma)
      p
    })
    
    # South-Korea Map 
    load('./DATA/Korea_gubun_covid19.Rdata')
    pal1 <- colorNumeric("viridis", korea@data$defCnt, reverse=TRUE)
    
    output$kormap <- renderLeaflet({ 
        korDefCnt = reactive({
          format(korea@data$defCnt,big.mark = ',',big.interval = 3)
        })
        korIncDec  = reactive({
          format(korea@data$incDec,big.mark = ',',big.interval = 3)
        })
        korDeathCnt = reactive({
          korea@data$deathCnt
        })
        leaflet(korea) %>%
        setView(lng=127.7669,lat=35.90776, zoom=7) %>%
        addProviderTiles('CartoDB.Positron')%>%
        addPolygons(color='#444', weight=1, fillColor=~pal1(defCnt),
                    label = ~paste0('<b>',gubun,'</b> <br/> ',
                                    'Covid19 Cases : ', korDefCnt(),' (<span style="color: darkred;">',korIncDec(),'</span> ) <br/> ',
                                    'Death Cases : ', korDeathCnt()) %>% lapply(htmltools::HTML),
                    highlight = highlightOptions(weight = 3,color = 'red',bringToFront = TRUE),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "2px 7px"),
                      textsize = "13px",
                      direction = "auto"
                    )
        ) %>%
          addLegend(pal = pal2, values=~world@data$natDefCnt, opacity=0.9, title = "Covid cases", position = "bottomleft" )
      })
    
    #########################################
    # Covid19 in world
    #########################################

    load('./DATA/World_covid19.Rdata')
    pal2 <- colorNumeric("viridis", world@data$natDefCnt, reverse=TRUE)

    output$worldmap <- renderLeaflet({
      DefCnt = reactive({
        format(world@data$natDefCnt,big.mark = ',',big.interval = 3)
      })
      DeathRate = reactive({
        format(world@data$natDeathRate,digits = 2)
      })

      leaflet(world) %>% 
        setView(lng=30.9768,lat=37.5759, zoom=2.5) %>% #126
        addProviderTiles('CartoDB.Positron')%>%
        addPolygons(color='#444', weight=1, fillColor=~pal2(natDefCnt),
                    label = ~paste0('<b>',COUNTRY,'</b> <br/> ',
                                    'Covid19 Cases : ', DefCnt(),' <br/> ',
                                    'DeathRate : ', DeathRate(),'%') %>% lapply(htmltools::HTML),
                    highlight = highlightOptions(weight = 3,color = 'red',bringToFront = TRUE),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "2px 7px"),
                      textsize = "13px",
                      direction = "auto"
                        )
                    ) %>%
        addLegend(pal = pal2, values=~world@data$natDefCnt, opacity=0.9, title = "Covid cases", position = "bottomleft" )
    })

}