# load required packages
if(!require(httr)) install.packages("httr", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(jsonlite)) install.packages("jsonlite", repos = "http://cran.us.r-project.org")
if(!require(raster)) install.packages("raster", repos = "http://cran.us.r-project.org")

# # temp path
# setwd('C:/Users/user/PJT/Study/11.Dashbord/Covid19View')

# load API KEY
load('./DATA/environment.Rdata')

#########################################
# Covid19 Data in south-korea
#########################################
res <- GET(paste0('http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey=',api_key_decode,'&pageNo=1&numOfRows=10&startCreateDt=',format(Sys.Date()-1,'%Y%m%d'),'&endCreateDt=',format(Sys.Date()-1,'%Y%m%d')))

res %>%
    content(as ='text', encoding ='UTF-8') %>%
    fromJSON() -> json
# str(object = json)

if (json$response$header$resultMsg == "NORMAL SERVICE."){
    cat('@ [Success] HTTP Response :',json$response$header$resultMsg,'\n')
}else{
    cat('@ [Fail] HTTP Response Error :',json$response$header$resultMsg,'\n')
    break()
}

df <- json$response$body$items$item
df$createDt<- as.Date(df$createDt,format='%Y-%m-%d')
columns <- c("stdDay","createDt", "deathCnt", "defCnt" ,"incDec","isolClearCnt","localOccCnt",  "overFlowCnt","qurRate","gubun","gubunEn","seq")

#########################################
# Daily total covid19 case count in south-korea
#########################################
load('./DATA/Korea_total_covid19.Rdata')

if(sum(grepl(format(Sys.Date()-1,'%Y-%m-%d'),total$createDt)) == 0){
    tmp_row <- df[df[,'gubunEn']=='Total',columns,drop=FALSE]
    total <- rbind(total, tmp_row)
    total <- total[order(total$createDt,decreasing = TRUE),]
    total$createDt <- as.character(total$createDt)
    save(total,file='./DATA/Korea_total_covid19.Rdata') 
}

#########################################
#  Daily Gubun covid19 case in south-korea
#########################################
df <- df[match(df[,'gubunEn'],c('Total','Lazaretto'),nomatch=0) == 0,columns]
load('./DATA/Korea_shp.Rdata')

korea@data <- merge(korea@data,df,by='gubun')
save(df, korea,file='./DATA/Korea_gubun_covid19.Rdata')
