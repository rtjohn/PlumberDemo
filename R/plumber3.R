# Global code; gets executed at plumb() time.
#install.packages("keras")
library(keras)
mod <- load_model_hdf5("toymodel.h5")

# Define an ednpoint that looks for the inputs to a model
#' @get /score
test <- function(v1 = NULL, v2 = NULL, v3 = NULL, v4 = NULL){
    new <- matrix(c(v1, v2, v3, v4), nrow=1, ncol=4)
    class <- mod %>% 
        predict_classes(new)
    class
}

