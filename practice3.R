#미국 나스닥 데이터 분석

#주제: 확정해야됨
# 0. 패키지 불러오기
library(tidyverse)

# 1. 데이터 프레임 만들기
# 파일 목록을 다 들고 와야됨
files <- list.files(path = "data/nasdaq_stock/")
files
# 들고온 파일목록을 다 읽어서 데이터프레임들을 결합
stocks <- read_csv(paste0("data/nasdaq_stock/", files), id = "name") %>% 
  mutate(name = gsub("data/nasdaq_stock/", "", name),
         name = gsub("\\.csv", "", name)) %>% 
  rename_with(tolower)
stocks
df <-read_csv("data/nasdaq_stock_names/nasdaq_stock_names.csv")

stocks <- stocks %>% 
  inner_join(df, by = c("name" = "stock_symbol"))
# 2. 시계열 데이터 시각화
(stocks %>% 
  group_by(company) %>% 
  filter(date == max(date)) %>% 
  arrange(-open) %>% 
  select(open, company))[c(1:3, 12:14),]

end_labels <- (stocks %>% 
    group_by(company) %>% 
    filter(date == max(date)) %>% 
    arrange(-open) %>% 
    select(open, company))[c(1:3, 12:14),]

stocks %>% 
  ggplot(aes(date,open)) +
  geom_line(aes(color = company))

# 3. 시계열 데이터 분리
#stocks %>% 
 # geom_,ine(aes(color = company)) +
#  scale_continuous(sec.axis = sec.axis(~, breaks = end_labels$open,
                                       labels = end_labels$company))
#  scale_x_date(expand = c(0,0))
  
  
  
(stocks %>%
     filter(company %in% end_labels$company[1:3]) %>%
     ggplot(aes(date, open)) +
     geom_line(aes(color = company)) +
     facet_wrap(~company) +
     theme_bw() +
     theme(legend.position = "none") +
     labs(title = "Top 3", x = "")) / 
(stocks %>%
     filter(company %in% end_labels$company[-(1:3)]) %>%
     ggplot(aes(date, open)) +
     geom_line(aes(color = company)) +
     facet_wrap(~company) +
     theme_bw() +
     theme(legend.position = "none") +
     labs(title = "Bottom 3", x = ""))
  
aapl <-
    (stocks %>%
       group_by(company) %>%
       filter(date == max(date)) %>%
       arrange(-open) %>%
       select(open, company))[c(1:3,12:14),]
# 4. 종가율 예측


stocks %>% 
  filter(name == "AAPL") %>% 
  select (ds = date, y = open)

(aapl %>% 
    mutate(diff = c(NA, diff(y))) %>% 
    ggplot(aes(ds, diff)) + 
    geom_point(color = "steelblue4", alpha = 0.7) +
    labs(y = "Difference", x = "Date",
         title = "One Day Returns")
) /
  (aapl %>% 
     mutate(diff = c(NA, diff(y))) %>% 
     ggplot(aes(diff)) +
     geom_histogram(bins = 50, fill = "steelblue4", color = "black")
  )

m_aapl <- prophet(aapl)

