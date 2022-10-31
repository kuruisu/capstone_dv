# Fungsi dashboardPage() diperuntuhkan untuk membuat ketiga bagian pada Shiny
dashboardPage(skin = "black",
              
              # Fungsi dashboardHeader() adalah bagian untuk membuat header
              dashboardHeader(title = "AIRBNB"),
              
              # Fungsi dashboardSidebar() adalah bagian untuk membuat sidebar
              dashboardSidebar(
                
                #sidebarMenu adalah fungsi untuk membuat bagian menu disamping
                sidebarMenu(
                  
                  #menutItem adalah fungsi untuk membuat kolom tab menu dibagian menu samping
                  menuItem(text = "Dashboard", 
                           tabName = "dashboard", 
                           icon = icon("globe")), 
                  
                  menuItem(text = "Airbnb",
                           tabName = "airbnb",
                           icon = icon("airbnb")),
                  
                  menuItem(text = "Data",
                           tabName = "data",
                           icon = icon("database")),
                  
                  menuItem(text = "Source Code",
                           icon = icon("file-code"), href="https://github.com/kuruisu/capstone_dv")
                )
              ),
              
              # Fungsi dashboardBody() adalah bagian untuk membuat isi body
              dashboardBody(
                # Fungsi tabItems() adalah fungsi untuk mengumupulkan semua isi dari body pada setiap menu
                tabItems(
                  
                  #TAB 1
                  tabItem(
                    tabName = "dashboard", # tabeName adalah parameter untuk memberi tahu bagian Menu mana yang ingin kita isi atau masukan data
                    fluidPage(
                      h2(tags$b("New York City Airbnb")),
                      br(),
                      div(style = "text-align:justify", 
                          p("Airbnb, Inc is an American company that operates an online marketplace for lodging, 
                            primarily homestays for vacation rentals, and tourism activities. 
                            Based in San Francisco, California, the platform is accessible via website and mobile app.
                            Airbnb does not own any of the listed properties; instead, it profits by receiving commission from each booking. 
                            The company was founded in 2008. Airbnb is a shortened version of its original name, AirBedandBreakfast.com"),
                    br()
                      )
                    ),
                    fluidPage(
                      tabBox(width = 8,
                             title = tags$b("Airbnb Top 10 Group by Neighbourhood for Private Room"),
                             id = "tabset1",
                             side = "right",
                             tabPanel(tags$b("Aribnb Top 10 Average Price"), 
                                      plotlyOutput("group1")
                             ),
                             tabPanel(tags$b("Aribnb Top 10 Average Serice Fee"), 
                                      plotlyOutput("group2")
                             )    
                            ),
                            infoBox(title = "Total Room Type ",
                                        value = length(unique(airbnb_clean$room_type)),
                                        icon = icon("building"),
                                        color = "blue"),
                            infoBox(title = "Total Available Cancellation",
                                        value =length(unique(airbnb_clean$cancellation_policy)),
                                        icon = icon("building-shield"),
                                        color = "red"),
                            infoBox(title = "Total Neighbourhood Group",
                                        value = length(unique(airbnb_clean$neighbourhood_group)),
                                        icon = icon("user-group"),
                                        color = "green"),
                            infoBox(title = "Total Neighbourhood",
                                        value = length(unique(airbnb_clean$neighbourhood)),
                                        icon = icon("people-group"),
                                        color = "yellow")
                    
                            ),
                    
                    fluidPage(
                      box(width = 12,plotlyOutput("hexp"))
                             )
                  ),
                  
                  #TAB 2
                  tabItem(
                    tabName = "airbnb",
                    fluidPage(
                      box(solidHeader = T,
                          width = 3,
                          height =  420,
                          background = "aqua",
                          selectInput(inputId = "input_neigbour",
                                      label = h4(tags$b("Select Neigbourhood Group:")),
                                      choices = unique(airbnb_clean$neighbourhood_group))),
                      box(solidHeader = T,
                          width = 9,
                          plotlyOutput("bar_neighbourhood"))),

                      fluidPage(
                        box(solidHeader = T,
                            width = 3,
                            height =  420,
                            background = "aqua",
                            sliderInput(
                              inputId = "bin",
                              "Bin Configuration",
                              min = 25,
                              max = 100,
                              value = 25,
                              sep = ""
                            )),
                        box(solidHeader = T,
                            width = 9,
                            plotlyOutput("sliderinteractive"))
                        
                      )
                          ),
                
                #TAB 3
                tabItem(
                  tabName = "data",
                  h2(tags$b("Airbnb in New York City")),
                  DT::dataTableOutput("datadisplay"))
              
          )      
    )
)
