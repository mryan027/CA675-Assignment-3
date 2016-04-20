# read-in csv files
NationalNames <- read.csv("Raw Data/NationalNames.csv", header = TRUE)
StateNames <- read.csv("Raw Data/StateNames.csv", header = TRUE)

# determine which useful names we are going to retain
head(NationalNames)
SumNames <- aggregate(NationalNames$Count, by=list(NationalNames$Name), FUN=sum)
names(SumNames) <- c("Name", "Count")
SumNames <- SumNames[order(SumNames$Count),]
RetainedNames <- as.character(SumNames[SumNames$Count > 500,]$Name)

# filter out less-desirible names
NationalNamesReduced<- NationalNames[as.character(NationalNames$Name) %in% RetainedNames,]
StateNamesReduced <- StateNames[as.character(StateNames$Name) %in% RetainedNames,]

head(NationalNamesReduced)

National_Clean <- data.frame(NationalNamesReduced$Id, NationalNamesReduced$Name, 
                             NationalNamesReduced$Year,NationalNamesReduced$Gender, "National", 
                             NationalNamesReduced$Count)

colnames(National_Clean)<- names(StateNamesReduced)
CombinedNames <- rbind(StateNamesReduced , National_Clean)
UniqueNames <- unique(CombinedNames$Name)

write.table(CombinedNames, file = "CombinedNames.csv", sep=",",row.names = FALSE)
write.table(UniqueNames, file = "UniqueNames.csv", sep=",",row.names = FALSE)

# remove from data frames from memory
rm(NationalNames)
rm(StateNames)
rm(NationalNamesReduced)
rm(StateNamesReduced)
rm(National_Clean)
rm(CombinedNames)
rm(UniqueNames)
