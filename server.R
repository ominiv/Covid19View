# load required packages
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(raster)) install.packages("raster", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")


server <- function(input, output) {
    #########################################
    # covid19 Data in Republic of Korea 
    #########################################
    # setwd('C:/Users/user/PJT/Study/11.Dashbord/CovidVeiw')
    seoul <- read.csv(file='./DATA/서울특별시 코로나19 자치구별 확진자 발생동향.csv',header=TRUE,sep=',',fill=TRUE,quote='""',   encoding='UTF-8',check.names=FALSE)
    colnames(seoul)[1] <- 'date'
    seoul$date <- gsub('^20\\.','2020.',seoul$date)
    seoul$date <- gsub('.[[:digit:]]$','',seoul$date)
    
    # remove duplication
    seoul <- seoul[!duplicated(seoul$date),]
    
    # date별 확진자수 합
    sumv <- apply(seoul[,c(-1)],1,function(x){sum(x)})
    covid_df <- as.data.frame(seoul$date)
    covid_df= cbind(covid_df,as.numeric(sumv))
    colnames(covid_df) <- c('date', 'seoul')
    head(covid_df)
    
    
    output$distPlot <- renderPlot({
      days <- 1:input$days
      #days <- 1:7
      x <- covid_df[days,]
      p <- ggplot(data=x, aes(x=date,y=seoul)) + geom_bar(stat = 'identity', width=0.5, fill='darkred')+theme_bw()+  theme(axis.text.x=element_text(angle=45, hjust=1))+scale_y_continuous(labels = scales::comma)
      p
    })
    
    output$kormap <- renderLeaflet(
      { data <- data.frame(
        longitude=sample(seq(127,129,0.1),100,replace=T),latitude=sample(seq(35,38,0.1),100,replace=T),value=sample(1:100,100,replace=T)
      )
      
      m <- leaflet(data=data) %>%
        setView(lng=128, lat=37 , zoom=6) %>%
        addProviderTiles(providers$CartoDB.Positron) %>% # map-style 
        addCircles(lng=data$longitude,lat=data$latitude,popup=as.character(data$value),radius=data$value*100,fillColor="blue",stroke=FALSE,fillOpacity=0.4) %>%
        addLegend("bottomleft",colors="blue",title="Color",labels=c(">1000"))
      
      })
    
    #########################################
    # covid19 Data in world
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