# Data Source

I used the "80 Cereals" data set from Kaggle (https://www.kaggle.com/crawford/80-cereals), which contains nutritional information and a rating for each of 80 different cereals.

Each data point is a particular brand of cereal. The features for each point are the amount of fat, sodium, fiber, complex carbohydrates, simple sugars, and potassium per serving, as well as a percentage rating that the contributors listed as "possibly from consumer report". 

I preprocessed the data by restricting the feature set to quantitative attributes, as well as removing 2 or 3 datapoints with missing feature.

It would certainly be a more interesting set if we knew how the rating was obtained and what it represents, but nevertheless I like the idea of a dataset with a "label" feature against which the user can look for correlations.


# Design Justification


I opted for a a tooltip which displays the name and feature vector for every line beneath the cursor.

In dense graphs with large numbers of datapoints, lines that are earlier in the draw-order may end up buried below other data lines.  If tooltipping only selects the top line, these lines could become very difficult to hover.  Furthermore, with certain data, segments of lines may be drawn entirely on top of other lines, rendering the lower lines invinsible and, with top-line hovering, impossible to tooltip.  While this scenario is unlikely with strictly continuous features, it becomes much more likely if attributes are discretized (e.g. small ranges of years or measurements with poor resolution).  With discretized attributes, many data lines may converge to a single point on an axis.  If two of these discretized attributes are placed next to each other, than there's potential for two or more lines to go directly from the same point on one axis to the same point on another.


# Extra Credit

Did not do extra credit, good heavens I have so much due this week.


# Online

Posted online at: 