#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(flexdashboard)
library(tidyverse)
library(sf)
library(rgdal)
library(rgeos)
# https://cran.r-project.org/web/packages/geobr/vignettes/intro_to_geobr.html
library(geobr)
library(ggthemes)
library(shiny)

df_rj <- read_municipality( code_muni = "RJ", year= 2018) %>% 
    mutate(name_muni=str_replace_all(name_muni, " De "," de ")) %>% 
    mutate(name_muni=str_replace_all(name_muni, " Do "," do ")) %>% 
    mutate(name_muni=str_replace_all(name_muni, " Dos "," dos "))

df_municipios_rj <- df_rj$name_muni %>% fct_inorder()


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Municípios do Rio de Janeiro"),

    # Sidebar with a slider input for number of bins 
    selectInput("municipio",
                label = "Selecione o município")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # output$distPlot <- renderPlot({
    #     df_rj %>% ggplot() +
    #         geom_sf(color="#FEBF57", size=.15, show.legend = FALSE) +
    #         theme_minimal() +
    #         labs(x = NULL,
    #              Y = NULL)
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)
