# Data Science for Industry // STA5073Z

Welcome! "Data Science for Industry" is a 24-lecture, 12 credit module in the MSc in Data Science program at the University of Cape Town. The goal of the module is to provide an applied, hands-on overview of selected topics useful in the working world of data science that are not covered by other modules in the program. Broadly speaking these topics fall into two themes: **workflow/productivity tools and skills** (GitHub, data wrangling, visualization, communication) and **modelling** (recommender systems, text mining, neural networks).

### Lecture format

DSfI lectures will be held over 6 weeks, with 2 double  (1.5 hour) lectures per week. Lectures take place from 16:00 - 17:45pm on Monday and Wednesday afternoons, in the Cas Troskie room, unless otherwise specified.

The following is an intended lecture schedule but is subject to change! The whole course will be conducted using R.

|Lecture |  General area   |Topics to be covered | R packages | References
|--------|-----|-------------------------|----------|-------------------
|1       | Workflow     | R Projects            |   |
|        |              | Github                |   |
|        |              | R Markdown            |   |
|        | Wrangling    | Data transformations  | dplyr  | R4DS-ch5 
|2        |              | Relational data, join/merge tables | dplyr | R4DS-ch13
|        | Recommender systems | User/item-based recommenders |  |
|        |                     | Matrix factorization |  |
|3        | Data collection |  Scraping data from the web    | rvest  |
|      | Text mining  | Working with text     | stringr | R4DS-ch14 
|4        |  | Analyzing text | tidytext | TMR-ch1, TMR-ch7
|        | | Text generation |  | 
|5    |  | Sentiment analysis                 | tidytext | TMR-ch2
|6     | | Bag-of-words models, tf-idf     | tidytext |TMR-ch4
|    | Data collection | Accessing APIs  | httr, twitteR, streamR  |
|7     | Text mining | Topic modelling | tidytext, topicmodels | TMR-ch6
|8       | Neural networks | Stochastic gradient descent    |     |
|        |                 | Backpropagation                |     |
|        |                 | Introducing *keras*            | keras   |
|9       | Communication | Make your own R package | devtools, roxygen2, knitr, testthat  |
|        |                | Make your own Shiny app             | shiny
|10       |  | Convolutional neural networks | keras    |
|        |               | Computer vision / image classification |   |
|        |               | Setting up Amazon Web Services for GPU computing |   
|11      |  | More convolutional neural networks   | keras

Side note: Visualization in ggplot2 (R4DS-ch3) is not included for 2017 but is highly recommended as self study (I originally intended to include a lecture on this, but it became clear there was already a lot of content in the course).  

R4DS = R for Data Science (2017) Hadley Wickham and Garrett Grolemund (available at http://r4ds.had.co.nz/)

TMR = Text Mining with R (2017) Julia Silge and David Robinson (available at http://tidytextmining.com/)

The list of packages should be fairly complete. The reference/reading list will be updated as we go.

### Software

To get the most out of the course material you should have the following installed:

* Git and GitHub
* RStudio and R (not too old - I'm using v1.0.143 of RStudio and R 3.4.0)
* Jupyter notebook with an R kernel (see [here](https://github.com/IRkernel/IRkernel/blob/master/README.md))

The last of these is not strictly needed but will make it easier to follow in lectures. We'll also need various R packages but you can install these as needed.

### Assessment

There are two assignments and a small number (2-3) of smaller "exercises" to complete during the course. Together these count 50% of your final mark. A final computer exam counts the remaining 50%. All assignments must be completed to complete the course. Late exercises get 0%, late assignments are penalized at 5% per day late. 

|Assessment |  General area   |Handed out | Due date | Counts
|--------|-----|-----|-----|-----
|Assignment 1  | Recommender systems  |  18 Aug | 5 Sep | 20%
|Assignment 2  | Text mining  |  4 Sep | 20 Sep  | 20%
|Small exercises | Various | TBA | TBA | 10%
|Final | Everything | | 26-30 Sep (TBA) | 50%

The final exam will be a computer-based exam in the lab. Part of the exam will be "open book" and part will be closed.

### How to approach the module

For the most part I'll be basing each lecture around an jupyter notebook that covers one of the topics. Sometimes, we'll go through the notebook in class. We won't have time in lectures to go through the notebook in great detail. Mostly I'll be trying to cover the main concepts and give you a good understanding of how things work and fit together, without going into too much detail about each line of code. For some lecture slots, I will pre-record a screencast of me going through the notebook, and then we will spend the actual lecture time in a "workshop" mode - you can use the time to work on exercises, additional problems, ask questions, etc. In 2017, on the basis of a class poll, we had a roughly 50-50 split between the two types of lectures.

Regardless of the lecture type, after the lecture you should go through the notebook at your own pace and absorb all the details, making sure you understand what each bit of code does. Making sure you can reproduce the results on your own i.e. without the notebook, is a good test of understanding. Each notebook will have a few exercises at the end for you to try. To use the notebooks directly you need to install the R kernel for jupyter notebook, see [here](https://github.com/IRkernel/IRkernel/blob/master/README.md). I will also make equivalent .Rmd files available (these just aren't as nice and interactive for class).

The notebooks will generally cover the topics at an introductory-to-intermediate level. I really hope that you will find them interesting enough to want to learn more (maybe not about *every* topic, but more often than not). There is a huge amount of material on the web about all the topics we'll cover. I'll maintain a list of additional readings (the table above already contains some), but you'll benefit a lot from reading widely. If you find something interesting, let everyone know -- perhaps we can discuss it further in class.

I expect that to get the maximum benefit from the class you would probably need to do about 8 hours of self-study outside of lecture times (not counting assignments). Having said that, this is the first time the module is being run, so I really have no idea. Feedback is welcome (if you feel you're spending way too much time on the course, or feel you're learning way too little/much).

### Contact details

Please email me (ian.durbach@uct.ac.za) to set up an appointment. My office is Room 5.53 in the Dept of Statistical Sciences. 

In the interests of getting fast feedback to everyone, we'll also be using [Slack](https://www.slack.com) as a way of communicating during the course. I've set up a group which all participants belong to. Additional options are the chat and forums on [Vula](https://vula.uct.ac.za/portal).

### Sources and references

I have borrowed extensively from other peoples' material to create this course, and its not my intention to pass off work as my own when its not. My two main sources are [R for Data Science](http://r4ds.had.co.nz/) and [Text Mining with R](http://tidytextmining.com/) listed above, and each notebook has further references to source material, but if you find I've missed an attribution please let me know. As this material will be put on the web, the same goes for any material that is incorrectly shared.


