setwd('C:/Users/user/PJT/Study/11.Dashbord/Covid19View')
load('./DATA/environment.Rdata')

# ----------------------------------------------
# OPENAPI GET (Covid Cases)
# ----------------------------------------------
# total
res <- GET(paste0('http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey=',api_key_decode,'&pageNo=1&numOfRows=10&startCreateDt=20200101&endCreateDt=',format(Sys.Date()-1,'%Y%m%d')))

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
columns <- c("stdDay","createDt", "deathCnt", "defCnt" ,"incDec","isolClearCnt","localOccCnt",  "overFlowCnt","qurRate","gubun","gubunEn","seq")
df <- df[df[,'gubunEn']=='Total',columns]
df <- df[order(df$createDt,decreasing = TRUE),]
df$createDt <- as.character(df$createDt)
total <- df
save(total,file='./DATA/Korea_total_covid19.Rdata') 
write.csv(total,file='./DATA/Korea_total_covid19.csv',row.names = FALSE,fileEncoding  = 'UTF-8')



# ----------------------------------------------
# OPENAPI GET (Vaccine Info)
# ----------------------------------------------
# total
res <- GET(paste0('https://api.odcloud.kr/api/15077756/v1/vaccine-stat?page=1&perPage=7200&cond%5BbaseDate%3A%3AGTE%5D=2020-01-01&cond%5Bsido%3A%3AEQ%5D=%EC%A0%84%EA%B5%AD&serviceKey=',api_key_encode))

res %>%
    content(as ='text', encoding ='UTF-8') %>%
    fromJSON() -> json
str(object = json)


VaccineStat <- json$data
VaccineStat$baseDate<- as.Date(VaccineStat$baseDate,format='%Y-%m-%d')
VaccineStat <- VaccineStat[order(VaccineStat$baseDate,decreasing = TRUE),]
VaccineStat$baseDate <- as.character(VaccineStat$baseDate)
save(VaccineStat, file='./DATA/VaccineStat.Rdata')
write.csv(VaccineStat, file='./DATA/VaccineStat.csv',row.names = FALSE,fileEncoding  = 'UTF-8')

