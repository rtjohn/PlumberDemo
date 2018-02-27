# plumber.R
# Demo script that contains X endpoints
# /echoj
# /echoh
# /users/<code>
# /user/<code1>/partner/<code2>
# /plot

# # Global code; gets executed at plumb() time -------------------------------------------------------------
#  This code will always run.
library(stringr)
library(dplyr)
users <- data.frame(
    username=c("Vermont", "Jim", "MeLikeyStats", "Ugh"),
    person=c("Alex Diamond", "Jim Johnson", "Thomas Jackson", "Katrina Torng")
)

eggs <- data.frame(
    username=c("Vermont", "Jim", "MeLikeyStats", "Ugh"),
    dish=c("Diavola", "Anything", "Cake", "Ramen"),
    orders=c(2, 4, 2, 2),
    price=c(3.50, 3.52, 3.51, 3.49)
)

# Endpoint code -------------------------------------------------------------
# The functions below will only run when their endpoint is called

#' Echo the parameter that was sent in as JSON
#' @param msg The message to echo back.
#' @get /echoj
function(msg=""){
    list(msg = paste0("The message is: '", msg, "'"))
}

#' Echo the parameter that was sent in as HTML
#' @param msg The message to echo back.
#' @get /echoh
#' @html
function(msg=""){
    x <- str_replace_all(msg, "_", " ")
    paste0("<html><h1>", x[[1]], "</h1></html>")
}

#' Lookup a user
#' @get /users/<code0>
function(code0){
    filter(users, username == code0)
}

#' Run some code based on the inputs
#' @get /user/<code1>/partner/<code2>
#' @html
function(code1, code2){
    bill <- left_join(users, eggs, by = "username") %>% 
        filter(username == code1 | username == code2) %>% 
        mutate(total = orders*price) %>% 
        summarise(sum(total))
    paste0('<html><h1>', 'Their bill was ' , '$', bill[[1]], '</h1></html>')
}

#' Plot out data from the iris dataset
#' @param spec If provided, filter the data to only this species (e.g. 'setosa')
#' @get /plot
#' @png
function(spec){
    myData <- iris
    title <- "All Species"
    # Filter if the species was specified
    if (!missing(spec)){
        title <- paste0("Only the '", spec, "' Species")
        myData <- subset(iris, Species == spec)
    }
    plot(myData$Sepal.Length, myData$Petal.Length,
         main=title, xlab="Sepal Length", ylab="Petal Length")
}
