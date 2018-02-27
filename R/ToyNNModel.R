install.packages("keras")
library(keras)
    install_keras()
is_keras_available()

# Load in and data engineering --------------------------------------------
# Read in `iris` data
iris <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"), header = FALSE) 
str(iris)
head(iris)
# Turn into a matrix
iris[,5] <- as.numeric(iris[,5])-1
iris <- as.matrix(iris)
dimnames(iris) <- NULL
head(iris)
# Normalize the features
irisT <- iris[,5]
irisF <- normalize(iris[,1:4])
iris <- cbind(irisF, irisT)
rm(irisF, irisT)
irisF <- iris[, 1:4]
irisT <- iris[, 5]
# One hot encode training target values
irisT <- to_categorical(irisT)

# Model Construction ------------------------------------------------------
# Initialize a sequential model
model <- keras_model_sequential() 
model %>% 
    layer_dense(units = 16, activation = 'relu', input_shape = c(4)) %>% 
    layer_dropout(0.25) %>%
    layer_dense(units = 8, activation = 'relu', input_shape = c(16)) %>%
    layer_dropout(0.25) %>%
    layer_dense(units = 3, activation = 'softmax') %>% 
# Print a summary of a model
summary(model)
# List the model's layers
model$layers
# Compile the model
model %>% compile(
    loss = 'categorical_crossentropy',
    optimizer = 'adam',
    metrics = c('accuracy')
)
# Fit the model 
model %>% fit(
    irisF, 
    irisT, 
    epochs = 200, 
    batch_size = 5, 
    validation_split = 0.2
)
# Save it out
save_model_hdf5(model, "toymodel.h5")
rm(iris, irisF, irisT, model)
