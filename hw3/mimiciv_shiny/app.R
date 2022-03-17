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
               on the right-hand side of this screen. Please note that each 
               input panel correspond to one output panel"),
      selectInput("demographic",
                  label = "What kind of demographics are you interested in today?",
                  choices = c("Ethnicity", "Age", "Gender", 
                              "Insurance", "Language", "Marital Status"), 
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
                   "Insurance" = "insurance",
                   "Language" = "language",
                   "Marital Status" = "marital_status")
    
    
    ggplot(icu_cohort, aes_string(x = data)) +
      geom_histogram(stat='count') + #same as geom_bar() 
      ggtitle('Number of patients within different demographic cateogory') +
      xlab('Demographic Sub-category') +
      ylab('Patient count')
  })
  
  #Output plot 2: measurements
  output$measurementPlot <- renderPlot({
    msmt <- switch(input$measurements,
                   "Creatinine" = "creatinine",
                   "Glucose" = "glucose",
                   "Potassium" = "potassium",
                   "Sodium" = "sodium",
                   "Chloride" = "chloride",
                   "Bicarbonate" = "bicarbonate",
                   "Hematocrit" = "hematocrit",
                   "White blood cells count" = "wbc_count",
                   "Magnesium" = "magnesium",
                   "Calcium" = "calcium",
                   "Heart rate" = "heart_rate",
                   "Mean non-invasive blood pressure" = "mean_non_invasive_bp",
                   "Systolic non-invasive blood pressure" =
                     "systolic_non_invasive_bp",
                   "Respiration rate" = "resp_rate",
                   "Body temperature" = "body_temp")
    
    ggplot(icu_cohort, mapping = aes_string(x = "thirty_days_mort", y = msmt)) +
      geom_boxplot(outlier.shape = NA) +
      xlab('Did the patient die within 30 days of hospitalization?') +
      ggtitle('Measurement statistics between patients who did and did not die 
              within 30 days of hospitalization') +
      scale_y_continuous()
      #scale_y_discrete(label = waiver())
      #coord_cartesian(
      #  ylim = c(median(icu_cohort$msmt) - median(icu_cohort$msmt)/2, 
      #           median(icu_cohort$msmt) + median(icu_cohort$msmt)/2))
  })
  
  
}

shinyApp(ui = ui, server = server)