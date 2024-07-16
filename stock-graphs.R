rm(list = ls())

###### LIBRARIES AND SETUP #######

# Plotting Packages
library(ggplot2)
library(ggthemes)

# Data Packages
library(csvread)
library(reshape2)
library(dplyr)
library(tidyverse)

# Financial Packages
library(yfR)
library(quantmod)
library(WeibullR)
library(edgar)

###### DATA IMPORT #######

# Select the stocks you want and the date range
tickers <- c("TSLA","MO","BRK-A","F")
first_date <- Sys.Date() - 360
last_date <- Sys.Date()
db <- yf_get(
  tickers = tickers,
  first_date = first_date,
  last_date = last_date
)

# New column for percentage movement from nominal starting point
db$percent_adj_movement <- (db$cumret_adjusted_prices-1)*100

# Use Quantmod to get historic data and for plots
getSymbols(tickers)
stockEnv <- new.env()
symbols <- getSymbols(tickers, src='yahoo', env=stockEnv)


###### DATA ANALYSIS #######
F <- na.omit(F)
F$MA_50 <- SMA(F$F.Close, n = 50)
F$MA_200 <- SMA(F$F.Close, n = 200)

###### PLOTTING ######

# Plot all 4 graphs in a standard format
for (stock in ls(stockEnv)){
  chartSeries(stockEnv[[stock]], theme="white", name=tickers,
              TA="addVo();addBBands();addCCI();addSMA(20, col='blue');
        addSMA(5, col='red');addSMA(50, col='black')", subset='last 180 days')     
}

# Plot 1 covering generic adjusted data for each company
p1 <- ggplot(data=db, aes(x=ref_date)) +
  geom_line(aes(y=percent_adj_movement, color=ticker)) +
  theme_bw() +
  xlab('Date') + ylab('Percent Change [%]') +
  ggtitle('Stock Performance Over Period of Time') +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_discrete(name = "Stocks")
p1

# Plot only 1 stock
p2 <- ggplot(data = F, aes(x = Index)) +
  geom_line(aes(y = F.Close), color = "blue", size = 1) +
  geom_line(aes(y = MA_50), color = "orange", size = 1) +
  geom_line(aes(y = MA_200), color = "red", size = 1) +
  labs(title = "Ford Stock Price with Moving Averages",
       x = "Date", y = "Price") +
  scale_y_log10() +
  theme_minimal()
p2

