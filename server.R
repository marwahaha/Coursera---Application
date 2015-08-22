library(shiny)
library(ggplot2)
library(markdown)


# Simulating Data
n=10000
l=200

df.web <- data.frame(
  time = seq(Sys.time(), len=l, by="1 min")[sample(l, n,replace = TRUE)],
  type_data = "Web",
  web = 1,
  call = 0,
  question = rbinom(n,1,.75),
  answered = 0,
  abandonned = 0
)

df.call <- data.frame(
  time = seq(Sys.time(), len=l, by="1 min")[sample(l, n,replace = TRUE)],
  type_data = "Call Center",
  web = 0,
  call = 1,
  question = 0,
  answered = rbinom(n,1,.85),
  abandonned = rbinom(n,1,.35)
)

Web_Call  = rbind(df.web,df.call)
shinyServer(function(input, output) {
  #filter = NULL
  
  # Variables Env
  pause = NULL
  colCall = NULL
  colCall = NULL
  #Web_filtred = NULL
  
  dataset <- reactive({
    pause <<- paste(input$pause,"min")
    #print(pause)
    # Filtering
    # Web
    if(input$filterWeb1=="All"){
      filter = (Web_Call$web==1)
      #print("all")
      #print(sum(filter))
      Web_filtred = Web_Call[filter,c("time","type_data")]
    }
    if(input$filterWeb1=="Question"){
      filter = (Web_Call$question==1) & (Web_Call$web==1)
      #print(sum(filter))
      Web_filtred = Web_Call[filter,c("time","type_data")]
    }


    # Filtering
    # Call
    
    if(input$filterCall1=="All"){
      filter = (Web_Call$call==1)
      Call_filtred = Web_Call[filter,c("time","type_data")]
    }
    if(input$filterCall1=="Abandonned"){
      filter = (Web_Call$call==1) & (Web_Call$abandonned==1)
      Call_filtred = Web_Call[filter,c("time","type_data")]
    }
    if(input$filterCall1=="Answered"){
      filter = (Web_Call$call==1) & (Web_Call$answered==1)
      Call_filtred = Web_Call[filter,c("time","type_data")]
    }

    data.call = data.frame(table(cut(Call_filtred$time, breaks = pause)),Type = "Call")
    colnames(data.call) <- c("Time","Nombre","Type")
    data.web = data.frame(table(cut(Web_filtred$time, breaks = pause)),Type = "Web")
    colnames(data.web) <- c("Time","Nombre","Type")
    data.call_web <- rbind(data.web,data.call)
    # Conversion to Time
    data.call_web$Time = as.POSIXct(data.call_web$Time,tz = "UTC")
    
    if (input$courbe == 'Web'){
      data.call_web=data.call_web[data.call_web$Type=='Web',]
    }else if (input$courbe == 'Call'){
      data.call_web=data.call_web[data.call_web$Type=='Call',]
    }else{
      #
    }
    
    data.call_web
    
  })
  

  
  output$plot <- renderPlot({
    
    if (input$courbe == 'Web'){
      # Color Web
      colWeb <<- rgb(247,118,109,maxColorValue = 255)
      # Plotting
      gg <- ggplot(dataset(),aes(x=Time,y=Nombre))
      # Web line
      gg <- gg + geom_line(aes(group = Type),colour=colWeb,size=1.2) 
      gg <- gg + theme(axis.text.x = element_text(angle = 90, hjust = 1))  
      gg <- gg + theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
      gg <- gg + ggtitle(paste("Session count ",paste("(",pause,")"))) + theme(plot.title = element_text(lineheight=.8, face="bold"))
      gg
    }else if (input$courbe == 'Call'){
      # Color Call
      colCall <<- rgb(0  ,191,196,maxColorValue = 255)
      # Plotting
      gg <- ggplot(dataset(),aes(x=Time,y=Nombre))
      # Calll line
      gg <- gg + geom_line(aes(group = Type),colour=colCall,size=1.2) 
      gg <- gg + theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
      gg <- gg + ggtitle(paste("Call count ",paste("(",pause,")"))) + theme(plot.title = element_text(lineheight=.8, face="bold"))
      gg 
    }else{
      
      # Scaling
      daw = subset(dataset(),Type=="Web")
      daw$Freq = scale(daw$Nombre)
      dac = subset(dataset(),Type=="Call") 
      dac$Freq = scale(dac$Nombre)
      da <- rbind(daw,dac)

      # Plotting 
      # Curve line Web & Call
      
      gg <- ggplot(da)
      gg <- gg + geom_line(aes(x=Time,y=Freq,colour = Type),size=1.2)
      gg <- gg + theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
      gg <- gg + ggtitle(paste("Session and Call count ",paste("(",pause,")"))) + theme(plot.title = element_text(lineheight=.8, face="bold"))
      gg 
    }
    
    
  })
  
  

  
  
})