# load required packages
if(!require(httr)) install.packages("httr", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(jsonlite)) install.packages("jsonlite", repos = "http://cran.us.r-project.org")
if(!require(raster)) install.packages("raster", repos = "http://cran.us.r-project.org")

# load API KEY
load('./DATA/environment.Rdata')

#########################################
# covid19 Data in world
#########################################
res <- GET(paste0('http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19NatInfStateJson?serviceKey=',api_key_decode,'&pageNo=1&numOfRows=10&startCreateDt=',format(Sys.Date()-4,'%Y%m%d'),'&endCreateDt=',format(Sys.Date()-3,'%Y%m%d')))

res %>%
    content(as ='text', encoding ='UTF-8') %>%
    fromJSON() -> json
str(object = json)

if (json$response$header$resultMsg == "NORMAL SERVICE."){
    cat('@ [Success] HTTP Response :',json$response$header$resultMsg,'\n')
}else{
    cat('@ [Fail] HTTP Response Error :',json$response$header$resultMsg,'\n')
    break()
}

df <- json$response$body$items$item
df$createDt<- as.Date(df$createDt,format='%Y-%m-%d')
df$natDeathRate<- as.numeric(df$natDeathRate)

# natDeathRate = natDeathCnt/natDefCnt % 100
df <- df[,c('areaNmEn','stdDay','createDt','natDeathCnt','natDeathRate','natDefCnt','nationNmEn','nationNm','seq')]
df$nationNmEn[df$nationNmEn =="Russia"] <- 'Russian Federation'
df$nationNmEn[df$nationNmEn =='United States of America'] <- "United States"
df$nationNmEn[df$nationNmEn =='Columbia'] <- "Colombia"
df$nationNmEn[df$nationNmEn =='Republic of South Africa'] <- "South Africa"
df$nationNmEn[df$nationNmEn =='Elsalvador'] <- "El Salvador"
df$nationNmEn[df$nationNmEn =='Commonwealth of Dominica'] <- "Dominica"
df$nationNmEn[df$nationNmEn =='Cabo Verd'] <- "Cape Verde"
df$nationNmEn[df$nationNmEn =='Cote d&acute;Ivoire'] <- "C척te d'Ivoire"
df$nationNmEn[df$nationNmEn =='Guinea Bissau'] <- "Guinea-Bissau"
df$nationNmEn[df$nationNmEn =='Brundi'] <- "Burundi"
df$nationNmEn[df$nationNmEn =='DRCongo'] <- "Congo DRC"
df$nationNmEn[df$nationNmEn =='Swatini'] <- "Eswatini"
df$nationNmEn[df$nationNmEn =='Luxemburg'] <- "Luxembourg"
df$nationNmEn[df$nationNmEn =='Montegro'] <- "Montenegro"
df$nationNmEn[df$nationNmEn =='East Timor'] <- "Timor-Leste"
df$nationNmEn[df$nationNmEn =='Brunei'] <- "Brunei Darussalam"


load('./DATA/World_shp.Rdata')

world@data$id = c(1:dim(world@data)[1])
world@data <- merge(world@data,df,by.x='COUNTRYAFF',by.y='nationNmEn',all.x=TRUE)
world@data <- world@data[order(world@data$id),]

save(world, file='./DATA/World_covid19.Rdata')
# write.csv(df,file='./DATA/World_covid19.csv',row.names = FALSE,fileEncoding  = 'UTF-8')
