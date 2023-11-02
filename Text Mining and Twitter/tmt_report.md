## Introduction

<p>This report aims to use machine learning regression models on the dataset consisting of Donald Trump’s tweets to uncover the patterns and insights about the likes of a tweet, and to provide a guidance on how the owner of the channel could potentially increase the average amount of likes the future posts will get. To accomplish these goals, first the data cleaning and pre-processing is performed to prepare the dataset for analysis. Following that, feature engineering is being done to account for maximum possible critical parameters that drive tweet engagement. Finally, machine learning algorithms capable of predicting the amount of likes is created and their performance is evaluated. The insights gathered from these algorithms are used to derive recommendations that the channel owner (Donald Trump) may adopt to boost the overall engagement of their Twitter account.</p>

## Methodology

<p> Misleading conclusions can be derived from faulty or inconsistent data, and the quality of the results is highly determined by how well the data has been cleaned and comprehended. As a result, it is critical to validate the data before performing analytics and drawing conclusions, which is especially truthful in case of working. The following table outlines the actions that were performed as a part of a data cleaning and pre-processing.</p>

Table 1. Actions performed during data cleaning and pre-processing

| Action                                       | Method                                                                                                  |
|----------------------------------------------|---------------------------------------------------------------------------------------------------------|
| Retweets are removed from the tweet texts    | since they don’t have likes                                                                            |
| Removing observations where text begins       | with ‘RT’                                                                                               |
| URLs are removed from the tweet texts         | since their text do not convey meaning                                                                   |
| Removing text that begins with http and      | ends with a space                                                                                       |
| User tags and hashtags are removed from      | the tweet text                                                                                          |
| Removing text that begins with @ or # and     | ends with a space                                                                                       |
| Occurrences of '&amp' removed the from       | the tweet texts                                                                                         |
| Removing text that contains '&amp'           |                                                                                                         |
| Dataset is filtered by the timestamp         | Only tweets for 2020 are kept for the analysis                                                          |
| Outliers are filtered out from the dataset   | Top 1% most liked tweets are removed from the analysis                                                  |
| Text of tweets is cleaned                    | Removing symbols (keeping only letters and spaces), tokenizing the text, converting tokens to lowercase, removing the stop words |
| Tokens for top 50 most useful words are      | generated                                                                                               |
| Running random forest model using only       | word tokens, extracting feature importance and concatenating tokens for top 50 words to the remaining data. Only 50 words were kept since including more wasn’t yielding any increase in predictive performance, and only led to increase in dimensionality of the data. |

The following table describes features that were created using the raw data. To investigate the distribution of the generated features, the visualizations were plotted.

Table 2. Feature engineering results table

| Feature                   | Description                                                           | Type                |
|---------------------------|-----------------------------------------------------------------------|---------------------|
| minutes_since_last_tweet   | The time in minutes passed from publishing the previous tweet         | Continuous, integer |
| is_special_event           | Indicates whether the tweet has been posted on a special event day    | Binary, integer     |
| link                      | Indicates whether tweet contains a link                               | Binary, integer     |
| char_count                | Number of characters used                                             | Continuous, integer |
| word_count                | Number of words used                                                  | Continuous, integer |
| emoji_count               | Number of emojis used                                                 | Continuous, integer |
| exclamation_marks_count   | Number of exclamation marks used                                      | Continuous, integer |
| question_marks_count      | Number of question marks used                                         | Continuous, integer |
| uppercase_proportion      | Proportion of uppercase characters to all characters                   | Continuous, float   |
| time_of_day               | Categorizes the time of the day into 4 categories: 1 – morning (6am to 12am), 2 – day (1pm to 6pm), 3 – evening (6pm to 12pm), 4 – night (1am to 6am)  | Discrete, integer |
| hour_of_day               | Indicates the hour when tweet was posted (1-24)                        | Discrete, integer |
| day_of_week               | Indicates the day of week when tweet was posted (1-7)                  | Discrete, integer |
| week                      | Indicates the week when tweet was posted (1-53)                       | Discrete, integer |
| month                     | Indicates the month when tweet was posted (1-12)                      | Discrete, integer |
| is_weekend                | Indicates whether the post was posted on a weekend                    | Binary, integer     |
| tag_count                 | Indicates a number of user tags in a tweet                             | Continuous, integer |
| hashtag_count             | Indicates a number of hashtags in a tweet                              | Continuous, integer |
| sentiment                 | Indicates sentiment score (1 – positive, 0 – neutral, -1 – negative)    | Discrete, integer |

<p>After performing the mentioned actions with the data, the next step is to build regression machine learning models to predict the amount of likes that the post is expected to receive. Two approaches used are: Gradient Boosting Regressor and Ridge Regularized Linear Regression. Gradient Boosting model was used since in most settings it usually yields the best predictive power among other algorithms. Moreover, it is possible to extract feature importance from the tree models, which is useful for the current set of goals. Regularized Linear Regression approach was chosen keeping in mind that its performance would likely be worse than with other models, however it provides the possibility to perform statistical inference that can be performed by interpreting model coefficients to evaluate the magnitude and direction of a variable influence.</p>
<p>To evaluate the regression model performance the 10-fold cross validation was used to reduce the bias in estimating the performance metrics. GridSearchCV approach within ‘sklearn’ library was used to perform hyperparameter optimization for these models. For Gradient Boosting model, the learning rate, number of trees, the function to measure the quality of a split, maximum depth of each decision tree, and the number of features to consider during each split were optimized. For the regularized regression, the alpha parameter was optimized using the above-mentioned Grid Search with optimal value is decided to be 8.2.</p>

## Results and Discussion

<p>Across all assessment measures, the Ridge Regression model performs the worst. The Gradient Boosting model gets the greatest determination coeffect (R^2) value, suggesting that it is most successful at predicting the likes count, explaining 47.1% variability, which is a good result considering that it is a human behaviour related problem, and likes count is likely to have more factors influencing it that are not accommodated in the model.</p>
<p>The direction of each predictor variable's influence on the dependent variable in the Ridge Regression model is as follows: presence of a link in a tweet text and number of characters used have a negative effect, indicating that as they increase, the like count drops. At the same time, number of words in a tweet, proportion of uppercase characters, whether the tweet was flagged or not, the time of the day, the number of minutes passed since the last tweet, and presence of a word ‘parade’ in a tweet, on the other hand, have a positive effect, which means that when they grow, so does the like count of a tweet.</p>
<p>The gradient boosting model's feature importance indicate the relative importance of several elements in forecasting a tweet's like count. The inclusion of a link in a tweet is the most significant variable, accounting for about 25.40% of the predictive power of the model. With a feature value of 18.74%, the proportion of capital characters in a tweet is the second most significant variable in the gradient boosting model. This suggests that the percentage of capital letters in a tweet has a considerable impact on the like count. Surprisingly, the month of a tweet's posting is the third most important element, accounting for 10.57% of the forecast. Character count, while inversely linked with like count in the Ridge Regression model, has a significance of 6.93% in the gradient boosting model. The time since the last tweet is also important, accounting for 6.19% of the model's predictive ability. Other factors, like as the amount of tags, whether or not the tweet is tagged, and the time of day, have minor but notable effects, ranging from 4.20% to 2.27%. Word count, the existence of the words'election' and 'ballot,' and the day of the week are less important, each contributing less than 2% to the forecast. Overall, the impact of these features sheds light on the intricate interplay of elements that determine a tweet's like count.

## Recommendations

According to the unveiled insights, the account owner should do the following to increase the future tweet’s engagement:
- limit the usage of links in their tweets, since the use of them has been found to reduce the number of likes, while accounting for around a fourth of best model predicting power. Instead, directly sharing facts and ideas in the tweet text may result in more interaction.
- since there is a positive association of word count and negative association of a character count with number of likes, it is important to use shorter words to communicate the ideas effectively. This would allow to boost the word count without raising the number of characters, perhaps resulting to higher engagement and like count.
- be mindful of the proportion of capital letters in the tweets, since an increase in uppercase characters is positively related with the like count. Nevertheless, it is critical to establish a balance when employing capital letters to highlight certain words or phrases, since excessive use may be seen as spammy by the audience.
- adjust the timing of tweet publication strategically. The time passed since last tweet and time of the day when tweet is published both are significant influencers on engagement, therefore it would be beneficial to experiment to determine the best timing for the audience. 
- it is important to be mindful about the tweet contents because words like ‘parade’, ‘election’, ‘enemy’, ‘vaccine’, ‘votes’ are influencing the like count of tweets according to the conducted analysis. To boost visibility and engagement, include the relevant keywords and tailor your materials to the interests of the audience.


