library(leaflet)
library(shinyWidgets)

navbarPage("Southern California DDT+ Research Portal", id="nav",
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
                                        inputId = "parameters",
                                        label = "Measurements",
                                        choices = meas_vars,
                                        selected = meas_vars,
                                        multiple = TRUE,
                                        options = list(
                                          `actions-box` = TRUE,
                                          `deselect-all-text` = "Deselect All",
                                          `select-all-text` = "Select All",
                                          `none-selected-text` = "None selected"
                                        )
                                      ),
                                      pickerInput(
                                        inputId = "institutions",
                                        label = "Institutions",
                                        choices = inst_vars,
                                        selected = inst_vars,
                                        multiple = TRUE,
                                        options = list(
                                          `actions-box` = TRUE,
                                          `deselect-all-text` = "Deselect All",
                                          `select-all-text` = "Select All",
                                          `none-selected-text` = "None selected"
                                        )
                                      ),
                                      checkboxInput("cluster", "Toggle clustering", value = FALSE),
                                      materialSwitch(inputId = "showDumpsite", label = "Show Known Dumpsites", status = "danger", value = TRUE),
                                      p(id = "attribution", em("(Source: USC Sea Grant; approximated from 1973 SCCWRP Report')"))
                                      
                        ),
                        
                        tags$div(id="cite",
                                 'Sources: Esri, GEBCO, NOAA, National Geographic, DeLorme, HERE, Geonames.org, and other contributors'
                        )
                    )
           ),
           
           tabPanel("Learn more",
                    htmlOutput("frame")
                    #DT::dataTableOutput("ziptable")
           ),
)