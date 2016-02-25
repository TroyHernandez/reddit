# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Reddit Analysis"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      textInput("subreddit", "Subreddit:", value = "",
                placeholder = "e.g. rstats"),
      textInput("user", "User:", value = "",
                placeholder = "e.g. TroyHernandez"),
      sliderInput("threshold", "Upvote Threshold:",
                  min = 1,  max = 50, value = 10),
      actionButton("action2", "Engage!")
    ),

    # Show a plot or two
    mainPanel(
      plotOutput("wordCloud"),
      plotOutput("submissionTime")
    )
  )
))
