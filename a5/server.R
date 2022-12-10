#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

co2_data <- read.csv("owid-co2-data.csv")

# Recent Year

co2_data_recent <- co2_data %>% filter(year == max(year)) 

# World's total co2 emission 

co2_data_highest <- function(){
  co2_data_recent <- co2_data %>% filter(year == max(year)) 
  co2_data_highest <- co2_data_recent %>% filter(co2 == max(co2, na.rm = TRUE)) %>% pull(co2)
  co2_data_highest <- prettyNum(co2_data_highest, big.mark = ",", scientific = FALSE)
  return(co2_data_highest)
}

co2_data_highest()

co2_data_highest_p <- function(){
  co2_data_recent <- co2_data %>% filter(year == max(year)) 
  co2_data_highest_p <- co2_data_recent %>% filter(co2 == max(co2, na.rm = TRUE)) %>% pull(population)
  co2_data_highest_p <- prettyNum(co2_data_highest_p, big.mark = ",", scientific = FALSE)
  return(co2_data_highest_p)
}

co2_data_highest_p()

# Filter only Individual Countries (without ISO Codes)

country_co2_data_recent <- co2_data_recent %>% arrange(iso_code) %>% slice(-(1:30)) %>% drop_na(oil_co2)

# Filter country with highest co2 due to Oil

co2_data_high <- function() {
  co2_data_recent <- co2_data %>% filter(year == max(year)) 
  country_co2_data_recent <- co2_data_recent %>% arrange(iso_code) %>% slice(-(1:30))
  co2_data_high <- country_co2_data_recent %>% filter(oil_co2 == max(oil_co2, na.rm = TRUE)) %>% pull(country)
  return(co2_data_high)
}

co2_data_high()

co2_data_high_oil <- function() {
  co2_data_recent <- co2_data %>% filter(year == max(year)) 
  country_co2_data_recent <- co2_data_recent %>% arrange(iso_code) %>% slice(-(1:30))
  co2_data_high_oil <- country_co2_data_recent %>% filter(oil_co2 == max(oil_co2, na.rm = TRUE)) %>% pull(oil_co2)
  co2_data_high_oil <- prettyNum(co2_data_high_oil, big.mark = ",", scientific = FALSE)
  return(co2_data_high_oil)
}

co2_data_high_oil()

# Filter country with lowest co2 due to Oil

co2_data_low <- function() {
  co2_data_recent <- co2_data %>% filter(year == max(year)) 
  country_co2_data_recent <- co2_data_recent %>% arrange(iso_code) %>% slice(-(1:30))
  co2_data_low <- country_co2_data_recent %>% filter(oil_co2 == min(oil_co2, na.rm = TRUE)) %>% pull(country)
  return(co2_data_low)
}

co2_data_low()

co2_data_low_oil <- function() {
    co2_data_recent <- co2_data %>% filter(year == max(year)) 
    country_co2_data_recent <- co2_data_recent %>% arrange(iso_code) %>% slice(-(1:30))
    co2_data_low_oil <- country_co2_data_recent %>% filter(oil_co2 == min(oil_co2, na.rm = TRUE)) %>% pull(oil_co2)
    return(co2_data_low_oil)
}

co2_data_low_oil()

# For Line Chart 

co2_data_line <- co2_data %>% arrange(iso_code) %>% slice(-(1:30)) %>% select(year, country, oil_co2,co2) %>% drop_na()

  
server <- function(input, output) { 
  output$line <- renderPlotly({
    co2_data_line <- co2_data_line %>% filter(country == input$country) %>% filter(year >= input$year[1], year <= input$year[2])
    p <- plot_ly(data = co2_data_line,
                 x = co2_data_line[, "year"],
                 y = co2_data_line[, "oil_co2"],
                 type = "scatter",
                 mode = "line",
                 opacity = 1) %>%
      layout(title = paste0("CO2 Caused by Oil", " VS ", "Year", " of ", input$country),
             xaxis = list(title = paste0("Year")),
             yaxis = list(title = paste0("CO2 Caused by Oil (million tonnes)")))
    return(p)
  })
  output$html <- renderUI({           
    includeMarkdown(knitr::knit('intro.RMD'))          
  })
}