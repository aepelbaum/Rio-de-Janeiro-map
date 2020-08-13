#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
# https://cran.r-project.org/web/packages/geobr/vignettes/intro_to_geobr.html
library(geobr)
library(shiny)

df_rj <- read_municipality( code_muni = "RJ", year= 2018) %>% 
  mutate(name_muni=str_replace_all(name_muni, " De "," de ")) %>% 
  mutate(name_muni=str_replace_all(name_muni, " Do "," do ")) %>% 
  mutate(name_muni=str_replace_all(name_muni, " Dos "," dos "))

df_municipios_rj <- df_rj$name_muni %>% fct_inorder()

# Define UI for application that draws a map
ui <- fluidPage(

    # Application title
    titlePanel("Índices dos municípios do Rio de Janeiro"),

    sidebarLayout(
      sidebarPanel(
        radioButtons("indice", label = "Selecione", c("Área" = "area",
                                                                "Densidade demográfica" = "dens_demo",
                                                                "Escolaridade" = "escolaridade",
                                                                "IDH" = "idh",
                                                                "Mortalidade infantil (mortes por mil nascimentos)" = "mortalidade_infantil",
                                                                "População" = "populacao"), 
                     selected = 1)
      ),
      
      # Show map
      mainPanel(
        plotOutput("drawMap")
      )
    )
)

# Define server logic required to draw a map
server <- function(input, output) {

    output$drawMap <- renderPlot({
        df_rj %>% ggplot() +
            geom_sf(size=.15, show.legend = FALSE) +
            geom_sf(fill = "blue", data = df_rj %>% filter(name_muni == input$municipio)) + 
            theme_minimal() +
            coord_sf(datum = NA)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
