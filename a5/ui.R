#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(markdown)
source("server.R")

country_list <- unique(country_co2_data_recent$country)

intro_panel <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  verticalLayout(
    htmlOutput("html")
  )
)

line_main_content <- mainPanel(
  plotlyOutput("line")
)

line_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "country",
    label = "Country",
    choices = country_list,
    selected = "United States"),
  sliderInput(
    inputId = "year",
    label = "Years",
    min = 1750, max = 2021, value = c(1750,2021), sep = "")
)

caption_content <- mainPanel(
  HTML('
  <div>
    <h1 style="font-size:30px;">Caption</h1>
    <p style="font-size:14px;">
    In this chart, we can clearly see the trend of production based CO2 emissions from oil (in million tonnes) increasing as the year goes on. This trend of increasing emissions started off in about the 1900s in the United States and continues to increase. Other countries like Ukraine have decreased emission starting in the 2000s. Many countries have different trends, but one trend that is consistent is that there has been an increasing amount of CO2 emissions.
    </p>
  </div>')
)

line_panel <- tabPanel(
  "Line Graph",
  titlePanel("CO2 caused by Oil vs Year by Country"),
  sidebarLayout(
    line_sidebar_content,
    line_main_content),
  verticalLayout(
    caption_content
  )
)

ui <- navbarPage(
  "A5",
  intro_panel,
  line_panel
)
