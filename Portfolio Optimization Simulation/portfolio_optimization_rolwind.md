**Task at hand:**</br>

Perform a rolling window simulation on a historical stock price data from Yahoo Finance to recalculate the optimal portfolio at the moment of time, assuming the step of recalculation and window prior to optimization (in trading days).

Notes:</br>
1. The approach described here assumes the conservative type of investor which aims to minimize volatility.</br>
2. The approach does not account for the fees taken by a broker to reallocate investments in each iteration.

```python
# install necessary libs
!pip install yfinance
!pip install PyPortfolioOpt
# load necessary libs
import yfinance as yf
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from pypfopt.efficient_frontier import EfficientFrontier
```

Parse the stock price data from the Yahoo Finance API

```python
assets = ['AAPL','MSFT','AMZN','GOOGL','TSLA','NVDA','META','JPM','UNH',
          'JNJ','PG','V','HD','BAC','XOM']
df = pd.DataFrame()
for i in assets:
 df[i] = yf.download(i,'2015-01-01',end='2022-02-01')['Close']
```
Calculate the percent change in stock price for each trading day
```python
returns = df.pct_change()
# add first row filled with ones
returns_with_p = returns.copy()
returns_with_p['portfolio'] = np.zeros(shape=len(returns))
returns_with_p.iloc[0] = np.ones(shape=len(assets)+1)
```

Perform the rolling window simulation

```python
# assume the reoptimization step of 30 days
step = 30
window = 125

# initialize the weights_rolling dataFrame, used to store multiple sets of optimized weights
weights_rolling = pd.DataFrame()

# set counters for steps (i), index to store weights (ind) and index to update portfolio returns (ind_w)
ind = 1
ind_w = window

# loop through the days of the portfolio, setting window sized steps
while i < len(returns):
    # calculate the average returns for the current window, to be used in the optimization process
    expected_return = returns.iloc[i:i+window,:].mean()

    # calculate the covariance of the returns for the current window, to be used in the optimization process
    covariance = returns.iloc[i:i+window,:].cov()
    
    # initialize the Efficient Frontier optimization with the calculated expected returns and covariances
    ef = EfficientFrontier(expected_return, covariance)
    
    # run the minimum volatility portfolio optimization
    ef.min_volatility()
    
    # reformat the optimization weights into a matrix
    efweights = np.mat(ef.weights)
    
    # store the weights in the weights_rolling dataFrame
    weights_rolling[ind] = pd.DataFrame.from_dict(ef.clean_weights(),orient='index')
    
    # compute the portfolio return for the next step days and store the result in the 'portfolio' column of the returns_with_p DataFrame
    returns_with_p.iloc[ind_w:(ind_w+step),len(assets)] = np.dot(returns_with_p.iloc[ind_w:(ind_w+step),0:len(assets)],efweights.T)
    
    # move forward in time by step
    i += step
    ind += 1
    ind_w += step
```

Plot a stacked bar chart for visualizing proportion of each stock in portfolio across iterations

```python
# initialize a plot
fig, ax = plt.subplots(figsize=(16, 6), dpi=200)
# transpose the DataFrame for appropriate orientation
cweights = weights_rolling.T 
# 
cweights.plot(
    kind = 'bar', 
    stacked = True, 
    title = 'Portfolio Weights Across Iterations (Conservative)',
    mark_right = True, 
    ax=ax
)
# set the x and y labels of the plot
plt.xlabel('Iterations')
plt.ylabel('Weights')
# set the legend location
plt.legend(loc="lower left", bbox_to_anchor=(1, -0.05))
# adjust layout for better visual appeal
plt.tight_layout()
# save the plot in high resolution png image
plt.savefig('Portfolio Weights Across Iterations (Conservative).png', dpi=500)
```
![Alt text](<assets/Portfolio Weights Across Iterations (Conservative).png>)

Create a pie chart to display the average weights of stocks in a portfolio across iterations

```python
threshold_pie = 6
# drop all assets in the weights dataframe where the sum of their weights is less than a specified threshold percentage
avg_weights = cweights.sum()
others = avg_weights.loc[(avg_weights<((avg_weights.sum()/100)*threshold_pie))]
avg_weights = avg_weights.loc[~(avg_weights<((avg_weights.sum()/100)*threshold_pie))]

# combine all dropped weights into a new category named 'Others'
avg_weights['Others'] = others.sum()

# create a pie chart of the average weights of portfolio assets
fig, ax = plt.subplots(figsize=(6, 6), dpi=100)
x = avg_weights.values
labels = avg_weights.index.values

# create the pie chart using the weights as x-values and the labels for the asset names
# autopct is used to format the value in each pie slice to 1 decimal place
patches, texts, pcts = ax.pie(
    x, labels=labels, autopct='%.1f%%',
    wedgeprops={'linewidth': 3.0, 'edgecolor': 'white'},
    textprops={'size': 'x-large'})
plt.setp(pcts, color='white', fontweight='bold')
ax.set_title('Average Portfolio Weights (Conservative)', fontsize=18)
plt.tight_layout()
plt.savefig('Average Portfolio Weights (Conservative).png', dpi=500)
```
![Alt text](<assets/Average Portfolio Weights (Conservative).png>)

Plot the yield curve representing the cumulative return over time
```python
# calculate the yield curve as a cumulative sum of portfolio returns
returns_with_p['yield curve'] = returns_with_p['portfolio'].cumsum()
returns_with_p = returns_with_p.copy().iloc[window-1: , :]

# plot the yield curve
plt.figure(figsize=(12, 6), dpi=150)
returns_with_p['yield curve'].plot(label = 'Overall return = {}'.format(np.round(float(returns_with_p['yield curve'].tail(1)),2)))
plt.title('Yield Curve (Conservative)')
plt.xlabel('Date')
plt.ylabel('Cumulative return')
plt.legend()
plt.savefig('Yield Curve (Conservative).png', dpi=500)
```
![Alt text](<assets/Yield Curve (Conservative).png>)
Calculate the relevant performance indicators to assess the optimization effectiveness

```python
# assume the market risk free rate of 5%
risk_free_rate = 0.05

# the portfolio variance is calculated by taking the variance of the portfolio
# returns and scaling it by the total trading days in a year (252)
p_variance = np.var(returns_with_p['portfolio']) * 252

# the portfolio volatility, also known as the standard deviation, is calculated by
# taking the square root of the portfolio variance
p_volatility = np.sqrt(p_variance)

# the average annual return is calculated by taking the mean of the
# portfolio returns and scaling it by the total trading days in a year (252)
p_return = np.mean(returns_with_p['portfolio']) * 252

# the Sharpe ratio is calculated by subtracting the risk-free rate
# from the portfolio return and dividing it by the portfolio volatility
# this gives us a measure of the risk-adjusted return of our portfolio
p_sharpe = (p_return - risk_free_rate) / p_volatility 

# converting the values to percentage format for better readability
percent_vol = str(round((p_volatility * 100), 2)) + '%'
percent_return = str(round((p_return * 100), 2)) + '%'
sharpe_ratio = str(round(p_sharpe, 2))

print('Average annual return: ' + percent_return)
print('Annual volatility: ' + percent_vol)
print('Sharpe ratio: ' + sharpe_ratio)
```
```
[Output]:
Average annual return: 15.28%
Annual volatility: 16.8%
Sharpe ratio: 0.61
```

Plot the drawdown overtime (the difference between the 'yield curve' and its cumulative maximum which represents the loss investor would suffer at a specific point of time)

```python
returns_with_p['drawdown'] = returns_with_p['yield curve'] - returns_with_p["yield curve"].cummax()
returns_with_p['drawdown_percent'] = (returns_with_p['yield curve']/returns_with_p["yield curve"].cummax())-1

plt.figure(figsize=(12, 6), dpi=200)
returns_with_p['drawdown_percent'].plot(color='red', label='Max Drawdown = {}%'.format(np.round(returns_with_p['drawdown_percent'].min(), 3) * 100))
plt.title('Drawdown Graph (Conservative)')
plt.xlabel('Date')
plt.ylabel('Drawdown')
plt.legend()
plt.savefig('Drawdown graph (Conservative).png', dpi=500)
```
![Alt text](<assets/Drawdown graph (Conservative).png>)

Compute the longest balance recovery period

```python
# initializing a counter variable to count the number of consecutive days in drawdown
count = 0
# initializing the variable that will store the longest streak of days in drawdown found so far
prev = 0
# initializing the variable that will store the index of the end of the longest streak of days in drawdown
indexend = 0 
# looping over each day in the portfolio
for i in range(0,len(returns_with_p['drawdown'])):
    # if there is a drawdown on this day
    if returns_with_p['drawdown'][i] < 0:
        # increment the counter
        count += 1
    else: 
        # if there is no drawdown on this day, this means the previous streak has ended         
        # if the length of this streak is greater than the longest found so far
        if count > prev:
            # update longest streak of drawdown days and the end index  
            prev = count
            indexend = i
        # reset the count for tracking new drawdown streak.
        count = 0
# printing the longest recovery period in trading days
print("The longest recovery period is "+str(prev)+" trading days ")
```
```
[Output]:
The longest recovery period is 164 trading days 
```