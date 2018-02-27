# plumber.R

#* Log some information about the incoming request
#* @filter logger
function(req){
    cat(as.character(Sys.time()), "-", 
        req$REQUEST_METHOD, req$PATH_INFO, "-", 
        req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "-", req$SERVER_PORT, "\n")
    plumber::forward()
}

#' Example of throwing an error
#' @get /simple
function(){
    stop("I'm an error!")
}

#' Generate a friendly error
#' @get /friendly
function(res){
    msg <- "Your request did not include a required parameter."
    res$status <- 400 # Bad request
    list(error=jsonlite::unbox(msg))
}
