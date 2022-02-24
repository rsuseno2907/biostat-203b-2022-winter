#Load libraries
library(shiny)

#Load dataset
icu_cohort <- readRDS("icu_cohort.rds")

#ui defines how your app will look like
ui <- fluidPage(
  
  titlePanel("Mimic ICU Cohort Data Exploration and Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      #TODO decide what to put as inputs here
      helpText("This panel allows you to pick information to display 
               on the right-hand side of this screen"),
      selectInput("varname1",
                  label = "Choose variable of interest",
                  choices = c("",""), #what's on the dropdown menu
                  selected = ""), #the default that shows up
      sliderInput("varname2",
                  label = "slide",
                  min = 0, max = terserah)
    ),
    
    mainPanel(
      #TODO decide what to put as outputs here (what kind of plot)
    )
  )
  
)

#Server logic, obtain data etc
server <- function(input, output) {
  
  
  
}

shinyApp(ui = ui, server = server)