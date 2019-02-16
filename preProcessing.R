### Pre processing in caret

## 0. Load libraries
library(caret)
library(dplyr)

## 1. Create Dummy Variables
library(earth)
data(etitanic)

# 1.1 Create dummy variables using stats library
head(model.matrix(survived ~., data = etitanic))

# 1.2 Create dummy variables using careti library
dummies <- dummyVars(survived ~., data = etitanic)
head(predict(dummies, newdata = etitanic))

# Sometimes such parametrization could not be usefull, for example in lm model.
# model.matrix function give us parametrization with intercept and limited amount of variables,
# because for example when sex.male is equal to 0 we know that is a female.

# 2 Zero- and Near Zero-Variance Predictors
data(mdrr)
data.frame(table(mdrrDescr$nR11))

nzv <- nearZeroVar(mdrrDescr, saveMetrics = TRUE)
nzv[nzv$nzv,][1:10,]
nzv_results <- nzv %>%
  filter(nzv == TRUE) %>%
  arrange(desc(freqRatio))

dim(mdrrDescr)

nzv <- nearZeroVar(mdrrDescr)
filteredDescr <- mdrrDescr[,-nzv]
dim(filteredDescr)

# 3. Identifying Correlated Predictors
descrCor <- cor(filteredDescr)
summary(descrCor[upper.tri(descrCor)])

higlyCorDescr <- findCorrelation(descrCor, cutoff = .75)
filteredDescr <- filteredDescr[,-higlyCorDescr] 
descrCor2 <- cor(filteredDescr)
summary(descrCor2[upper.tri(descrCor2)])

dim(filteredDescr)

# 4. Linear Dependencies
ltfrDesign <- matrix(0, nrow = 6, ncol = 6)
ltfrDesign[,1] <- c(1, 1, 1, 1, 1, 1)
ltfrDesign[,2] <- c(1, 1, 1, 0, 0, 0)
ltfrDesign[,3] <- c(0, 0, 0, 1, 1, 1)
ltfrDesign[,4] <- c(1, 0, 0, 1, 0, 0)
ltfrDesign[,5] <- c(0, 1, 0, 0, 1, 0)
ltfrDesign[,6] <- c(0, 0, 1, 0, 0, 1)

comboInfo <- findLinearCombos(ltfrDesign) 
ltfrDesign[,-comboInfo$remove]

# 5. The preProcess function

# 6. Centering and Scalling
set.seed(123)
inTrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2)

training <- filteredDescr[inTrain,]
testing <- filteredDescr[-inTrain,]

trainMDRR <- mdrrClass[inTrain]
testMDRR <- mdrrClass[-inTrain]

preProcValues <- preProcess(training, method = c("center", "scale"))

trainTransformed <- predict(preProcValues, training)
testTransformed <- predict(preProcValues, testing)

# 7. Imputation

# 8. Transforming Predictors
library(AppliedPredictiveModeling)
transparentTheme(trans = .4)
plotSubset <- data.frame(scale(mdrrDescr[, c("nC", "X4v")]))
xyplot(nC ~ X4v, 
       data = plotSubset,
       groups = mdrrClass,
       auto.key = list(columns = 2))

# It's neccesary to scale and center predictors before using spatial sign
transformed <- spatialSign(plotSubset)
transformed <- as.data.frame(transformed)
xyplot(nC ~ X4v,
       data = transformed,
       groups = mdrrClass,
       auto.key = list(columns = 2))

# 9. Putting It All Together
# 10. Class Distance Calculations

# Example (Spatial Sign)
variable1 <- c(rnorm(100, 2, 10), rpois(100, 2))
variable2 <- c(rnorm(100, 3, 1.5), rpois(100, 3.5))
data.set <- data.frame(variable1, variable2)

change1 <- data.frame(variable1 = (variable1 - mean(variable1))/sd(variable1),
                      variable2 = (variable2 - mean(variable2))/sd(variable2)
)

par(mfrow = c(1, 2))
plot(change1$variable1, change1$variable2)
plot(variable1, variable2)

change2 <- data.frame(variable1 = change1$variable1/(change1$variable1**2 + change1$variable2**2),
                      variable2 = change1$variable2/(change1$variable1**2 + change1$variable2**2)
)
spatialChange <- spatialSign(change1)
spatialChange <- as.data.frame(spatialChange)

par(mfcol = c(1,4))                      
plot(change1$variable1, change1$variable2)
plot(variable1, variable2)
plot(change2$variable1, change2$variable2)
plot(spatialChange$variable1, spatialChange$variable2)

