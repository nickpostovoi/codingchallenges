# 📊 Data Analytics Portfolio

## 💼 Personal Information

- **LinkedIn:** [Nikita Postovoi](https://www.linkedin.com/in/nikita-postovoi-2205b716b/) 🌐
- **Email:** nickpostovoi@gmail.com 📧
- **Phone:** +44-7552-755-820 📞

## 🚀 Introduction

Welcome to my **portfolio**! I am a dedicated data analytics practitioner with a proven track record in leveraging *data-driven insights* to make informed business decisions. With over a year of experience at *Nestle's Market Intelligence department* as a *Market Analyst*, I've honed my skills in database management, reporting, automation and more. My academic journey culminated at *Queen's University Belfast*, where I graduated with first-class honors in *MSc Business Analytics*, solidifying the foundation for my thriving career in data analytics. 

## 🔍 Portfolio Highlights

Explore a selection of my projects showcasing my expertise in:

- **🤖 Machine Learning**
- **📊 Statistical Analysis**
- **📝 Text Mining**
- **🛠️ Operational Research**
- **💾 Database Management**
- **📈 Data Visualization**
- **🔍 Insightful Interpretation**

### 💡 Note:

While it does not include projects from my time at Nestle due to the company policy, it provides a comprehensive overview of my capabilities by showcasing some projects from my academic and personal experience. I invite you to explore these projects and discover how I can contribute to your team's data-driven success.

> "Data is the new oil, and I'm the prospector." - *Nikita Postovoi*

## Project 1: 🚔 Examining Use of Force by the Metropolitan Police Service

- **🎯 Aim:** Inform future policies by analyzing variables related to the use of force by Metropolitan Police Service.
- **🔍 Research Questions:**
  1. Which characteristics explain odds of using different types of force? What are their directions and magnitudes?
  2. Can subject behavior be predicted before an encounter using 'foreknowledge'?
  3. Are there seasonal patterns in non-compliant encounters? Can they be predicted accurately using time-series modelling?
- **🔧 Methods:**
  - Inference-focused multi-level (hierarchical) logistic regression
  - XGBoost and ElasticNet logistic regression multi-class classifiers
  - Deep learning neural networks (Feedforward, Recurrent and Transformer-encoded)
  - MySQL database hosted in cloud
- **📊 Data Sources:**
  - Use-of-force forms data
  - Street crime statistics 
  - Official UK Census 2021
  
🔗 [Link to Report](https://github.com/nickpostovoi/projects/blob/e04b70daaffefcfbbbe23fbb93900fc1a677dc08/Use%20of%20Force%20by%20MPS/Report/uof_report.md) </br>
🔗 [Link to Code Files](https://github.com/nickpostovoi/projects/tree/e04b70daaffefcfbbbe23fbb93900fc1a677dc08/Use%20of%20Force%20by%20MPS/Code) </br>

## Project 2: 📈 Predicting Twitter Engagement using Text Data Mining

- **🎯 Aim:** Employ TDM techniques to analyze tweets and predict the engagement metrics.
- **🔍 Methodology:**
  - Comprehensive data cleaning and preprocessing.
  - Feature engineering with a focus on text-derived features.
  - Sentiment analysis.
  - Utilization of Gradient Boosting Trees and Ridge Regularized Linear Regression models for predictive modeling.
  - Hyperparameter optimization for fine-tuning the models.
- **📊 Results:**
  - The Gradient Boosting model demonstrates superior performance, explaining 47.1% of the variability ($R^2$) in likes count.
  - Noteworthy insights are derived from feature importance analysis, emphasizing factors such as word choice, character usage, and timing of tweet publication.
- **📝 Recommendations:**
  - Tailored recommendations provided to optimize engagement.
  - Strategies include curating tweet content, managing character usage, timing publication strategically, and incorporating specific keywords for enhanced visibility and interaction.

🔗 [Link to Report](https://github.com/nickpostovoi/projects/blob/6c1dea08a790be7bd8712f195d457b1d68e43d07/Text%20Mining%20and%20Twitter/tmt_report.md) </br>
🔗 [Link to Jupyter Notebook](https://github.com/nickpostovoi/projects/blob/6c1dea08a790be7bd8712f195d457b1d68e43d07/Text%20Mining%20and%20Twitter/tmt_code.ipynb) </br>

## Project 3: 🏭 Multiobjective Line Balancing in Manufacturing

- **🎯 Aim:** Optimize assembly line design by balancing tasks across workstations to meet production goals while considering economic, social, and environmental factors.
- **🔍 Description:**
  - The project revolves around optimizing the assembly line design for a manufacturer. This involves sequencing 30 tasks based on a precedence diagram, each with specific processing times and tool requirements. The goal is to ensure that one unit of the product is assembled every 40 seconds (takt time) while adhering to precedence constraints.
  - The project employs a multiobjective approach, considering economic, social, and environmental objectives. The economic objective focuses on minimizing the number of workstations, which translates to lower labor and space costs. The social objective aims to maximize operator workload smoothness, enhancing fairness and reducing ergonomic risks. The environmental objective targets the reduction of cordless power tool usage, thereby minimizing hazardous materials.
- **🔧 Methods:**
  - Global search using Genetic Algorithm (GA)
  - Local search for iterative improvement
  - Incorporation of takt time, precedence constraints, task time, and tool requirements

🔗 [Link to Report](https://github.com/nickpostovoi/projects/blob/311ba6f5080f680485032f341b8d4d78b5b02874/Multi-Objective%20Production-Line%20Balancing/molb_report.md) </br>
🔗 [Link to R Code](https://github.com/nickpostovoi/projects/blob/311ba6f5080f680485032f341b8d4d78b5b02874/Multi-Objective%20Production-Line%20Balancing/molb_code.R) </br>

## Project 4: 🧠 Application of Mixed Integer Linear Programming (MILP) to Problem Solving

- **👩‍⚕️ Task 1: Nurse Planning**
  - **Objective:** Create an optimal nurse schedule for the infusion center to meet patient needs and minimize costs.
  - **Constraints and Costs:** Includes details on nurse types, schedules, and associated costs.
  - **Goals:** Minimize total nursing cost and meet weekly nurse requirements.
  - 🔗 [Link to Solution](https://github.com/nickpostovoi/projects/blob/cb3eb786d218ae6afb7af7a045897621691a5505/Mixed%20Integer%20Linear%20Programming/Nurse%20Planning/np_report.md) </br>
  
- **🚚 Task 2: Chipset Logistics**
  - **Objective:** Optimize the shipment of semiconductor chipsets produced by factories to car manufacturing plants.
  - **Constraints and Costs:** Details on chip production, shipment costs, and reliability measures.
  - **Goals:** Minimize the total shipment cost and meet the demands for both plants.
  - 🔗 [Link to Solution](https://github.com/nickpostovoi/projects/blob/cb3eb786d218ae6afb7af7a045897621691a5505/Mixed%20Integer%20Linear%20Programming/Chipset%20Logistics/cl_report.md) </br>

- **🌐 Task 3: Ocean Internet Cables**
  - **Objective:** Optimize the production schedule of two types of ocean Internet cables to maximize total profit.
  - **Constraints and Costs:** Details on demand, plant availability, production rates, and costs.
  - **Goals:** Devise a production schedule for maximum total profit and determine the total profit under the optimal production schedule.
  - 🔗 [Link to Solution](https://github.com/nickpostovoi/projects/blob/cb3eb786d218ae6afb7af7a045897621691a5505/Mixed%20Integer%20Linear%20Programming/Ocean%20Internet%20Cables/oic_report.md) </br>

## Project 5. 📈 Investment Portfolio Optimization with Rolling Window Simulation

- **🎯 Aim:** Perform a rolling window simulation on a historical stock price data from Yahoo Finance to recalculate the optimal portfolio at each moment of time, assuming the step of recalculation and window prior to optimization.
- **🔧 Methods:**
  - Data retrieval and preprocessing using `yfinance` and `pandas`.
  - Rolling window simulation with optimization using `PyPortfolioOpt`.
  - Visualization of results with `matplotlib`.
- **🔗 [Link to Report](https://github.com/nickpostovoi/projects/blob/b871577c95c437fb1bb0a21368936c63e615deb7/Portfolio%20Optimization%20Simulation/portfolio_optimization_rolwind.md)**

## Project 6: 📑 Predicting Insurance Product Purchases

- **🎯 Aim:** Build a classier utilizing supervised learning algorithms to predict the likelihood of a prospective customer acquiring a life insurance product.
- **🛠️ Methods:**
  - Rigorous data cleaning involved addressing missing values, rectifying typos, and engineered feature creation.
  - Employed Gradient Boosting, Naive Bayes, k-Nearest Neighbours, Random Forest, Decision Tree and Logistic Regression.
  - Hyperparameter optimization via GridSearchCV was executed to fine-tune model performance.
- **📊 Results and Discussion:**
  - Preliminary exploratory analysis unveiled critical insights into variable importance and distribution characteristics.
  - Feature importance scores were computed, unveiling significant predictors for insurance subscription probability.
  - Model evaluation hinged on AUC, accuracy, precision, recall, and F1 scores, with Gradient Boosting exhibiting superior performance across all metrics.
- **🔗 [Link to Jupyter Notebook](https://github.com/nickpostovoi/projects/blob/4af9595fc2b6830a8ca3ab9d95fd5f20b5dd0b35/Insurance%20Purchase%20Prediction/ipp_code.ipynb)**
- **🔗 [Link to Report](https://github.com/nickpostovoi/projects/blob/4af9595fc2b6830a8ca3ab9d95fd5f20b5dd0b35/Insurance%20Purchase%20Prediction/ipp_report.md)**
 
### 💡 Note:
The projects showcased in this portfolio represent a carefully curated selection from my academic endeavors, designed to demonstrate a diverse range of my expertise to a potential employer. Please note that these are just a subset of my work, and I look forward to further expanding this collection with other projects.
