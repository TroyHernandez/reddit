# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Reddit Analysis"),
  img(src='title_troy.png', align = "center", width = 200),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      textInput("subreddit", "Subreddit:", value = "",
                placeholder = "e.g. rstats"),
      textInput("user", "User:", value = "",
                placeholder = "e.g. TroyHernandez"),
      sliderInput("threshold", "Upvote Threshold:",
                  min = 1,  max = 50, value = 3),
      actionButton("action2", "Engage!")
    ),

    # Show a plot or two
    mainPanel(
      plotOutput("submissionTime", width = "75%", height = "300px"),
      plotOutput("wordCloud", width = "75%", height = "300px")
    )
  )
))
