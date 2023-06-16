# 연습용

#1. 파일 읽어야됨
df <- read.csv("data/시군구_성_월별_출생_2021.csv", fileEncoding = "euc-kr")
df
#2. 전처리 해야함
colnames(df)

#gsub("X","",paste(n[1], n[2], "전체"), sep=".")


f <- function(x) {
  n <- unlist(strsplit(x, "\\."))
  if (length(n) == 1){
    return (x)
  }else if (length(n) == 2){
    return (gsub("X","", paste(n[1], n[2], "전체", sep=".")))
  }else {
    if (identical(n[3], "1")){
      return (gsub("X","", paste(n[1], n[2], "남자", sep=".")))
    }else{
      return (gsub("X","", paste(n[1], n[2], "여자", sep=".")))
    }
  }
  return(n)
}

names(df) <- lapply(colnames(df), f)
names(df)

head(df)
#3 데이터분석이 용이하도록 구조 변경
library(reshape2)


melt_data <- melt(df, id="시군구별")
colnames(melt_data)
melt_data
head(melt_data)
melt_data[melt_data["시군구별"] == "시군구별"]
unique(melt_data$시군구별)

df2 <- melt_data[!(melt_data["시군구별"] == "시군구별"),]
head(df2)

#4 데이터 정리

f1 <- function(x){
  n <- unlist(strsplit(x, "\\."))
  return(n[1])
}
f2 <- function(x){
  n <- unlist(strsplit(x, "\\."))
  return(n[2])
}
f3 <- function(x) {
  n <- unlist(strsplit(x, "\\."))
  return(n[3])
}
colnames(df2)[3] <- "출생아수"
head(df2)
  
df2["연도"] <- apply(df2["variable"], 1, f1)
df2["월"] <- apply(df2["variable"], 1, f2)
df2["성별"] <- apply(df2["variable"], 1, f3)

df_all = df2[(df2["시군구별"]=="전국") & (df2["성별"] == "전체"),]
df_all = df_all[,c("출생아수", "연도", "월")]
df_all

#5 시각화로 확인
sum_agg = aggregate(as.integer(df_all$"출생아수")~as.integer(df_all$"연도"), FUN =sum)

mode(df_all["출생아수"])
mode(df_all$출생아수)
class(df_all["출생아수"])
class(df_all$출생아수)

colnames(sum_agg)[1] <- "연도"
colnames(sum_agg)[2] <- "출생아수"
colnames(sum_agg)

