shinyServer(
  fluidPage(

    titlePanel("Baby Names Application"),
    
    fluidRow(
      column(3,
             selectizeInput("name", "Name",c("Darren", "Seamus", "John", "Richard", "Robbie",
                                             "Glenn", "Jeff", "Wes", "James", 
                                             "Shane", "Jonathan")),
             checkboxInput('male', 'Male'),
             checkboxInput('female', 'Female')
      ),
      column(2,
             selectizeInput("state", "State",c("CA", "NY", "NJ", "MA"))
      ),
      column(7,
             sliderInput("year", "Year",min = 1880, max = 2020, step = 1, sep ="",
                         value = c(1880, 2014), format ="$####")
      )
    ),
    
    mainPanel(
     plotOutput("Neutrality"),
     plotOutput("LineGraph")
    )
  )
)
