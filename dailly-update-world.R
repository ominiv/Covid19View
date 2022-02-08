# load required packages
if(!require(httr)) install.packages("httr", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(jsonlite)) install.packages("jsonlite", repos = "http://cran.us.r-project.org")

# load API KEY
load('./DATA/environment.Rdata')

#########################################
# covid19 Data in world
#########################################
res <- GET(paste0('http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19NatInfStateJson?serviceKey=',api_key_decode,'&pageNo=1&numOfRows=10&startCreateDt=',format(Sys.Date()-2,'%Y%m%d'),'&endCreateDt=',format(Sys.Date()-1,'%Y%m%d')))

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

# natDeathRate = natDeathCnt/natDefCnt % 100
df <- df[,c('areaNmEn','stdDay','createDt','natDeathCnt','natDeathRate','natDefCnt','nationNmEn','nationNm','seq')]

save(df,file='./DATA/World_covid19.Rdata')
# write.csv(df,file='./DATA/World_covid19.csv',row.names = FALSE,fileEncoding  = 'UTF-8')
