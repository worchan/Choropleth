if(!require("plotly"))
{
  install.packages("plotly")
  require("plotly")
}
if(!require("readxl"))
{
  install.packages("readxl")
  require("readxl")
}
if(!require("shiny"))
{
  install.packages("shiny")
  require("shiny")
}
if(!require("envDocument"))
{
  install.packages("envDocument")
  require("envDocument")
}
address = getScriptPath()
address1 = sub(pattern = "prog.r",replacement="region_2016_2017.xlsx",address)
address2 = sub(pattern = "prog.r",replacement="region_2015_2017.xlsx",address)
address3 = sub(pattern = "prog.r",replacement="region_2012_2017.xlsx",address)
address4 = sub(pattern = "prog.r",replacement="region_2007_2017.xlsx",address)
dfa = read_excel(address1)
dfb = read_excel(address2)
dfc = read_excel(address3)
dfd = read_excel(address4)

ui<-fluidPage(
  titlePanel("Keywords And their Hits on a Choropleth"),
  sidebarLayout(
    sidebarPanel(
      selectInput("keyword","Please Select a keyword",
                  choices = unique(dfa$keyword))
    ),
    mainPanel(
      plotlyOutput(outputId = "distPlot")
    )
  ),
  selectInput("TimeFrame","Please Select the Time Frame",
              choices = c("1 year","2 years","5 years","10 years"))
)


server <-function(input,output){
  output$distPlot <- renderPlotly({
    kw <- input$keyword
    #address = getScriptPath()
    if(input$TimeFrame=="1 year")
    {
      k = (dfa$keyword==kw)  
      df2 = dfa[k,]
    }
    else if(input$TimeFrame=="2 years")
    {
      k = (dfb$keyword==kw)
      df2 = dfb[k,]
    }
    else if(input$TimeFrame=="5 years")
    {
      k = (dfc$keyword==kw) 
      df2 = dfc[k,]
    }
    else if(input$TimeFrame=="10 years")
    {
      k = (dfd$keyword==kw)
      df2 = dfd[k,]
    }
    
    
    
    
    
    l <- list(color = toRGB("grey"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type='Mercator')
    )
    plot_ly(df2,locationmode='country names',z=df2$hits,locations=df2$location,text=df2$location,
            type='choropleth',color=df2$hits,colors='Blues',marker=list(line=l),
            colorbar=list(title="Hits"))%>%
      layout(geo=g)
    
    
  })
}
shinyApp(ui = ui,server = server)
