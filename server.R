shinyServer(
  function(input, output, session){

    updateSelectizeInput(session, 'name', 
                         choices = as.character(UniqueNames$Name), server = TRUE)
    
    # shorten the list of male/females based on user input
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
    
    # reactive object for check boxes
    FemaleCheckBox <- reactive(
      input$female
    )
    
    MaleCheckBox <- reactive(
      input$male
    )

    # gender balance pie-chart
    output$Neutrality <- renderPlot({
    
        # reference from the reactive function above
        NameMale <- NameMale()
        NameFemale <- NameFemale()
        
        if ((length(NameMale[,1]) == 0) && (length(NameFemale[,1]) == 0)){
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
          text(x=0.5, y=1, "No Records for Given Name")
        }else{
          # get the proportion of names for each gender
          TotalMale <- 100 * round(sum(NameMale$Count)/ (sum(NameMale$Count) +  sum(NameFemale$Count)),4)
          TotalFemale <- 100 * round(sum(NameFemale$Count)/ (sum(NameMale$Count) +  sum(NameFemale$Count)),4)
          
          # assign a dynamic name for input to the pie chart
          if (TotalMale != 0){
            InputName <- as.character(NameMale$Name[1])
          }else{
            InputName <- as.character(NameFemale$Name[1])
          }
          
          # output pie chart
            pie(main= paste("Proportion of", InputName, "by Gender"),
                c(TotalFemale, TotalMale), labels = c(paste(TotalFemale,"%", sep=""), 
                                                      paste(TotalMale,"%", sep="")),
                col = c("Pink", "Blue"))
            
            legend("topleft", c("Female", "Male"), fill = c("Pink", "Blue"), cex=0.8)
        }
      
    })
    
    # plot for historic name over time
    output$LineGraph <- renderPlot({
      
      # reference from the reactive function above
      NameMale <- NameMale()
      NameFemale <- NameFemale()
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      # check if any records present before plotting
      if (length(NameFemale$Count) == 0 && length(NameMale$Count) == 0){
        plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        text(x=0.5, y=1, "No Records for Given Name")
      }else{
        
        if (length(NameFemale$Count) != 0){
          InputName = as.character(NameFemale$Name[1])
        }else{
            InputName = as.character(NameMale$Name[1])
        }
        
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
        plot(1, main = paste("History of", InputName, "Overtime"),
             type="n", xlab="Year", ylab="Name Count", 
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
    
    # get the top 5 years for given name
    output$Top5ByYear = renderDataTable(datatable({
      
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      #Top 5 by Year Function
      top_year<-function(test_name, gender, state){
        x<-(CombinedNames[which(CombinedNames$Name==test_name & 
                                  CombinedNames$Gender==gender & 
                                  CombinedNames$State==state),])
        return(head(x[order(x$Count, decreasing=TRUE),],5, by =Year))}
      
      # split between male and female
      Top5Female <- top_year(input$name ,"F", input$state)
      Top5Male <- top_year(input$name ,"M", input$state)
      
      if  (isTRUE(FemaleCheckBox)){
        Top5Total <- Top5Female
        if  (isTRUE(MaleCheckBox)){
          Top5Total <- rbind(Top5Total, Top5Male)
        }
        
        Top5Total[,-1]
        
      }else if (isTRUE(MaleCheckBox)){
        Top5Total <- Top5Male
        Top5Total[,-1]
      }

    }, options = list(lengthMenu = c(5,10), pageLength = 5))
    
    )
    
    # get the top 5 states for given name
    output$Top5ByState = renderDataTable(datatable({
      
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      #Top 5 by State Function
      top_states<-function(test_name, gender, year){
        x<-(CombinedNames[which(CombinedNames$Name==test_name & 
                                  CombinedNames$Gender==gender & 
                                  CombinedNames$Year==year &
                                  CombinedNames$State != "National"),])
        return(head(x[order(x$Count, decreasing=TRUE),],5, by =State))}
      
      # split between male and female
      Top5Female <- top_states(input$name ,"F", input$year[2])
      Top5Male <- top_states(input$name ,"M", input$year[2])
      
      if  (isTRUE(FemaleCheckBox)){
        Top5Total <- Top5Female
        if  (isTRUE(MaleCheckBox)){
          Top5Total <- rbind(Top5Total, Top5Male)
        }
        
        Top5Total[,-1]
        
      }else if (isTRUE(MaleCheckBox)){
        Top5Total <- Top5Male
        Top5Total[,-1]
      }
    
    }, options = list(lengthMenu = c(5,10), pageLength = 5))
    
    )
    
    # get the top 10 names based on input parameters specified
    output$Top10Names = renderDataTable(datatable({
      
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      #Top 10 Names Function
      top_10<-function(state, gender, year){
        x<-(CombinedNames[which(CombinedNames$State==state & 
                                  CombinedNames$Gender==gender & 
                                  CombinedNames$Year==year),])
        return(head(x[order(x$Count, decreasing=TRUE),],10, by =Name))}
      
      # split between male and female
      Top10Female <- top_10(input$state ,"F", input$year[2])
      Top10Male <- top_10(input$state ,"M", input$year[2])
      
      if  (isTRUE(FemaleCheckBox)){
        Top10Total <- Top10Female
        if  (isTRUE(MaleCheckBox)){
          Top10Total <- rbind(Top10Total, Top10Male)
        }
        
        Top10Total[,-1]
        
      }else if (isTRUE(MaleCheckBox)){
        Top10Total <- Top10Male
        Top10Total[,-1]
      }
      
    }, options = list(lengthMenu = c(10,20), pageLength = 10))
    
    )
    
    # get the bottom 10 names based on input parameters specified
    output$Bottom10Names = renderDataTable(datatable({
      
      FemaleCheckBox <- FemaleCheckBox()
      MaleCheckBox <- MaleCheckBox()
      
      #Bottom 10 Names Function
      bottom_10<-function(state, gender, year){
        x<-(CombinedNames[which(CombinedNames$State==state & 
                                  CombinedNames$Gender==gender & 
                                  CombinedNames$Year==year),])
        return(head(x[order(x$Count, decreasing=FALSE),],10, by =Name))}
      
      # split between male and female
      Bottom10Female <- bottom_10(input$state ,"F", input$year[2])
      Bottom10Male <- bottom_10(input$state ,"M", input$year[2])
      
      if  (isTRUE(FemaleCheckBox)){
        Bottom10Total <- Bottom10Female
        if  (isTRUE(MaleCheckBox)){
          Bottom10Total <- rbind(Bottom10Total, Bottom10Male)
        }
        
        Bottom10Total[,-1]
        
      }else if (isTRUE(MaleCheckBox)){
        Bottom10Total <- Bottom10Male
        Bottom10Total[,-1]
      }
    
    }, options = list(lengthMenu = c(10,20), pageLength = 10))
    
    )
    
    # plot map showing name popularity in each state over a given time period
    output$MapPlot <- renderPlot({
  
      us_state_map <- map_data('state')
      single_name <-CombinedNames[(CombinedNames$Name == input$name & 
                                     CombinedNames$State != "National" &
                                     CombinedNames$Year >= input$year[1] &
                                     CombinedNames$Year <= input$year[2]),]
      
      if (as.integer(length(single_name[,1]) == 0)){
        plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        text(x=0.5, y=1, "Insufficient Data for Map")
      }else{
        agg_name <- aggregate(single_name$Count, by=list(single_name$State), FUN=sum)
        names(agg_name) <- c("state", "count")
        agg_name <- cbind(agg_name, tolower(abbr2state(agg_name$state)))
        names(agg_name) <- c("state", "count", "region")
        
        if (length(agg_name[,1]) >= 50){
          map_data <- merge(agg_name, us_state_map, by = 'region')
          map_data <- arrange(map_data, order)
          
          states <- data.frame(state.center, state.abb)
          names(states) <- c("long", "lat", "State")
          
          p1 <- ggplot(data = map_data, aes(x = long, y = lat, group = group))
          p1 <- p1 + geom_polygon(aes(fill = cut_number(count/1000, 5)))
          p1 <- p1 + scale_fill_brewer('Name Count in Thousands', 
                                       palette  = 18)
          p1 <- p1 + geom_text(data = states, aes(x = long, y = lat, label = State, group = NULL), size = 3)
          p1 <- p1 + theme_bw()
          print(p1)
        }else{
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
          text(x=0.5, y=1, "Insufficient Data for Map")
        }
      }
    })
    
    # get the top (up to 10) articles for the specified name
    output$WikiData = renderDataTable(datatable({
      WikiName <- WikiListClean[(WikiListClean$Name == tolower(input$name)),]
      WikiName$Article_Link <- paste0("<a href='",WikiName$Article_Link,"' 
                           target='_blank'>",WikiName$Article_Link,"</a>")
      
      WikiName
    }, escape = FALSE))
  }
)
