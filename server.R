#NationalNames <- read.csv("NationalNames.csv", header = TRUE)

shinyServer(
  function(input, output, session){

    output$Neutrality <- renderPlot({
    NameFemale <- NationalNames[(NationalNames$Name == input$name & 
                                      NationalNames$Gender == 'F' &
                                      NationalNames$Year >= input$year[1]&
                                      NationalNames$Year <= input$year[2]),]
    
    NameMale <- NationalNames[(NationalNames$Name == input$name & 
                                 NationalNames$Gender == 'M' &
                                 NationalNames$Year >= input$year[1]&
                                 NationalNames$Year <= input$year[2]),]
                                   
    
    pie(main= "Average by Gender",c(mean(NameFemale$Count),mean(NameMale$Count)), 
        labels = c("Female", "Male"),
        col = c("Pink", "Blue"))
    })
    
  }
)
