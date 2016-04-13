shinyServer(
  fluidPage(

    titlePanel("Baby Names Application"),
    
    fluidRow(
      column(3,
             selectizeInput("name", "Name", as.character(UniqueNames$Name[c(1:30000)])),
             checkboxInput('male', 'Male'),
             checkboxInput('female', 'Female')
             # 40k names -> becomes quite slow to load
      ),
      column(2,
             selectizeInput("state", "State",as.character(StateList$State))
      ),
      column(7,
             sliderInput("year", "Year",min = 1880, max = 2020, step = 1, sep ="",
                         value = c(1880, 2014), format ="$####")
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Gender Mix", plotOutput("Neutrality")),
        tabPanel("Historic", plotOutput("LineGraph")),
        tabPanel("Top 10 Names"),
        tabPanel("Bottom 10 Names"),
        tabPanel("Top 5 States"),
        tabPanel("Top 5 Years"),
        tabPanel("Wiki"),
        tabPanel("Map")
        # include other tabs - wiki etc in here
      )
    )
  )
)
