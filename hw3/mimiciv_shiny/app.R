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
      selectInput("demographic",
                  label = "What kind of demographics are you interested in today?",
                  choices = c("Ethnicity", "Age", "Gender", "Insurance"), 
                  selected = "Ethnicity"), #the default that shows up
      radioButtons("measurements",
                  label = "Which measurement would you like to compare?",
                  choices = c("Bicarbonate", "Calcium", "Chloride", 
                              "Creatinine", "Glucose", "Magnesium", 
                              "Potassium", "Sodium", "Hematocrit", 
                              "White blood cells count", "Heart rate",
                              "Systolic non-invasive blood pressure",
                              "Mean non-invasive blood pressure",
                              "Respiration rate", "Body temperature"))
    ),
    
    mainPanel(
      #TODO decide what to put as outputs here (what kind of plot)
      plotOutput("demographicPlot"),
      plotOutput("measurementPlot")
    )
  )
  
)

#Server logic, obtain data etc
server <- function(input, output) {
  #Output plot 1: demographic
  output$demographicPlot <- renderPlot({
    data <- switch(input$demographic,
                   "Ethnicity" = "ethnicity",
                   "Age" = "age_hadm",
                   "Gender" = "gender",
                   "Insurance" = "insurance")
    
    
    ggplot(icu_cohort, aes_string(x = data)) +
      geom_histogram(stat='count')
  })
  
  #Output plot 2: measurements
  output$measurementPlot <- renderPlot({
    msmt <- switch(input$measurements,
                   "Creatinine" = "creatinine",
                   "Glucose" = "glucose")
    
    ggplot(icu_cohort, mapping = aes_string(x = "thirty_days_mort", y = msmt)) +
      geom_boxplot(outlier.shape = NA) + #remove outliers
      coord_cartesian(
        ylim = c(median(icu_cohort$msmt) - median(icu_cohort$msmt)/2, 
                 median(icu_cohort$msmt) + median(icu_cohort$msmt)/2))
  })
  
  
}

shinyApp(ui = ui, server = server)