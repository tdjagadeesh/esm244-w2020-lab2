#### Goal: Create an app for "spooky" data

#Load relevant packages
library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

#Read in spooky_data.csv
spooky <- read_csv(here("data", "spooky_data.csv"))


######## Create user interface #########

ui <- fluidPage( #Allows page to rescale depending on device
  theme = shinytheme("flatly"),
  titlePanel("Title!"),
  sidebarLayout(
    sidebarPanel("My widgets are here",
                 selectInput(inputId = "state_select",
                             label = "Choose a state:",
                             choices = unique(spooky$state)  #unique(spooky$state) shows all the possible states. You could also do c("California", "Georgia", "Texas")
                 )
                 ),
    mainPanel("My outputs are here",
              tableOutput(outputId = "candy_table"))
  )
)


######### Create server ########

server <- function(input, output) {
  state_candy <- reactive({ #Tell r this is a reactive dataframe
    spooky %>%
      filter(state == input$state_select) %>% #Filter df for the input we named earlier
      select(candy, pounds_candy_sold)
    })

  output$candy_table <- renderTable({
    state_candy() #Use paranthesis because it is a reactive output
  })
}



#Connect the two in a shiny app
shinyApp(ui = ui, server = server)

#For r to recongize this is an app, need to save as app.r
#Once you do, a Run App button shows up
