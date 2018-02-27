install.packages("plumber")
library(plumber)

pr <- plumber::plumb("plumber1.R")
# pr$registerHook("exit", function(){
#     print("API 1 is terminated")
# })
pr$run()

pr <- plumber::plumb("plumber2.R")
pr$registerHook("exit", function(){
    print("API 2 is terminated")
})
pr$run()

pr <- plumber::plumb("plumber3.R")
pr$registerHook("exit", function(){
    print("API 3 is terminated")
})
pr$run()


