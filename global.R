# install and load required packages
#install.packages('DT')
#install.packages('ggplot2')
#install.packages('ggmap')
#install.packages('openintro')
library('DT')
library(ggplot2)
library(ggmap)
library(openintro)

# read-in csv file of all names
CombinedNames <- readRDS("CombinedNames.rds")
UniqueNames <- readRDS("UniqueNames.rds")
StateList <- readRDS("StateList.rds")
