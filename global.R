# install and load required packages
#install.packages('DT')
#install.packages('plyr')
#install.packages('ggplot2')
#install.packages('ggmap')
#install.packages('openintro')
library(DT)
library(plyr)
library(ggplot2)
library(ggmap)
library(openintro)

# read-in rds file of all names
CombinedNames <- readRDS("CombinedNames.rds")
UniqueNames <- readRDS("UniqueNames.rds")
StateList <- readRDS("StateList.rds")
WikiListClean <- readRDS("WikiList.rds")
