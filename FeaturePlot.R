# Visualizations in caret

# 0. Load libraries
library(AppliedPredictiveModeling)
library(caret)


# 1. featurePlot ----------------------------------------------------------
str(iris)

# 1.1 Scatter plot 
windows()
transparentTheme(trans =.4)
featurePlot(x = iris$Sepal.Length, y = iris$Sepal.Width,
            plot = "scatter",
            labels = c("Sepal.Length", "Sepal.Width"),
            xlim = c(4, 8), ylim = c(2, 5)) 

# 1.2 Pairs plot ("correlation")
windows()
transparentTheme(trans =.4)
featurePlot(x = iris[,1:4], y = iris$Species,
            plot = "pairs",
            auto.key = list(columns = 3))

# 1.3 Scatter plot Matrix with ellipses
windows()
transparentTheme(pchSize = 0.8, trans = 0.5)
featurePlot(x = iris[,1:4], y = iris$Species,
            plot = "ellipse",
            auto.key = list(columns = 3))

# 1.4 Overlayed density plots
windows()
transparentTheme(trans = 0.9)
featurePlot(x = iris[,1:4], iris$Species,
            plot = "density",
            scales = list(
              x = list(relation = "free"),
              y = list(relation = "free")
            ),
            adjust = 1.5,
            pch = "|",
            layput = c(4, 1),
            auto.key = list(columns = 3))

# 1.5 Box Plots
windows()
transparentTheme(trans = 0.9)
featurePlot(x = iris[,1:4], y = iris$Species,
            plot = "box",
            scale = list(
              x = list(relation = "free"),
              y = list(rot = 90)
            ),
            layout = c(4, 1),
            auto.key = list(columns = 2))
            