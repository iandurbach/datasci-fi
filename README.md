# Data Science for Industry // STA5073Z

Welcome! "Data Science for Industry" is a 24-lecture, 12 credit module in the MSc in Data Science program at the University of Cape Town (see [here](http://www.stats.uct.ac.za/stats/study/postgrad/masters/data-science)) and also offered, as of 2018, as a University of Cape Town accredited short course.

The goal of the module is to provide an applied, hands-on overview of selected topics useful in the working world of data science that are not covered by other modules in the program. Broadly speaking these topics fall into two themes: **workflow/productivity tools and skills** (GitHub, data wrangling, visualization, communication) and **modelling** (recommender systems, text mining, neural networks).

### Lecture format

DSfI lectures will be held over 6 weeks, with 2 double  (1.5 hour) lectures per week. Lectures take place from 16:00 - 17:45pm on Monday and Wednesday afternoons. Students from the Data Science MSc program attend the same classes as those participating in the short course.

For the most part I'll be basing each lecture around a notebook that covers one of the topics below. Sometimes, we'll go through the notebook in class. We won't have time in lectures to go through the notebook in great detail. Mostly I'll be trying to cover the main concepts and give you a good understanding of how things work and fit together, without going into too much detail about each line of code. For some lecture slots, I will pre-record a screencast of me going through the notebook, and then we will spend the actual lecture time in a "workshop" mode - you can use the time to work on exercises, additional problems, ask questions, etc. In 2017, on the basis of a class poll, we had a roughly 50-50 split between the two types of lectures.

Regardless of the lecture type, after the lecture you should go through the notebook at your own pace and absorb all the details, making sure you understand what each bit of code does. Making sure you can reproduce the results on your own i.e. without the notebook, is a good test of understanding. Each notebook will have a few exercises at the end for you to try.

The notebooks will generally cover the topics at an introductory-to-intermediate level. I really hope that you will find them interesting enough to want to learn more (maybe not about *every* topic, but more often than not). There is a huge amount of material on the web about all the topics we'll cover. I'll maintain a list of additional readings (the table above already contains some), but you'll benefit a lot from reading widely. If you find something interesting, let everyone know -- perhaps we can discuss it further in class.

I expect that to get the maximum benefit from the class you would probably need to do about 8 hours of self-study outside of lecture times (not counting assignments). Feedback is welcome (if you feel you're spending way too much time on the course, or feel you're learning way too little/much).

The following is the intended lecture schedule for 2018. The whole course will be conducted using R.

|Lecture |  General area   |Topics to be covered | R packages | References
|--------|-----|-------------------------|----------|-------------------
|1        | Wrangling    | Data transformations  | dplyr  | R4DS-ch5 
|        |              | Relational data, join/merge tables | dplyr | R4DS-ch13
|2       | Workflow     | R Projects            |   |
|        |              | Github                |   |
|        |              | R Markdown            |   |
|3        | Recommender systems | User/item-based recommenders |  |
|        |                     | Matrix factorization |  |
|4       | Neural networks | Stochastic gradient descent    |     |
|        |                 | Backpropagation                |     |
|        |                 | Introducing *keras*            | keras   |
|        | Workflow           | Setting up Amazon Web Services | 
|5       | Communication | Make your own R package | devtools, roxygen2, knitr, testthat  |
|6       | Neural networks | Convolutional neural networks | keras    |
|        |               | Computer vision / image classification |   |
|7        | Communication | Make your own Shiny app             | shiny
|8        | Data collection |  Scraping data from the web    | rvest  |
|      | Text mining  | Working with text     | stringr | R4DS-ch14 
|9        |  | Analyzing text | tidytext | TMR-ch1, TMR-ch7
|        | | Text generation |  | 
|10    |  | Sentiment analysis                 | tidytext | TMR-ch2
|     | | Bag-of-words models, tf-idf     | tidytext |TMR-ch4
|11     | Text mining | Topic modelling | tidytext, topicmodels | TMR-ch6
|12    | Data collection | Accessing APIs  | httr, twitteR, streamR  |


Side note: Visualization in ggplot2 (R4DS-ch3) is not included but is highly recommended as self study (I originally intended to include a lecture on this, but it became clear there was already a lot of content in the course).  

R4DS = R for Data Science (2017) Hadley Wickham and Garrett Grolemund (available at http://r4ds.had.co.nz/)

TMR = Text Mining with R (2017) Julia Silge and David Robinson (available at http://tidytextmining.com/)

The list of packages should be fairly complete. The reference/reading list will be updated as we go.

### Software

To get the most out of the course material you should have the following installed:

* Git and GitHub
* RStudio and R (not too old - I'm using v1.1.383 of RStudio and R 3.4.2, as of 8/6/2018)

The last of these is not strictly needed but will make it easier to follow in lectures. We'll also need various R packages but you can install these as needed.

### Assessment

There are two assignments to complete during the course. Together these count 50% of your final mark. A final computer exam counts the remaining 50%. All assignments must be completed to complete the course. Late assignments are penalized at 5% per day late. 

|Assessment |  General area   |Handed out | Due date | Counts
|--------|-----|-----|-----|-----
|Assignment 1  | Recommender systems  |  Week 3 | Week 6 | 25%
|Assignment 2  | Neural networks  |  Week 7 | Week 11 | 25%
|Final | Everything | | TBA | 50%

The final exam will be a computer-based exam in the lab. Part of the exam will be "open book" and part will be closed.

### Contact details

Please email me (ian.durbach@uct.ac.za) to set up an appointment. My office is Room 5.53 in the Dept of Statistical Sciences. 

Course communication will be done using [Vula](https://vula.uct.ac.za/portal).

### Sources and references

I have borrowed extensively from other peoples' material to create this course, and its not my intention to pass off work as my own when its not. My two main sources are [R for Data Science](http://r4ds.had.co.nz/) and [Text Mining with R](http://tidytextmining.com/) listed above, and each notebook has further references to source material, but if you find I've missed an attribution please let me know. As this material will be put on the web, the same goes for any material that is incorrectly shared.
