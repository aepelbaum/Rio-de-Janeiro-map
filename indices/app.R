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

#Lê CSV com indices dos municípios do Rio de Janeiro
df_indice <- read_csv2("../data/dados-rj.csv", col_names = TRUE,
                       locale = locale(encoding = "ISO-8859-1"), col_types = NULL) %>% 
  rename(code_muni = codigo_municipio)

df_rj <- read_municipality( code_muni = "RJ", year= 2018) %>% 
  mutate(name_muni=str_replace_all(name_muni, " De "," de ")) %>% 
  mutate(name_muni=str_replace_all(name_muni, " Do "," do ")) %>% 
  mutate(name_muni=str_replace_all(name_muni, " Dos "," dos "))

df_municipios_rj <- df_rj$name_muni %>% fct_inorder()

df_rj_indice <- df_rj %>% 
  left_join(df_indice, by = "code_muni")

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
                  geom_sf(data=df_rj_indice, aes(fill=area), color= "black", size=.15) +
                  labs(subtitle="População dos municípios do RIo de Janeiro", size=8) +
                  # scale_fill_distiller(palette = "Blues", name="População", limits = c(min(df_rj_indice$populacao),max(df_rj_indice$populacao))) +
                  #  scale_fill_continuous(name = "Área", label = scales::comma) +
                  scale_fill_continuous(low = "white", high = "red",name = "Área", label = scales::comma) +
                  theme_minimal() #+
                  #no_axis
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
