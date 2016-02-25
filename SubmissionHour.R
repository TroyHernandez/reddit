# SubmissionHour.R
project <- "braided-facet-122217"
library(dplyr)
# input <- list(user = "arXibot", subreddit = "")

# threshold <- 10

gettin.dftime <- function(input){
  sql1 <- paste("SELECT
            DAYOFWEEK(SEC_TO_TIMESTAMP(created_utc - 60*60*5)) as sub_dayofweek,
                HOUR(SEC_TO_TIMESTAMP(created_utc - 60*60*5)) as sub_hour,
                SUM(IF(score >=", input$threshold,", 1, 0)) as num_gte_3000,
                FROM [fh-bigquery:reddit_posts.full_corpus_201512]")

  sql3 <- "GROUP BY sub_dayofweek, sub_hour
  ORDER BY sub_dayofweek, sub_hour"

  if(input$subreddit == "") {
    if(input$user == ""){
      sql2 <- ""
    } else {
      sql2 <- paste0("WHERE author = \"", input$user, "\"")
    }
  } else {
    if(input$user == ""){
      sql2 <- paste0("WHERE subreddit = \"", input$subreddit, "\"")
    } else {
      sql2 <- paste0("WHERE author = \"", input$user, "\"
                      AND subreddit = \"", input$subreddit, "\"")
    }
  }
  sql <- paste(sql1, sql2, sql3)
  cat(sql)

  df <- query_exec(sql, project)

  dow_format <- data_frame(sub_dayofweek = 1:7,
                           dow_format = c("Sunday","Monday","Tuesday",
                                          "Wednesday","Thursday","Friday",
                                          "Saturday"))
  hour_format <- data_frame(sub_hour = 0:23,
                            hour_format = c(paste(c(12,1:11),"AM"),
                                            paste(c(12,1:11),"PM")))

  df_time <- df %>% left_join(dow_format) %>% left_join(hour_format)
  df_time %>% tail(10)
  df_time$dow_format <- factor(df_time$dow_format,
                               level = rev(dow_format$dow_format))
  df_time$hour_format <- factor(df_time$hour_format,
                                level = hour_format$hour_format)

  colnames(df_time)[3] <- "Submissions"
  df_time
}


