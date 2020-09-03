

shinyUI(dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Clinical Trials"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Information", tabName = "information", icon = icon("table")),
      menuItem("Exploration", tabName = "exploration", icon = icon("table")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("About", tabName = "about", icon = icon("smile"))
    )
  ),
  
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "introduction",
        fluidRow(
          style = "padding: 20px;",
          h1("Visualization of Cardiovascular Related Clinical Trials"),
          br(),
          h4("What are clinical trials?"),
          p("- Interventional vs. Observational"),
          p("- Phases"),
          br(),
          h4("Leading cause of death in the US:"),
          p("- Cariovascular Disease"),
          br(),
          h4("Purpose of dashboard: "),
          p("- Exploration of cardiovascular related clinical studies "),
          p("1. Individuals with diease"),
          p(
            "2. Further knowledge on disease, treatments and prevention methods"
          ),
          p("3. Investment in medical prodcuts related to disease")
        ),
        br(),
        br(),
        br(),
        br(),
        br(),
        
        fluidRow(box(
          tags$iframe(
            src = "https://www.youtube.com/embed/iWqQiJeP5ac",
            width = "100%",
            height = "370px"
          )
        ),
        box(
          tags$iframe(
            src = "https://www.youtube.com/embed/WwC8FxO7T_k",
            width = "100%",
            height = "370px"
          )
        ))
      ),
      
      
      tabItem(tabName = "map",
              fluidPage(leafletOutput("mymap", height = 650))),
      
      
      
      tabItem(
        tabName = "information",
        selectizeInput("choose",
                       "Select Input",
                       choice_study_info),
        fluidRow(plotOutput("information"))
      ),
      
      
      
      tabItem(
        tabName = "exploration",
        selectizeInput("choice",
                       "Select Input",
                       choice_explore_info),
        fluidRow(plotlyOutput('boxplot1'))
      ),
      
      
      tabItem(tabName = "data",
              fluidRow(box(dataTableOutput("table"), width = 12))), 
      
      
      
      tabItem(
        tabName = "about",
        fluidRow(style = "padding: 20px;",
                 h2("Background"),
                 br(),
                 h4("Marcus Choi has a degree in Kinesiology and several years of experience in clinical research, where he developed "),
                 h4("a passion for working with data. This led him to pursue a career in data science and is currently training at the "),
                 h4("NYC Data Science Academy. "),
                 br(),
                 br(),
                 img(src="me.jpg",height="22%", width="22%")
                 
      
          
          
        )
      )
      
      
    )
  )
))


