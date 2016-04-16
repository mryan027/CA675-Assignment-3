shinyServer(
  fluidPage(

    titlePanel("Baby Names Application"),
    
    fluidRow(
      column(3,
             selectizeInput("name", "Name", choices = NULL),
             checkboxInput('male', 'Male'),
             checkboxInput('female', 'Female')
      ),
      column(2,
             selectInput("state", "State",as.character(StateList$State),selectize = TRUE)
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
        tabPanel("Top 10 Names",dataTableOutput("Top10Names")),
        tabPanel("Bottom 10 Names",dataTableOutput("Bottom10Names")),
        tabPanel("Top 5 States",dataTableOutput("Top5ByState")),
        tabPanel("Top 5 Years", dataTableOutput("Top5ByYear")),
        tabPanel("Wiki"),
        tabPanel("Map", plotOutput("MapPlot"))
      )
    )
  )
)
