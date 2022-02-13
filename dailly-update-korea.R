# ----------------------------------------------
# load required packages
# ----------------------------------------------
if(!suppressWarnings(require(httr))) install.packages("httr", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(dplyr))) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(jsonlite))) install.packages("jsonlite", repos = "http://cran.us.r-project.org")
if(!suppressWarnings(require(raster))) install.packages("raster", repos = "http://cran.us.r-project.org")

# ----------------------------------------------
# load API KEY
# ----------------------------------------------
# # temp path
# setwd('C:/Users/user/PJT/Study/11.Dashbord/Covid19View')
load('./DATA/environment.Rdata')

# ----------------------------------------------
# OPENAPI GET (Covid Cases)
# ----------------------------------------------
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


# -- Create Total Dataset

load('./DATA/Korea_total_covid19.Rdata')

if(sum(grepl(format(Sys.Date()-1,'%Y-%m-%d'),total$createDt)) == 0){
    tmp_row <- df[df[,'gubunEn']=='Total',columns,drop=FALSE]
    total <- rbind(tmp_row, total)
    total <- total[order(total$createDt,decreasing = TRUE),]
    total$createDt <- as.character(total$createDt)
    save(total,file='./DATA/Korea_total_covid19.Rdata') 
    write.csv(total,file='./DATA/Korea_total_covid19.csv',row.names = FALSE,fileEncoding  = 'UTF-8')
}


# -- Create Daily Dataset
df <- df[match(df[,'gubunEn'],c('Total','Lazaretto'),nomatch=0) == 0,columns]
load('./DATA/Korea_shp.Rdata')

korea@data <- merge(korea@data,df,by='gubun')
save(df, korea,file='./DATA/Korea_gubun_covid19.Rdata')


# ----------------------------------------------
# OPENAPI GET (GenAge Info)
# ----------------------------------------------
res <- GET(paste0('http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19GenAgeCaseInfJson?serviceKey=',api_key_decode,'&pageNo=1&numOfRows=10&startCreateDt=',format(Sys.Date()-1,'%Y%m%d'),'&endCreateDt=',format(Sys.Date()-1,'%Y%m%d')))

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

GenAge <- json$response$body$items$item
GenAge$createDt<- as.Date(GenAge$createDt,format='%Y-%m-%d')
GenAge <- GenAge[order(GenAge$createDt,decreasing = TRUE),]
GenAge$gubun[c(9,10,11)] <- c('80 -','female','male')
save(GenAge, file='./DATA/Korea_GenAge.Rdata')


# ----------------------------------------------
# OPENAPI GET (Vaccine Info)
# ----------------------------------------------
# Daily
res <- GET(paste0('https://api.odcloud.kr/api/15077756/v1/vaccine-stat?page=1&perPage=1&cond%5BbaseDate%3A%3AGTE%5D=',format(Sys.Date()-1,'%Y-%m-%d'),'&cond%5Bsido%3A%3AEQ%5D=%EC%A0%84%EA%B5%AD&serviceKey=',api_key_encode))

res %>%
    content(as ='text', encoding ='UTF-8') %>%
    fromJSON() -> json
# str(object = json)

df <- json$data
df$baseDate<- as.Date(df$baseDate,format='%Y-%m-%d')


# -- Create Total Dataset

load('./DATA/VaccineStat.Rdata')

if(sum(grepl(format(Sys.Date()-1,'%Y-%m-%d'),VaccineStat$baseDate)) == 0){
    VaccineStat <- rbind(df, VaccineStat)
    VaccineStat <- VaccineStat[order(VaccineStat$baseDate,decreasing = TRUE),]
    VaccineStat$baseDate <- as.character(VaccineStat$baseDate)
    save(VaccineStat, file='./DATA/VaccineStat.Rdata')
    write.csv(VaccineStat, file='./DATA/VaccineStat.csv',row.names = FALSE,fileEncoding  = 'UTF-8')
}


# ----------------------------------------------
# Merge (Covid Cases / Vaccine Info)
# ----------------------------------------------
load('./DATA/Korea_total_covid19.Rdata')
load('./DATA/VaccineStat.Rdata')
merged_df <- merge(total, VaccineStat, by.x='createDt' ,by.y='baseDate', all.x=TRUE)
merged_df <- merged_df[order(as.Date(merged_df$createDt),decreasing = TRUE),]

# save(merged_df, file='./DATA/Merged_Data.Rdata')
write.csv(merged_df, file='./DATA/Merged_Data.csv',row.names = FALSE,fileEncoding  = 'UTF-8')

