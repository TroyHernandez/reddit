
gettin.dat2 <- function(input){
  if(input$subreddit == "") {
    if(input$user == ""){
      # all of reddit
      dat2 <- query_exec(paste0("SELECT word, COUNT(*) as num_words, AVG(score) as avg_score
                                FROM(FLATTEN((
                                SELECT SPLIT(LOWER(REGEXP_REPLACE(title, r\'[\\.\\\",*:()\\[\\]/|\\n]\', \' \')), \' \') word, score
                                FROM [fh-bigquery:reddit_posts.full_corpus_201512]), word))
                                GROUP EACH BY word"), max_pages = Inf,
                         project)
    } else {
      # user only
      dat2 <- query_exec(paste0("SELECT word, COUNT(*) as num_words, AVG(score) as avg_score
                                FROM(FLATTEN((
                                SELECT SPLIT(LOWER(REGEXP_REPLACE(title, r\'[\\.\\\",*:()\\[\\]/|\\n]\', \' \')), \' \') word, score
                                FROM [fh-bigquery:reddit_posts.full_corpus_201512]
                                WHERE author == \"", input$user,"\" ), word))
                                GROUP EACH BY word
                                ORDER BY num_words DESC"),
                         project)
    }
  } else {
    if(input$user == ""){
      # sub
      dat2 <- query_exec(paste0("SELECT word, COUNT(*) as num_words, AVG(score) as avg_score
                                FROM(FLATTEN((
                                SELECT SPLIT(LOWER(REGEXP_REPLACE(title, r\'[\\.\\\",*:()\\[\\]/|\\n]\', \' \')), \' \') word, score
                                FROM [fh-bigquery:reddit_posts.full_corpus_201512]
                                WHERE subreddit=\"", input$subreddit, "\"), word))
                                GROUP EACH BY word
                                HAVING num_words >= 100
                                ORDER BY num_words DESC
                                LIMIT 100"),
                         project)
    } else {
      # user and sub
      dat2 <- query_exec(paste0("SELECT word, COUNT(*) as num_words, AVG(score) as avg_score
                                FROM(FLATTEN((
                                SELECT SPLIT(LOWER(REGEXP_REPLACE(title, r\'[\\.\\\",*:()\\[\\]/|\\n]\', \' \')), \' \') word, score
                                FROM [fh-bigquery:reddit_posts.full_corpus_201512]
                                WHERE author == \"", input$user,"\"
                                AND subreddit=\"", input$subreddit, "\"), word))
                                GROUP EACH BY word
                                HAVING num_words >= 1
                                ORDER BY num_words DESC"),
                         project)
    }
  }
  dat2
}
