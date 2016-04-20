# clean the wikipedia data that has been preprocessed in hive

WikiList <- read.csv("wiki_prop_limit.csv")

# adjust data types for various columns
WikiListClean <- cbind(as.character(WikiList$word_prop_limit.name_lower)
                       , as.integer(WikiList$word_prop_limit.num)
                       , substr(as.character(WikiList$word_prop_limit.title),2,
                                length(as.character(WikiList$word_prop_limit.title))),
                       as.double(WikiList$word_prop_limit.name_frequency))

# set to data frame and assign names
WikiListClean <- as.data.frame(WikiListClean)
names(WikiListClean) <- c("Name", "Rank", "Article_Link", "Score (Name-Article Freq %)")

# tidy titles and setup for URL
WikiListClean$Article_Link <- gsub(' ', '_', WikiListClean$Article_Link)
WikiListClean$Article_Link <- paste("http://en.wikipedia.org/wiki/",
                                    WikiListClean$Article_Link, sep="")

# sense-check output and save to rds
head(WikiListClean)
saveRDS(WikiListClean, "WikiList.rds")

