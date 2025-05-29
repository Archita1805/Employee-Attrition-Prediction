library(shiny)
library(shinythemes)

# Load the logistic regression model
model <- readRDS("attrition_model.rds") # Replace with the correct file path if needed

# Define UI
ui <- fluidPage(
  theme = shinytheme("darkly"),
  titlePanel("Employee Attrition Predictor"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("age", "Age", value = 30, min = 18, max = 70),
      selectInput(
        "businessTravel", 
        "Business Travel", 
        choices = c("Travel_Rarely", "Travel_Frequently", "Non-Travel")
      ),
      selectInput(
        "department", 
        "Department", 
        choices = c("Sales", "Research & Development", "Human Resources")
      ),
      sliderInput(
        "jobSatisfaction", 
        "Job Satisfaction", 
        min = 1, 
        max = 4, 
        value = 3,
        step = 1
      ),
      actionButton("predict", "Predict Attrition")
    ),
    
    mainPanel(
      h3("Prediction Result"),
      verbatimTextOutput("prediction")
    )
  )
)

# Define Server
server <- function(input, output) {
  prediction <- eventReactive(input$predict, {
    # Create a data frame for prediction
    input_data <- data.frame(
      Age = input$age,
      BusinessTravel = input$businessTravel,
      Department = input$department,
      JobSatisfaction = input$jobSatisfaction
    )
    
    # Predict attrition using the loaded model
    pred <- predict(model, newdata = input_data, type = "raw")
    
    # Return prediction
    ifelse(pred == "Yes", "Attrition Likely", "No Attrition")
  })
  
  # Display prediction
  output$prediction <- renderText({
    prediction()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
