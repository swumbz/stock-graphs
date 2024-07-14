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
tickers <- c("AAPL", "MO", "NVO", "RIVN")
first_date <- Sys.Date() - 180
last_date <- Sys.Date()
db <- yf_get(
  tickers = tickers,
  first_date = first_date,
  last_date = last_date
)

# Use Quantmod to get historic data and for plots
getSymbols(tickers)
stockEnv <- new.env()
symbols <- getSymbols(tickers, src='yahoo', env=stockEnv)


###### DATA ANALYSIS #######


###### PLOTTING ######
for (stock in ls(stockEnv)){
  chartSeries(stockEnv[[stock]], theme="white", name=tickers,
              TA="addVo();addBBands();addCCI();addSMA(20, col='blue');
        addSMA(5, col='red');addSMA(50, col='black')", subset='last 180 days')     
}
