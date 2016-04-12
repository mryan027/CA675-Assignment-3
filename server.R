shinyServer(
  function(input, output, session){
    NameFemale <- reactive(
      CombinedNames[(CombinedNames$Name == input$name & 
                                     CombinedNames$Gender == "F" &
                                     CombinedNames$State == input$state &
                                     CombinedNames$Year >= input$year[1] &
                                     CombinedNames$Year <= input$year[2]),]
    )
    
    NameMale <- reactive(
      CombinedNames[(CombinedNames$Name == input$name & 
                       CombinedNames$Gender == "M" &
                       CombinedNames$State == input$state &
                       CombinedNames$Year >= input$year[1] &
                       CombinedNames$Year <= input$year[2]),]
    )
    
    FemaleCheckBox <- reactive(
      input$female
    )
    
    MaleCheckBox <- reactive(
      input$male
    )

    output$Neutrality <- renderPlot({
      
      # reference from the reactive function above
      NameMale <- NameMale()
      NameFemale <- NameFemale()
      
      # get the proportion of names for each gender
      TotalMale <- 100 * round(sum(NameMale$Count)/ (sum(NameMale$Count) +  sum(NameFemale$Count)),4)
      TotalFemale <- 100 * round(sum(NameFemale$Count)/ (sum(NameMale$Count) +  sum(NameFemale$Count)),4)
      
      # assign a dynamic name for input to the pie chart
      if (TotalMale != 0){
        InputName <- as.character(NameMale$Name[1])
      }else if (TotalFemale != 0){
        InputName <- as.character(NameFemale$Name[1])
      }else{
        InputName <- "Error"
      }
      
       # output pie chart (if allowed)
      if (InputName != "Error"){
        pie(main= paste("Proportion of", InputName, "by Gender"),
            c(TotalFemale, TotalMale), labels = c(paste(TotalFemale,"%", sep=""), 
                                                  paste(TotalMale,"%", sep="")),
            col = c("Pink", "Blue"))
        legend("topleft", c("Female", "Male"), fill = c("Pink", "Blue"), cex=0.8)
      }else{
        print("No Records for Given Name")
      }
    })
    
    output$LineGraph <- renderPlot({
      
      # reference from the reactive function above
      NameMale <- NameMale()
      NameFemale <- NameFemale()
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      # check if any records present before plotting
      if (length(NameFemale$Count) == 0 && length(NameMale$Count) == 0){
        print("No Records for Given Name")
      }else{
        
        # set limiting ranges for x/y axes
        xlimits <- c(min(min(NameFemale$Year, NameMale$Year)), 
                     max(max(NameFemale$Year, NameMale$Year)))
        ylimits <- c(min(min(NameFemale$Count, NameMale$Count)), 
                     max(max(NameFemale$Count, NameMale$Count)))
        
        # adjust range if too short for accurate plotting
        if ((xlimits[2] - xlimits[1]) < 2){
          xlimits <- c(xlimits[1]-2, xlimits[2]+2)
        } else if ((xlimits[2] - xlimits[1]) < 4){
          xlimits <- c(xlimits[1]-1, xlimits[2]+1)
        }
        
        # plot skeletal output
        plot.new()
        plot(1, main = "Name Over Time",type="n", xlab="Year", ylab="Name Count", 
             xlim=xlimits, ylim=ylimits)
        box()
        
        # plot line (or single point if just one year)
        if (length(NameFemale$Count) > 1 || length(NameMale$Count) > 1){
          
          if  (isTRUE(FemaleCheckBox)){
            lines(NameFemale$Year,NameFemale$Count, type="l", col="pink", lwd=5)
          }          
          
          if (isTRUE(MaleCheckBox)){
            lines(NameMale$Year,NameMale$Count, type="l", col="blue", lwd=5)
          }
          
          
        }else{
          
          if  (isTRUE(FemaleCheckBox)){
            points(NameFemale$Year,NameFemale$Count, col="pink", lwd=10)
          }
          
          if (isTRUE(MaleCheckBox)){
            points(NameMale$Year,NameMale$Count, col="blue", lwd=10)
          }
        }
        
      }
    })
    
  }
)
