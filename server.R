# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

project <- "" # Put your project name here.
source("dat2.R", local = TRUE)
source("SubmissionHour.R", local = TRUE)
library(shiny)
library(bigrquery)
library(tidyr)
library(methods) # needed for query_exec in Jupyter: https://github.com/hadley/bigrquery/issues/32
library(wordcloud)
library(digest)
library(scales)
library(dplyr)
library(ggplot2)
threshold <- 10

shinyServer(function(input, output) {

  df_nostop <- eventReactive(input$action2, {
      # if(input$action2 != 0){
        dat2 <- gettin.dat2(input)
        stop_words <- unlist(strsplit("a,able,about,across,after,all,almost,also,am,among,an,and,any,are,as,at,be,because,been,but,by,can,cannot,could,dear,did,do,does,either,else,ever,every,for,from,get,got,had,has,have,he,her,hers,him,his,how,however,i,if,in,into,is,it,its,just,least,let,like,likely,may,me,might,most,must,my,neither,no,nor,not,of,off,often,on,only,or,other,our,own,rather,said,say,says,she,should,since,so,some,than,that,the,their,them,then,there,these,they,this,tis,to,too,twas,us,wants,was,we,were,what,when,where,which,while,who,whom,why,will,with,would,yet,you,your,id,item,it\'s,don\'t",","))
        dat2 <- dat2[!(dat2$word %in% stop_words), ]
        dat2
    })

  output$wordCloud <- renderPlot({
    if(is.null(df_nostop())){return(NULL)}
    pal <- brewer.pal(11, "RdBu")
    pal <- pal[-c(1:3)]   # Remove light colors

    wordcloud(toupper(df_nostop()$word),
              df_nostop()$num_words,
              scale=c(5,1),
              random.order=F,
              rot.per=.10,
              max.words=100,
              colors=pal,
              random.color=T)
  })

  df_time <- eventReactive(input$action2, {
    # if(input$action2 != 0){
    df_time <- gettin.dftime(input)
    df_time
  })

  output$submissionTime <- renderPlot({
    if(is.null(df_time())){return(NULL)}
    plot <- ggplot(df_time(), aes(x=hour_format, y=dow_format,
                                  fill=Submissions)) +
      geom_tile() +  #+ theme(legend.position="none") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.6),
            panel.margin=element_blank()) +
      labs(x = "Hour of Reddit Submission (Eastern Standard Time)",
           y = "Day of Week of Reddit Submission") +
      scale_fill_gradient(low = "white", high = "royalblue2", labels=comma,
                          breaks=pretty_breaks(6))
    plot
  })
})
