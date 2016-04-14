# read-in csv file of all names
#install.packages('DT')
library('DT')
CombinedNames<- read.csv("CombinedNames.csv", header = TRUE)
UniqueNames <- read.csv("UniqueNames.csv", header = TRUE)
StateList <- read.csv("StateList.csv", header = TRUE)
