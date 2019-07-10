# Coursera Shiny Application

This repository contains the ui.R and server.R of my applications.

The created Shiny Application is called **"Time Series Explorer"**, and is deployed on ShinyServer in this link: https://adanba.shinyapps.io/Coursera-Application


# Documentation




## What this application do:

This application is a **"Time Series Explorer"**, with some pre-programming **Filter** on data.

This **"Time Series Explorer"** correspondants to the frequency of a **Call Center** in parllel to the **Web Site** of a company.

The aim of this application is to see the correlation between the Web and Call, and explore this correlation to optimize the **Call Center**.



## How get the Data: 

The Data is simulated with this code:

```

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
  abandoned = 0
)

df.call <- data.frame(
  time = seq(Sys.time(), len=l, by="1 min")[sample(l, n,replace = TRUE)],
  type_data = "Call Center",
  web = 0,
  call = 1,
  question = 0,
  answered = rbinom(n,1,.85),
  abandoned = rbinom(n,1,.35)
)

Web_Call  = rbind(df.web,df.call)

```


## How to process Data:

We should process data before ploting it, because we have a brute data and we should aggregate this data to an interval of time, therefor we use this code:

```
data.call = data.frame(table(cut(Call_filtred$time, breaks = "5 min")),Type = "Call")
colnames(data.call) <- c("Time","Nombre","Type")
```

It creates an aggregate data with the numbre of occurrence in a time interval (default 5 min)


## Pre-Programming Filtering:

Pre-programming filters are a kind of filter on data Web or Call, that we can choose via `selectInput` 

### 1. Filter Web:
We have two filters:
* The first one is plot All Data
* The second filter plot the session only with question.

### 2. Filter Call:
We have three filters here:
* The first one is plot All Data of Call Center
* Plot only the frequency of call answered
* Plot only the frequency of call abandoned



## Plotting Options:

We used `radioButtonscan` to choose one of the three these plotting modes (default web):

* Only Web Data
* Only Call Data
* Both Web and Call Data

We also can modify the step of calculating frequency (default pause = 5 min), here we used `sliderInput`.




# Deploy my Application:

We use this code:

```
library(devtools)
library(shiny)
library(shinyapps)

setAccountInfo(name='adanba', token='1FFB53913C7D9BFBD16862C43D6C356A', secret='XXXX')
deployApp(appName = "Coursera-Application","/Desktop/Coursera -AppsWeb2/")
```

