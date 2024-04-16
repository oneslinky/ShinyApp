# Load packages ----
library(shiny)

# Load data ----
weedPrices <- read_csv("data/weedprices.csv")
weedPrices <- weedPrices %>%
  mutate(
    MedQ = as.numeric(str_replace(MedQ, "\\$", ""))
  )
# User interface ----
ui <- fluidPage(
  titlePanel("Weed Prices"),
  sidebarLayout(
    sidebarPanel(
      helpText("Medium Quality Weed Prices By State for the Year of 2014"),
      selectInput(
        "state",
        label = "Pick State",
        choices = unique(weedPrices$State),
        selected = "Alabama"
      )
    ),
    mainPanel(
      plotOutput("weedPlot")
    )
  )
)


# Server logic ----
server <- function(input, output) {
  output$weedPlot <- renderPlot({
    statedata <- weedPrices %>%
      filter(State == input$state)
    max_medq <- max(statedata$MedQ+25, na.rm = TRUE)
    barplot(
      statedata$MedQ,
      names.arg = statedata$Month,
      col = "purple",
      xlab = "Month",
      ylab = "Price (USD)",
      main = paste("Medium Quality Weed Price in", input$state, "for 2014"),
      ylim = c(0, max_medq * 1.2)
    )
  })
}


# Run app ----
shinyApp(ui, server)
