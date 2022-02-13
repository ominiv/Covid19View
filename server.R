# ----------------------------------------------
# load required packages
# ----------------------------------------------
if(!suppressWarnings(require(ggplot2))) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(leaflet))) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(dplyr))) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(raster))) install.packages("raster", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(sf))) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(rmapshaper))) install.packages("rmapshaper", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(plotly))) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(gapminder))) install.packages("gapminder", repos = "http://cran.us.r-project.org")

# ----------------------------------------------
# Update Daily Dataset 
# ----------------------------------------------
# setwd('C:/Users/user/PJT/Study/11.Dashbord/Covid19View')
load('./DATA/Korea_total_covid19.Rdata')

if(sum(grepl(format(Sys.Date()-1,'%Y-%m-%d'),total$createDt)) == 0){
  source('dailly-update-korea.R')
  source('dailly-update-world.R')
}

# ----------------------------------------------
# Server
# ----------------------------------------------
server <- function(input, output) {
    #########################################
    # Covid19 in South-Korea
    #########################################
    # Cumulative number of corona infected
    load('./DATA/Korea_total_covid19.Rdata')
    preds = read.table('./DATA/Prediction_Confirmed_Case.csv',sep=',',header = TRUE)
    colnames(preds) <- c('createDt','defCnt','label')
 
    output$reactive_case_count <- renderText({
      if((total$defCnt[1]-total$defCnt[2])>=0){
          paste0(format(total$defCnt[1] ,big.mark = ',',big.interval = 3), ' (+',format(total$defCnt[1]-total$defCnt[2] ,big.mark = ',',big.interval = 3),')')
      }else{
          paste0(format(total$defCnt[1] ,big.mark = ',',big.interval = 3), ' (',format(total$defCnt[1]-total$defCnt[2] ,big.mark = ',',big.interval = 3),')')

      }
    })
    output$reactive_death_count <- renderText({
      if((total$deathCnt[1]-total$deathCnt[2])>=0){
        paste0(format(total$deathCnt[1] ,big.mark = ',',big.interval = 3), ' (+', format(total$deathCnt[1]-total$deathCnt[2] ,big.mark = ',',big.interval = 3),')')
      }else{
        paste0(format(total$deathCnt[1] ,big.mark = ',',big.interval = 3), ' (',format(total$deathCnt[1]-total$deathCnt[2] ,big.mark = ',',big.interval = 3),')')
      }
    })
    output$reactive_deathrate_count <- renderText({
        paste0(format(total$deathCnt[1]/total$defCnt[1]*100,digits=2),'%')
    })
    output$reactive_clear_count <- renderText({
      if((total$isolClearCnt[1]-total$isolClearCnt[2])>=0){
        paste0(format(total$isolClearCnt[1] ,big.mark = ',',big.interval = 3), ' (+', format(total$isolClearCnt[1]-total$isolClearCnt[2] ,big.mark = ',',big.interval = 3),')')
      }else{
        paste0(format(total$isolClearCnt[1] ,big.mark = ',',big.interval = 3), ' (',format(total$isolClearCnt[1]-total$isolClearCnt[2] ,big.mark = ',',big.interval = 3),')')
      }
    })
    output$reactive_update <- renderText({
        paste0('Last Updated at ', total$createDt[1])
    })
    
    output$ConfirmedBarPlot <- renderPlotly({
      # days <-  1:input$days
      # days <- 1:28
      # x <- preds[,colnames(preds)]
      historic_pos <- c(preds$label=='Historic')
      forecast_pos <- c(preds$label=='Forecast')
      historic_df <- tail(preds[historic_pos,],n=21)
      forecast_df <- head(preds[forecast_pos,],n=7)
      x <- rbind(historic_df, forecast_df)
      
      p <- ggplotly(ggplot(data=x) + 
        geom_bar(aes(x=createDt ,y=defCnt,fill=label), stat = 'identity', width=0.5)+
        geom_line(aes(x=createDt, y=defCnt),stat="identity",color="darkred",size=0.2, group = 1)+
        scale_fill_manual(values = c('#1E88E5','#E57373'))+
        theme_bw()+
        theme(axis.text.x=element_text(angle=45, hjust=1))+
        guides(fill=guide_legend(title=""))+
        scale_y_continuous(labels = scales::comma)+
          xlab(" ") +
          ylab(" ")
        )
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
                    label = ~paste0('<b>',gubunEn,'</b> <br/> ',
                                    'Confirmed Cases : ', korDefCnt(),' (<span style="color: darkred;">',korIncDec(),'</span> ) <br/> ',
                                    'Death Cases : ', korDeathCnt()) %>% lapply(htmltools::HTML),
                    highlight = highlightOptions(weight = 3,color = 'red',bringToFront = TRUE),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "2px 7px"),
                      textsize = "14px",
                      direction = "auto"
                    )
        ) %>%
          addLegend(pal = pal2, values=~world@data$natDefCnt, opacity=0.9, title = "Covid cases", position = "bottomleft" )
      })
    
    # South-Korea Pie
    load('./DATA/Korea_GenAge.Rdata')
    Age_df <- GenAge[-c(match(c('male','female'),GenAge$gubun)),]
    Sex_df <- GenAge[c(match(c('male','female'),GenAge$gubun)),]
    colors <- c('rgb(148,212,192)', 'rgb(175,189,219)', 'rgb(193,228,136)', 'rgb(237,214,180)', 'rgb(253,175,145)','rgb(240, 192, 206)','rgb(238,173,213)','rgb(255,228,110)','rgb(202,202,202)')
    sex_colors <- c('rgb(245, 73, 73), rgb(81, 102, 207)')
    output$AgePie <- renderPlotly({
      fig <- plot_ly(Age_df,textinfo = 'label+percent',
                     showlegend = FALSE) %>% 
                     add_pie(data=Sex_df, labels= ~gubun, values = ~ confCase,hole = 0.7,sort = F,
                             marker = list(colors = sex_colors, line = list(color = '#FFFFFF', width = 1))) %>% 
                     add_pie(data=Age_df, labels= ~gubun, values = ~ confCase,hole = 0.6,sort = F,
                             marker = list(colors = colors, line = list(color = '#FFFFFF', width = 1)),
                             domain = list(
                             x = c(0.15, 0.85),
                             y = c(0.15, 0.85)))
    })

    #########################################
    # Covid19 in world
    #########################################
    load('./DATA/World_covid19.Rdata')
    pal2 <- colorNumeric("viridis", world@data$natDefCnt, reverse=TRUE)
    output$worldtable <- renderDataTable(world@data[!duplicated(world@data$areaNm),c('COUNTRYAFF','createDt', 'natDeathCnt', 'natDeathRate', 'natDefCnt')])
    output$worldmap <- renderLeaflet({
      DefCnt = reactive({
        format(world@data$natDefCnt,big.mark = ',',big.interval = 3)
      })
      DeathRate = reactive({
        format(world@data$natDeathRate,digits = 2)
      })
      DeathCnt = reactive({
        format(world@data$natDeathCnt,big.mark = ',',big.interval = 3)
      })
      leaflet(world) %>% 
        setView(lng=30.9768,lat=37.5759, zoom=2.5) %>% #126
        addProviderTiles('CartoDB.Positron')%>%
        addPolygons(color='#444', weight=1, fillColor=~pal2(natDefCnt),
                    label = ~paste0('<b>',COUNTRY,'</b> <br/> ',
                                    'Confirmed Cases : ', DefCnt(),' <br/> ',
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