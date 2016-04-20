shinyServer(
  fluidPage(

    titlePanel("Baby Names Application"),
    
    # set-up objects for user input
    fluidRow(
      column(3,
             h4("Instructions"),
             helpText("Select 1. Name"),
             helpText("Select 2. Gender"),
             helpText("Select 3. State"),
             helpText("Select 4. Year Range"),
             helpText("Note: Only Upper Year Range Value used in Top/Bottom 10/Top 5 States Searches")
      ),
      column(3,
             selectizeInput("name", "Search for your Name Below",
                            choices = as.character(UniqueNames$Name),
                            selected = "Mary"),
             checkboxInput('male', 'Male'),
             checkboxInput('female', 'Female')
      ),
      column(2,
             selectInput("state", "State",as.character(StateList$State),selectize = TRUE)
      ),
      column(5,
             sliderInput("year", "Year Range",min = 1880, max = 2020, step = 1, sep ="",
                         value = c(1880, 2014), format ="$####")
      )
    ),
    
    # display output for various user queries
    mainPanel(
      tabsetPanel(
        tabPanel("Gender Mix", plotOutput("Neutrality")),
        tabPanel("Historic", plotOutput("LineGraph")),
        tabPanel("Top 10 Names",dataTableOutput("Top10Names")),
        tabPanel("Bottom 10 Names",dataTableOutput("Bottom10Names")),
        tabPanel("Top 5 States",dataTableOutput("Top5ByState")),
        tabPanel("Top 5 Years", dataTableOutput("Top5ByYear")),
        tabPanel("Wiki", dataTableOutput("WikiData")),
        tabPanel("Map", plotOutput("MapPlot"))
      )
    )
  )
)
