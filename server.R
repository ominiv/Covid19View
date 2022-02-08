# load required packages
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(raster)) install.packages("raster", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!require(rmapshaper)) install.packages("rmapshaper", repos = "http://cran.us.r-project.org")

server <- function(input, output) {
    #########################################
    # Covid19 in South-Korea
    #########################################
    load('./DATA/Korea_total_covid19.Rdata')
    
    # Cumulative number of corona infected
    output$distPlot <- renderPlot({
      days <- 1:input$days
      #days <- 1:7
      x <- total[days,]
      p <- ggplot(data=x, aes(x=createDt ,y=defCnt)) + 
        geom_bar(stat = 'identity', width=0.5, fill='darkred')+
        theme_bw()+
        theme(axis.text.x=element_text(angle=45, hjust=1))+
        scale_y_continuous(labels = scales::comma)
      p
    })
    
    load('./DATA/Korea_gubun_covid19.Rdata')
    df <- df[-c(1),]
    korea <- shapefile('./DATA/CTPRVN_202101/TL_SCCO_CTPRVN.shp')
    # light_kor <- ms_simplify(korea)
    # library('rmapshaper')
    
    korea = spTransform(x = korea, CRSobj = CRS('+proj=longlat +datum=WGS84'))
    korea@data$gubun <- c('강원','경기','경남','경북','광주','대구','대전','부산','서울','세종','울산','인천','전남','전북','제주', '충남','충북')

    korea@data <- merge(korea@data,df,by='gubun')
    pal2 <- colorNumeric("viridis", korea@data$defCnt, reverse=TRUE)# 
    
    output$kormap <- renderLeaflet({ 
        x = reactive({
          korea@data$defCnt
        })
        leaflet(korea) %>%
        setView(lng=127.7669,lat=35.90776, zoom=7) %>%
        addProviderTiles('CartoDB.Positron')%>%
        addPolygons(color='#444', weight=1, fillColor=~pal2(defCnt),
                    label = ~paste0(gubun, ' : ', x()),
                    highlight = highlightOptions(weight = 3,color = 'red',bringToFront = TRUE)) %>%
        addLegend("bottomleft",colors="blue",title="Color",labels=c(">1000"))
      })
    
    #########################################
    # Covid19 in world
    #########################################
    # source('dailly-update-world.R')
    load('./DATA/World_covid19.Rdata')

    output$worldmap <- renderLeaflet(
      { data <- data.frame(
        longitude=sample(seq(127,129,0.1),100,replace=T),latitude=sample(seq(35,38,0.1),100,replace=T),value=sample(1:100,100,replace=T)
        )
      
      m <- leaflet(data=data) %>%
        setView(lng=128, lat=37 , zoom=6) %>%
        addProviderTiles(providers$CartoDB.Positron) %>% # map-style 
        addCircles(lng=data$longitude,lat=data$latitude,popup=as.character(data$value),radius=data$value*100,fillColor="blue",stroke=FALSE,fillOpacity=0.4) %>%
        addLegend("bottomleft",colors="blue",title="Color",labels=c(">1000"))
      
    })

}