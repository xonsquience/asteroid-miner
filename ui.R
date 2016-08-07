#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Asteroid Miner"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("checkGroup", label = h3("Resources"), 
                         choices = list("Aluminum" = "Aluminum 4",
                                        "Iron Silicate" = "Iron_Silicate 6",
                                        "Magnesium Silicate" = "Magnesium_Silicate 8",
                                        "Platinum" = "Platinum 10",
                                        "Stainless Steel" = "Stainless_Steel 12",
                                        "Cobalt" = "Cobalt 14",
                                        "Nickel-Iron" = "Nickel-Iron 16",
                                        "Nickel" = "Nickel 18",
                                        "Iron" = "Iron 20",
                                        "Oxygen" = "Oxygen 22",
                                        "Ammonia" = "Ammonia 24",
                                        "Nitrogen" = "Nitrogen 26",
                                        "Hydrogen" = "Hydrogen 28",
                                        "Water" = "Water 30"),
                         selected = "Nickel-Iron"),
      br(),
      p("For an asteroid having N close approaches: each approach is plotted with 
        weight 1/N, and its total mass or value is displayed if it appears in one of the top3 tables."),
      br(),
      strong("Features to be added:"),
      p("- sliders for approach date and distance ranges"),
      p("- options for if and how to weight each approach")
      
      # put asteroids of interest and their close-approach dates here, separated by blank lines
    ),
    
    # Show plots
    mainPanel(
       plotOutput("mplot"),
       tableOutput("topM"),
       plotOutput("vplot"),
       tableOutput("topV")
    )
  )
))
