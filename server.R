#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

A <- read.csv('A_A.csv', header = TRUE, stringsAsFactors = FALSE)

# resources is string "resource1 index1 resource2 index2..."
# mv is "m" to output mass data, "v" to output value data
xy <- function(resources, mv) {
  elements <- unlist(strsplit(resources, " "))
  
  n <- vector(mode = "character", length = length(elements)/2)
  i <- vector(mode = "numeric", length = length(elements)/2)
  if (!is.null(length(elements))) {
    u <- 0
    for (r in seq(1, length(elements), 2)) {
      u <- u + 1
      n[u] <- elements[r]
      i[u] <- as.numeric(elements[r+1])
    }
  }
  
  dt <- matrix(0, nrow = length(elements)/2, ncol = 35)
  
  rownames(dt) <- n
  colnames(dt) <- c(2016:2050)
  
  # table of asteroids, their total quantity (mass or USD), and their approach dates for this query
  asteroids <- data.frame()
  
  for (w in 1:nrow(A)) {
    weight <- 1/(length(strsplit(A[w,33], " ")[[1]]) - 1)
    
    # sum quantity (mass or value) for this asteroid
    total <- 0
    
    # dt is populated with [k,l] coordinates
    l <- 0
    for (y in colnames(dt)) {
      l <- l + 1
      for (ca in strsplit(A[w,33], " ")[[1]]) {
        if (substr(ca, 1, 4) == y) {
          k <- 0
          for (r in i) {
            k <- k + 1
            if (mv == 'm') {
              total <- total + A[w,r]*weight
              dt[k,l] <- dt[k,l] + A[w,r]*weight
            } else {
              total <- total + A[w,r+1]*weight
              dt[k,l] <- dt[k,l] + A[w,r+1]*weight
            }
          }
        }
      }
    }
    asteroid <- data.frame(A[w,1], total, A[w,33])
    asteroids <- rbind(asteroids, asteroid)
  }
  # order top asteroids and assign column names
  asteroids <- asteroids[order(asteroids[,2], decreasing = TRUE),]
  if (mv == 'm') {
    colnames(asteroids) <- c("Name", "Mass (kg)", "Closest Approach Dates")
  } else {
    colnames(asteroids) <- c("Name", "Value (USD)", "Closest Approach Dates")
  }
  return(list(dt, asteroids))
}


shinyServer(function(input, output) {
  
  xyMCall <- reactive({xy(paste(unlist(input$checkGroup), collapse=" "), 'm')})
  xyVCall <- reactive({xy(paste(unlist(input$checkGroup), collapse=" "), 'v')})
  
  output$topM <- renderTable({
    head(xyMCall()[[2]], 3)
  })
  
  output$topV <- renderTable({
    head(xyVCall()[[2]], 3)
  })
  
  output$mplot <- renderPlot({
    Mdata <- xyMCall()[[1]]
    barplot(Mdata,
            legend = rownames(Mdata),
            main = "Resource Availability",
            xlab = "Year",
            ylab = "Mass (kg)",
            col = rainbow(14))
  })
  
  output$vplot <- renderPlot({
    Vdata <- xyVCall()[[1]]
    barplot(Vdata,
            legend = rownames(Vdata),
            main = "Value in Current Market",
            xlab = "Year",
            ylab = "USD",
            col = rainbow(14))
  })
})
