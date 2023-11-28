library(shiny)
library(stringr)
library(shinythemes)
source('src/utils.R')
ui <- fluidPage(theme = shinytheme('yeti'),
  navbarPage(title = 'Bread Calculator',
             tabPanel(title = 'Ingredients',
                      sidebarLayout(
                        sidebarPanel = sidebarPanel(width = 5,
                          h4('Select additional ingredients for your bread!'),
                          checkboxGroupInput(inputId = 'ingredients',
                                             label = 'Available Ingredients',
                                             choices = c('Poolish',
                                                         'Levain',
                                                         'Oil',
                                                         'Butter',
                                                         'Yeast',
                                                         'Sugar',
                                                         'Honey'),
                                             selected = c('Poolish')
                                            ) 
                          ), 
                        mainPanel = mainPanel(width = 6,
                          h3('Input the desired quantaties for ingredients'),
                          p("Feel free to experiment with different types of flours!", style = "font-size:12px;"),
                          numericInput(inputId = 'flour_weight',
                                       label = 'Flour (grams)',
                                       value = 500,
                                       min = 0),
                          h4("Inputs in Baker's percentages"),
                          p("Baker's percentages are defined as percentages relative in to total flour.", style = "font-size:12px;"),
                          sliderInput(inputId = 'hydration_percent',
                                      label = 'Hydration level (%)',
                                      min = 0,
                                      max = 100,
                                      value = 70,
                                      step = 1),
                          sliderInput(inputId = 'salt_percent',
                                      label = 'Salt level (%)',
                                      min = 0,
                                      max = 10,
                                      value = 3,
                                      step = 1),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Poolish')",
                            fluidRow(column(width = 6, style='padding-right: 1px; margin-right: 1px;',
                            sliderInput(
                              inputId = 'poolish_percent',
                              label = 'Poolish (%)',
                              value = 30,
                              min = 0,
                              max = 100
                            )),
                            column(width=2, style='padding-right: 1px; margin-right: 1px;',
                                   selectInput(inputId = 'poolish_time',
                                    label = 'Poolish leaven time (hours)',
                                    choices = c(2,4,6,8,12,18)))
                          )),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Levain')",
                            fluidRow(column(width = 6,
                                            sliderInput(
                                              inputId = 'levain_percent',
                                              label = 'Levain (%)',
                                              value = 20,
                                              min = 0,
                                              max = 100
                                            )),
                                     column(width=2,
                                            selectInput(inputId = 'levain_time',
                                                        label = 'Levain leaven time (hours)',
                                                        choices = c(4,8,12)))
                            )),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Butter')",
                            sliderInput(
                              inputId = 'butter_percent',
                              label = 'Butter (%)',
                              value = 0,
                              min = 0,
                              max = 10
                            )
                          ),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Yeast')",
                            sliderInput(
                              inputId = 'yeast_percent',
                              label = 'Yeast (%)',
                              value = 2,
                              min = 0,
                              max = 10,
                              step = 0.2
                            )
                          ),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Sugar')",
                            sliderInput(
                              inputId = 'sugar_percent',
                              label = 'Sugar (%)',
                              value = 0,
                              min = 0,
                              max = 50
                            )
                          ),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Honey')",
                            sliderInput(
                              inputId = 'honey_percent',
                              label = 'Honey (%)',
                              value = 0,
                              min = 0,
                              max = 50
                            )
                          ),
                          conditionalPanel(
                            condition = "input.ingredients.includes('Oil')",
                            sliderInput(
                              inputId = 'oil_percent',
                              label = 'Oil (%)',
                              value = 0,
                              min = 0,
                              max = 10
                            )
                          )
                        ),
                      )
             ),
             tabPanel(title = 'Recipe',
                      h1('Recipe'),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Levain') && input.levain_percent != 0",
                        style = "background-color: #f0f0f0; border-radius: 10px; padding: 5px; margin-bottom: 10px; max-width: 500px;",
                        h4('Making the levain'),
                        p(textOutput('levain_time', inline = TRUE),' hours before prepare levain (Ratio: ',textOutput('levain_parts', inline = TRUE),'of flour, water, and starter)',  style = "font-size:12px;"),
                        tags$ul(style='list-style-type: square;',
                                tags$li(style= "font-size:12px;",textOutput('levain_flour_weight', inline = TRUE),'grams of flour.', style = "font-size:12px;"),
                                tags$li(style= "font-size:12px;",textOutput('levain_water_weight', inline = TRUE),'grams of water.', style = "font-size:12px;"),
                                tags$li(style= "font-size:12px;",textOutput('levain_starter_weight', inline = TRUE),'grams of active starter.', style = "font-size:12px;"),
                                )
                        ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Poolish') && input.poolish_percent != 0",
                        style = "background-color: #f0f0f0; border-radius: 10px; padding: 5px; margin-bottom: 10px; max-width: 500px;",
                        h4('Making the poolish'),
                        p(textOutput('poolish_time', inline = TRUE),'hours before prepare poolish',  style = "font-size:12px;"),
                        tags$ul(style='list-style-type: square;',
                                tags$li(style= "font-size:12px;",textOutput('poolish_flour_weight', inline = TRUE),'grams of flour.', style = "font-size:12px;"),
                                tags$li(style= "font-size:12px;",textOutput('poolish_water_weight', inline = TRUE),'grams of water.', style = "font-size:12px;"),
                                tags$li(style= "font-size:12px;",textOutput('poolish_yeast_weight', inline = TRUE),'grams of fresh yeast.', style = "font-size:12px;"),
                        )
                      ),
                      mainPanel(style = "background-color: #546e7a75; border-radius: 10px; padding: 5px; 5px; margin-bottom: 10px; max-width: 500px;",
                      h4('Mix the final dough'),
                      tags$ul(style='list-style-type: square;',
                      tags$li(style= "font-size:12px;",textOutput('bulk_flour_weight', inline = TRUE),'grams of flour.', style = "font-size:12px;"),
                      tags$li(style= "font-size:12px;",textOutput('bulk_water_weight', inline = TRUE),'grams of water.', style = "font-size:12px;"),
                      tags$li(style= "font-size:12px;",textOutput('salt_weight', inline = TRUE),'grams of salt.', style = "font-size:12px;"),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Levain') && input.levain_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('levain_bulk_weight', inline = TRUE),'grams of prepared levain (use rest for refreshing sourdough).', style = "font-size:12px;")
                      ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Poolish') && input.poolish_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('poolish_total_weight', inline = TRUE),'grams of prepared poolish.', style = "font-size:12px;")
                      ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Oil') && input.oil_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('oil_weight', inline = TRUE),'grams of oil.', style = "font-size:12px;")
                        ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Butter') && input.butter_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('butter_weight', inline = TRUE),'grams of butter.', style = "font-size:12px;")
                      ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Yeast') && input.yeast_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('yeast_weight', inline = TRUE),'grams of fresh yeast.', style = "font-size:12px;")
                      ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Sugar') && input.sugar_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('sugar_weight', inline = TRUE),'grams of sugar.', style = "font-size:12px;")
                      ),
                      conditionalPanel(
                        condition = "input.ingredients.includes('Honey') && input.honey_percent != 0",
                        tags$li(style= "font-size:12px;",textOutput('honey_weight', inline = TRUE),'grams of honey.', style = "font-size:12px;")
                      ),
                      
                      )),
                      mainPanel(style = "padding: 5px; 5px; margin-bottom: 10px; max-width: 1200px;",
                      p('This will produce a dough with a total weight of:', textOutput('total_weight', inline = TRUE),'grams', style = "font-size:12px;"),
                      p('The total amount of flour in the dough will be:', textOutput('total_flour_weight', inline = TRUE),'grams', style = "font-size:12px;"),
                      p('The total amount of water in the dough will be:', textOutput('total_water_weight', inline = TRUE),'grams', style = "font-size:12px;"),
                      p('Giving a hydration level of:', textOutput('final_hydration', inline=TRUE),'%', style = "font-size:12px;"),
                      h3('Happy Baking! :)'))
                      ),
             tabPanel(title = 'Temperature',
                      'Formula')
  )
)
server <- function(input, output, session) {
  output$levain_time <- reactive(input$levain_time)
  output$poolish_time <- reactive(input$poolish_time)
  salt_weight <- reactive({
    grams_from_percent(input$salt_percent, input$flour_weight)
  })
  output$salt_weight <- reactive({salt_weight()})
  
  oil_weight <- reactive({
    calculate_ingredient_weight('Oil', input$oil_percent, input$flour_weight, input$ingredients)
  })
  output$oil_weight <- reactive({oil_weight()})
  
  butter_weight <- reactive({
    calculate_ingredient_weight('Butter', input$butter_percent, input$flour_weight, input$ingredients)
  })
  output$butter_weight <- reactive({butter_weight()})
  
  sugar_weight <- reactive({
    calculate_ingredient_weight('Sugar', input$sugar_percent, input$flour_weight, input$ingredients)
  })
  output$sugar_weight <- reactive({sugar_weight()})
  
  honey_weight <- reactive({
    calculate_ingredient_weight('Honey', input$honey_percent, input$flour_weight, input$ingredients)
  })
  output$honey_weight <- reactive({honey_weight()})
  
  yeast_weight <- reactive({
    calculate_ingredient_weight('Yeast', input$yeast_percent, input$flour_weight, input$ingredients)
  })
  output$yeast_weight <- reactive({yeast_weight()})
  
  total_water_weight <- reactive({input$flour_weight * input$hydration_percent / 100})
  output$total_water_weight <- reactive(total_water_weight())
  output$total_flour_weight <- reactive({input$flour_weight})
  output$final_hydration <- reactive({ total_water_weight() / input$flour_weight * 100})
  
  levain_bulk_weight <- reactive({
    calculate_ingredient_weight('Levain', input$levain_percent, input$flour_weight, input$ingredients)
  })
  
  output$levain_bulk_weight <- reactive({levain_bulk_weight()})
  levain_total_weight <- reactive({levain_bulk_weight() + 100})
  output$levain_total_weight <- reactive({levain_total_weight})
  
  starter_ratio <- reactive({
    if ('Levain' %in% input$ingredients){
      if (input$levain_time == 4){round(1/3,digits = 2)}
      else if (input$levain_time == 8){round(1/5,digits = 2)}
      else if (input$levain_time == 12){round(1/10,digits = 2)}
    }else{0}
  })
  output$starter_ratio <- reactive({starter_ratio()})
  
  output$levain_parts <- reactive({
    if ('Levain' %in% input$ingredients){
      if (input$levain_time == 4){"1:1:1"}
      else if (input$levain_time == 8){"2:2:1"}
      else if (input$levain_time == 12){"5:5:1"}
    }else{0}
  })
  output$starter_ratio <- reactive({starter_ratio()})
  
  levain_starter_weight <- reactive({
    if ('Levain' %in% input$ingredients){starter_ratio() * (levain_total_weight())}
    else{0}
  })
  output$levain_starter_weight <- reactive({levain_starter_weight()})
  
  levain_water_weight <- reactive({
    if ('Levain' %in% input$ingredients){(levain_total_weight()-levain_starter_weight()) / 2}
    else{0}
  })
  output$levain_water_weight <- reactive({levain_water_weight()})
  
  levain_flour_weight <- reactive({
    if ('Levain' %in% input$ingredients){(levain_total_weight()-levain_starter_weight()) / 2}
    else{0}
  })
  output$levain_flour_weight <- reactive({levain_flour_weight()})
  
  poolish_flour_weight <- reactive({
    calculate_ingredient_weight('Poolish', input$poolish_percent, input$flour_weight, input$ingredients)
  })
  output$poolish_flour_weight <- reactive({poolish_flour_weight()})
  
  poolish_water_weight <- reactive({
    if ('Poolish' %in% input$ingredients){poolish_flour_weight()}else{0}
  })
  output$poolish_water_weight <- reactive({poolish_water_weight()})
  
  poolish_yeast_ratio <- reactive({
    if ('Poolish' %in% input$ingredients){
      if (input$poolish_time == 2){0.03}
      else if (input$poolish_time == 4){0.015}
      else if (input$poolish_time == 8){0.0075}
      else if (input$poolish_time == 12){0.002}
      else if (input$poolish_time == 18){0.001}
    }else{0}
  })
  output$poolish_yeast_ratio <- reactive({poolish_yeast_ratio()})
  
  poolish_yeast_weight <- reactive({
    if ('Poolish' %in% input$ingredients){
      poolish_flour_weight() * poolish_yeast_ratio()
    }else{0}
  })
  output$poolish_yeast_weight <- reactive({poolish_yeast_weight()})
  
  poolish_total_weight <- reactive({poolish_water_weight() + poolish_flour_weight()+ poolish_yeast_weight()})
  output$poolish_total_weight <- reactive({poolish_total_weight()})
  
  bulk_water_weight <- reactive({
    weight <- input$flour_weight * input$hydration_percent / 100
    if ('Poolish' %in% input$ingredients){
      weight <- weight - poolish_water_weight()
    }
    if ('Levain' %in% input$ingredients){
      weight <- weight - levain_water_weight()
    }
    weight
  })
  output$bulk_water_weight <- reactive({bulk_water_weight()})
  
  bulk_flour_weight <- reactive({
    weight <- input$flour_weight
    if ('Poolish' %in% input$ingredients){
      weight <- weight - poolish_flour_weight()
    }
    if ('Levain' %in% input$ingredients){
      weight <- weight - levain_flour_weight()
    }
    weight
  })
  output$bulk_flour_weight <- reactive({bulk_flour_weight()})
  
  output$total_weight <- reactive({
    total_weight <- 0
    total_weight <- total_weight + bulk_flour_weight()
    total_weight <- total_weight + bulk_water_weight()
    total_weight <- total_weight + salt_weight()
    if ('Poolish' %in% input$ingredients){
    total_weight <- total_weight + poolish_flour_weight()
    total_weight <- total_weight + poolish_water_weight()
    total_weight <- total_weight + poolish_yeast_weight()
    }
    if ('Levain' %in% input$ingredients){
      total_weight <- total_weight + levain_flour_weight()
      total_weight <- total_weight + levain_water_weight()
      total_weight <- total_weight + levain_starter_weight()
    }
    if ('Oil' %in% input$ingredients){
      total_weight <- total_weight + oil_weight()
    }
    if ('Butter' %in% input$ingredients){
      total_weight <- total_weight + butter_weight()
    }
    if ('Yeast' %in% input$ingredients){
      total_weight <- total_weight + yeast_weight()
    }
    if ('Sugar' %in% input$ingredients){
      total_weight <- total_weight + sugar_weight()
    }
    if ('Honey' %in% input$ingredients){
      total_weight <- total_weight + honey_weight()
    }
    total_weight
  })

}
shinyApp(ui, server)

