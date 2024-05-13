library(leaflet)
library(shinyWidgets)

navbarPage(app_title, id="nav",
           tabPanel("Interactive map",
                    div(class="outer",
  
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = 20, right = "auto", bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Data filters:"),

                                      pickerInput(
                                        inputId = "variable_types",
                                        label = "Measurements",
                                        choices = variable_types,
                                        selected = variable_types,
                                        multiple = TRUE,
                                        options = list(
                                          `actions-box` = TRUE,
                                          `deselect-all-text` = "Deselect All",
                                          `select-all-text` = "Select All",
                                          `none-selected-text` = "None selected"
                                        )
                                      ),
                                      pickerInput(
                                        inputId = "organizations",
                                        label = "Organizations",
                                        choices = organizations,
                                        selected = organizations,
                                        multiple = TRUE,
                                        options = list(
                                          `actions-box` = TRUE,
                                          `deselect-all-text` = "Deselect All",
                                          `select-all-text` = "Select All",
                                          `none-selected-text` = "None selected"
                                        )
                                      ),
                                      #checkboxInput("cluster", "Toggle clustering", value = FALSE)
                        ),
                        tags$div(id="cite",
                                 attribute_string
                        )
                    )
           ),
           tabPanel("Learn more",
                    htmlOutput("frame")
           ),
)