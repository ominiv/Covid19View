# Korea SHP file loading
korea <- shapefile('./DATA/CTPRVN_202101/TL_SCCO_CTPRVN.shp')
korea = spTransform(x = korea, CRSobj = CRS('+proj=longlat +datum=WGS84'))
korea@data$gubun <- c('강원','경기','경남','경북','광주','대구','대전','부산','서울','세종','울산','인천','전남','전북','제주', '충남','충북')
save(korea, file='./DATA/Korea_shp.Rdata')

# World SHP file loading
world <- shapefile('./DATA/UIA_World_Countries_Boundaries/World_Countries__Generalized_.shp')
world = spTransform(x = world, CRSobj = CRS('+proj=longlat +datum=WGS84'))
save(world, file='./DATA/World_shp.Rdata')
