### DATA WRANGLING ###

df <- tbl_df(trials) %>% 
  select( Status = Status,
          Interventions = Interventions,
          Sponsor.Type = Sponsor.Collaborators,
          Phases = Phases,
          Enrollment = Enrollment, 
          Study.Type = Study.Type,
          Sponsor = Funded.Bys,
          Study.Designs = Study.Designs)
df <- cbind(df, Duration = trial_duration) 
df <- cbind(df, location)

df$Study.Type <- ifelse(df$Study.Type == "Interventional", "Interventional", "Observational")

#Length of clinical trials by finding the difference between start and completion date
modified_start = parse_date_time(trials$Start.Date, orders = c('mY','mdY'))
modified_completion = parse_date_time(trials$Completion.Date, orders = c('mY', 'mdY'))
trial_duration = interval(modified_start, modified_completion) %/% months(1)


df$Interventions <- str_extract(df$Interventions, regex('[A-Za-z]+(?=(,|\\b))'))

df$Phases <- sub("Not Applicable", "", df$Phases)
df$Phases <- sub("Early ", "", df$Phases)
df$Phases[df$Phases==""]<-NA

#input choice on UI
choice_study_info = c("Intervention Type", "Patient Status", "Clinical Phase", "Sponsor Type")
choice_explore_info = c("Enrollment", "Duration")

# go to original colum and different types of grouping
# save the original sponsor column to third column 
# rename the new column as sponsor

#------------------------------------------------------------------------------------


shinyServer(function(input, output, session){

### MAP ###    
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      setView(lng = -99.91, lat = 38.45 , zoom = 3.5) %>%
      addProviderTiles('Esri.WorldStreetMap') %>%
      addTiles() %>% 
      addMarkers(lng = ~lng, lat = ~lat, clusterOptions = markerClusterOptions(), data = df)
  })
  
  

### STUDY TYPES ###
  output$information <- renderPlot({
    
      
     if (input$choose == "Intervention Type") {
      
      
      g <- ggplot(data=subset(df, !is.na(Interventions)), aes(x = factor(Interventions,
                                                                         levels=names(sort(table(Interventions),
                                                                                           decreasing=TRUE)))))
      g + geom_bar(aes(fill = Interventions)) +
        geom_text(stat = 'count', aes(label = after_stat(count)), size=3.5, vjust=-.5)+
        labs(title="Number of Studies by Interventions") +
        xlab(label = "Interventions") +
        theme(axis.text.x = element_text(angle = 45,hjust = 1))
      
    } else if (input$choose == "Clinical Phase"){
      
      
      g<- ggplot(data=subset(df, !is.na(Phases)), aes(x = Phases))
      g + geom_bar(aes(fill = Phases)) +
        geom_text(stat = 'count', aes(label = after_stat(count)), size=3.5, vjust=-.5)+
        labs(title="Number of Studies by Phases") +
        xlab(label="Phase") +
        theme(axis.text.x = element_text(angle = 45,hjust = 1))
    
    
    } else if (input$choose == "Patient Status") {
      g <- ggplot(data=df, aes(x = factor(Status, 
                                          levels=names(sort(table(Status),
                                                            decreasing=TRUE)))))
      g + geom_bar(aes(fill = Status)) +
        geom_text(stat = 'count', aes(label = after_stat(count)), size=3.5, vjust=-.5)+
        labs(title="Patient Status By Study Type") +
        xlab(label = "Study Status") +
        theme(axis.text.x = element_text(angle = 45,hjust = 1)) 
    
   } else if (input$choose == "Sponsor Type") {
    
    
    g <- ggplot(data = df, aes(x = factor(Sponsor, 
                                          levels=names(sort(table(Sponsor), 
                                                            decreasing=TRUE))))) 
    
    g + geom_bar(aes(fill = Sponsor), state = "identity") + 
      theme(axis.text.x = element_text(angle = 45,hjust = 1)) +
      labs(title="Number of Studies By Sponsor") +
      xlab(label = "Sponsor")
    
   }
    
    }, height = 500)
  

    
### BOXPLOT ###
  output$boxplot1 <- renderPlotly({
    
    if (input$choice == "Enrollment") {
    
    df_group1 <- df %>% group_by(.,Study.Type, Enrollment) %>%
      count() 
    
      ggplotly(ggplot(data = df_group1,
             mapping = aes(x = Study.Type, y = Enrollment, fill = Study.Type)) +
      geom_boxplot(outlier.color = NA, na.rm = TRUE) +
      coord_cartesian(ylim = c(0, 5000)) +
      labs(title = "Enrollment By Study Type") +
      xlab("Study Type") +
      ylab("Enrollment Number"), height = 500, width = 800)
      
    }else if (input$choice == "Duration"){ 
      
      df_group2 <- df %>% group_by(.,Study.Type, Duration) %>% 
        count() 
      
      ggplotly(ggplot(data = df_group2,
                      mapping = aes(x = Study.Type, y = Duration, fill = Study.Type)) +
      geom_boxplot(outlier.color = NA, na.rm = TRUE, show.legend = TRUE) +
      coord_cartesian(ylim = c(0, 500)) +
      labs(title = "Duration By Study Type") +
      xlab("Study Type") +
      ylab("Months"), height = 500, width = 800)
    
    }
  })  
  
### DATA TABLE ###
  output$table <- renderDataTable({ 
    datatable(df_2) 
  })
  
  
})

