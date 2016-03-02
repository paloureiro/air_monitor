library (rvest)

pollutants <-  c("SO2","CO","MP10","O3","NO2","IQA")



air <- read_html("http://smac.infoper.net/smac/boletim",na.strings = c("NM","ND"))

air_quality <- air %>% 
        html_nodes("#dados_estacoes td") %>%
        html_text() %>%
        matrix(9,8,byrow=TRUE) 


air_quality <- gsub("NM","NA",air_quality)
air_quality <- gsub("ND","NA",air_quality)
air_quality <- gsub(",",".",air_quality)
air_quality_df <- as.data.frame(air_quality)

as.numeric.factor <- function(x) {as.numeric(levels(x)[x])}

air_quality_num <- as.data.frame(sapply(air_quality_df[,2:7],as.numeric.factor))
colnames(air_quality_num) <- pollutants

na.mean <- function(x) {mean(x,na.rm = TRUE)}

daily_averages <- sapply(air_quality_num,na.mean)
