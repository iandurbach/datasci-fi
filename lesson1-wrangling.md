Data wrangling
================

In this lesson we'll:

1.  see how to save .csv data in the form of an .RData object
2.  introduce data transformations using the **dplyr** package, using the five key dplyr verbs:

-   filter
-   arrange
-   mutate
-   summarise
-   group\_by

1.  introduce the pipe operator `%>%`
2.  see a few nice things you can do by combining dplyr verbs (grouped filters and mutates, for example)
3.  use the dplyr verbs to build a small movie rating dataset that we'll use in the next lesson on recommender systems.
4.  introduce various *join* operations that can be used to combine information across multiple tables (relational data)

### Sources and references

-   <http://r4ds.had.co.nz/transform.html>
-   <http://r4ds.had.co.nz/relational-data.html>

Get the MovieLens data and save as .RData
-----------------------------------------

[MovieLens](https://grouplens.org/datasets/movielens/) is a great resource for data on movie ratings. The full dataset has ratings on 40 000 movies by 260 000 users, some 24 million ratings in all. We'll use a smaller dataset with ratings of 9 000 movies by 700 users (100 000 ratings in all).

Download the file "ml-latest-small.zip" from <https://grouplens.org/datasets/movielens/> and unzip it to the *data* directory in your main project folder (make a folder called *data* if you haven't already). You should see four csv files: `links.csv`, `movies.csv`, `ratings.csv`, and `tags.csv`. You can also do this programmatically in R:

``` r
dir.create("data")
```

    ## Warning in dir.create("data"): 'data' already exists

``` r
download.file(
  url = "http://files.grouplens.org/datasets/movielens/ml-latest-small.zip", 
  destfile = "data/ml-latest-small.zip"
)
unzip("data/ml-latest-small.zip", exdir = "data")
```

First let's save the data we downloaded as an .RData object. .RData objects are smaller than csv, plus we can save all four csvs in a single .RData object that we can call with a single call to `load` the dataset later on.

``` r
# read in the csv files
movies <- read.csv("data/ml-latest-small/movies.csv")  # movie info: title and genre
ratings <- read.csv("data/ml-latest-small/ratings.csv") # user ratings for each movie
tags <- read.csv("data/ml-latest-small/tags.csv") # additional user reviews ("tag")
links <- read.csv("data/ml-latest-small/links.csv") # lookup for imdb movie IDs

# save as .RData
save(links, movies, ratings, tags, file = "data/movielens-small.RData")

# check that it's worked
rm(list = ls())
load("data/movielens-small.RData")
```

You'll only need to do the above part once, so once you've got the data saved as .RData, start running the notebook from here.

Loading the tidyverse
---------------------

Load the **tidyverse** collection of packages, which loads the following packages: **ggplot2**, **tibble**, **tidyr**, **readr**, **purrr**, and **dplyr**.

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.5
    ## ✔ tidyr   0.7.2     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.2.0

    ## Warning: package 'tibble' was built under R version 3.4.3

    ## Warning: package 'purrr' was built under R version 3.4.4

    ## Warning: package 'dplyr' was built under R version 3.4.4

    ## Warning: package 'stringr' was built under R version 3.4.4

    ## ── Conflicts ───────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

Load the MovieLens data

``` r
load("data/movielens-small.RData")
```

Tibbles are a special kind of dataframe that work well with tidyverse packages ("in the tidyverse").

``` r
# convert ratings to a "tibble"
ratings <- as.tibble(ratings)
```

A nice feature of tibbles is that if you display them in the console (by typing `ratings`, for example) only the first few rows and columns are shown.

``` r
ratings
```

    ## # A tibble: 100,004 x 4
    ##    userId movieId rating  timestamp
    ##     <int>   <int>  <dbl>      <int>
    ##  1      1      31    2.5 1260759144
    ##  2      1    1029    3   1260759179
    ##  3      1    1061    3   1260759182
    ##  4      1    1129    2   1260759185
    ##  5      1    1172    4   1260759205
    ##  6      1    1263    2   1260759151
    ##  7      1    1287    2   1260759187
    ##  8      1    1293    2   1260759148
    ##  9      1    1339    3.5 1260759125
    ## 10      1    1343    2   1260759131
    ## # ... with 99,994 more rows

Explore some of the variables:

``` r
str(ratings)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    100004 obs. of  4 variables:
    ##  $ userId   : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ movieId  : int  31 1029 1061 1129 1172 1263 1287 1293 1339 1343 ...
    ##  $ rating   : num  2.5 3 3 2 4 2 2 2 3.5 2 ...
    ##  $ timestamp: int  1260759144 1260759179 1260759182 1260759185 1260759205 1260759151 1260759187 1260759148 1260759125 1260759131 ...

``` r
glimpse(ratings)
```

    ## Observations: 100,004
    ## Variables: 4
    ## $ userId    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
    ## $ movieId   <int> 31, 1029, 1061, 1129, 1172, 1263, 1287, 1293, 1339, ...
    ## $ rating    <dbl> 2.5, 3.0, 3.0, 2.0, 4.0, 2.0, 2.0, 2.0, 3.5, 2.0, 2....
    ## $ timestamp <int> 1260759144, 1260759179, 1260759182, 1260759185, 1260...

``` r
glimpse(movies)
```

    ## Observations: 9,125
    ## Variables: 3
    ## $ movieId <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,...
    ## $ title   <fct> Toy Story (1995), Jumanji (1995), Grumpier Old Men (19...
    ## $ genres  <fct> Adventure|Animation|Children|Comedy|Fantasy, Adventure...

We'll look at database joins in more detail, but for now, this just adds movie title to the `ratings` data by pulling that information from `movies`.

``` r
ratings <- left_join(ratings, movies)
```

    ## Joining, by = "movieId"

Filtering rows with `filter()`
------------------------------

Here we illustrate the use of `filter()` by extracting user 1's observations from the *ratings* data frame.

``` r
u1 <- filter(ratings, userId == 1)
```

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

``` r
u1
```

    ## # A tibble: 20 x 6
    ##    userId movieId rating  timestamp title               genres            
    ##     <int>   <int>  <dbl>      <int> <fct>               <fct>             
    ##  1      1      31    2.5 1260759144 Dangerous Minds (1… Drama             
    ##  2      1    1029    3   1260759179 Dumbo (1941)        Animation|Childre…
    ##  3      1    1061    3   1260759182 Sleepers (1996)     Thriller          
    ##  4      1    1129    2   1260759185 Escape from New Yo… Action|Adventure|…
    ##  5      1    1172    4   1260759205 Cinema Paradiso (N… Drama             
    ##  6      1    1263    2   1260759151 Deer Hunter, The (… Drama|War         
    ##  7      1    1287    2   1260759187 Ben-Hur (1959)      Action|Adventure|…
    ##  8      1    1293    2   1260759148 Gandhi (1982)       Drama             
    ##  9      1    1339    3.5 1260759125 Dracula (Bram Stok… Fantasy|Horror|Ro…
    ## 10      1    1343    2   1260759131 Cape Fear (1991)    Thriller          
    ## 11      1    1371    2.5 1260759135 Star Trek: The Mot… Adventure|Sci-Fi  
    ## 12      1    1405    1   1260759203 Beavis and Butt-He… Adventure|Animati…
    ## 13      1    1953    4   1260759191 French Connection,… Action|Crime|Thri…
    ## 14      1    2105    4   1260759139 Tron (1982)         Action|Adventure|…
    ## 15      1    2150    3   1260759194 Gods Must Be Crazy… Adventure|Comedy  
    ## 16      1    2193    2   1260759198 Willow (1988)       Action|Adventure|…
    ## 17      1    2294    2   1260759108 Antz (1998)         Adventure|Animati…
    ## 18      1    2455    2.5 1260759113 Fly, The (1986)     Drama|Horror|Sci-…
    ## 19      1    2968    1   1260759200 Time Bandits (1981) Adventure|Comedy|…
    ## 20      1    3671    3   1260759117 Blazing Saddles (1… Comedy|Western

Next we extract the observations for user 1 that received a rating greater than 3. Multiple filter conditions are created with `&` (and) and `|` (or).

``` r
filter(ratings, userId == 1 & rating > 3)
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…
    ## 3      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105    4   1260759139 Tron (1982)            Action|Adventur…

Here's another way of writing the same condition as above:

``` r
filter(ratings, userId == 1, rating > 3)
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…
    ## 3      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105    4   1260759139 Tron (1982)            Action|Adventur…

The `%in%` command is often useful when using dplyr verbs:

``` r
filter(ratings, userId == 1, rating %in% c(1,4))
```

    ## # A tibble: 5 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172      4 1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1405      1 1260759203 Beavis and Butt-Head … Adventure|Anima…
    ## 3      1    1953      4 1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105      4 1260759139 Tron (1982)            Action|Adventur…
    ## 5      1    2968      1 1260759200 Time Bandits (1981)    Adventure|Comed…

Introducing the pipe
--------------------

The pipe operator `%>%` is a very useful way of chaining together multiple operations. A typical format is something like:

*data* `%>%` *operation 1* `%>%` *operation 2*

You read the code from left to right: Start with *data*, apply some operation (operation 1) to it, get a result, and then apply another operation (operation 2) to that result, to generate another result (the final result, in this example). A useful way to think of the pipe is as similar to "then".

The main goal of the pipe is to make code easier, by focusing on the transformations rather than on what is being transformed. Usually this is the case, but it's also possible to get carried away and end up with a huge whack of piped statements. Deciding when to break a block up is an art best learned by experience.

``` r
# filtering with the pipe
ratings %>% filter(userId == 1)
```

    ## # A tibble: 20 x 6
    ##    userId movieId rating  timestamp title               genres            
    ##     <int>   <int>  <dbl>      <int> <fct>               <fct>             
    ##  1      1      31    2.5 1260759144 Dangerous Minds (1… Drama             
    ##  2      1    1029    3   1260759179 Dumbo (1941)        Animation|Childre…
    ##  3      1    1061    3   1260759182 Sleepers (1996)     Thriller          
    ##  4      1    1129    2   1260759185 Escape from New Yo… Action|Adventure|…
    ##  5      1    1172    4   1260759205 Cinema Paradiso (N… Drama             
    ##  6      1    1263    2   1260759151 Deer Hunter, The (… Drama|War         
    ##  7      1    1287    2   1260759187 Ben-Hur (1959)      Action|Adventure|…
    ##  8      1    1293    2   1260759148 Gandhi (1982)       Drama             
    ##  9      1    1339    3.5 1260759125 Dracula (Bram Stok… Fantasy|Horror|Ro…
    ## 10      1    1343    2   1260759131 Cape Fear (1991)    Thriller          
    ## 11      1    1371    2.5 1260759135 Star Trek: The Mot… Adventure|Sci-Fi  
    ## 12      1    1405    1   1260759203 Beavis and Butt-He… Adventure|Animati…
    ## 13      1    1953    4   1260759191 French Connection,… Action|Crime|Thri…
    ## 14      1    2105    4   1260759139 Tron (1982)         Action|Adventure|…
    ## 15      1    2150    3   1260759194 Gods Must Be Crazy… Adventure|Comedy  
    ## 16      1    2193    2   1260759198 Willow (1988)       Action|Adventure|…
    ## 17      1    2294    2   1260759108 Antz (1998)         Adventure|Animati…
    ## 18      1    2455    2.5 1260759113 Fly, The (1986)     Drama|Horror|Sci-…
    ## 19      1    2968    1   1260759200 Time Bandits (1981) Adventure|Comedy|…
    ## 20      1    3671    3   1260759117 Blazing Saddles (1… Comedy|Western

The main usefulness of the pipe is when combining multiple operations:

``` r
# first filter on userId then on rating
u1_likes <- ratings %>% filter(userId == 1) %>% filter(rating > 3)
u1_likes
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…
    ## 3      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105    4   1260759139 Tron (1982)            Action|Adventur…

``` r
# another way of doing the same thing
ratings %>% filter(userId == 1 & rating > 3)
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…
    ## 3      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105    4   1260759139 Tron (1982)            Action|Adventur…

Arranging rows with `arrange()`
-------------------------------

Ordering user 1's "liked" movies in descending order of rating (note the use of `desc`):

``` r
arrange(u1_likes, desc(rating))
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 3      1    2105    4   1260759139 Tron (1982)            Action|Adventur…
    ## 4      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…

Subsequent arguments to `arrange()` can be used to arrange by multiple columns. Here we first order user 1's liked movies by rating (in descending order) and then by timestamp (in ascending order)

``` r
arrange(u1_likes, desc(rating), timestamp)
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    2105    4   1260759139 Tron (1982)            Action|Adventur…
    ## 2      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 3      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 4      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…

We can also use the pipe to do the same thing:

``` r
u1_likes %>% arrange(desc(rating))
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 3      1    2105    4   1260759139 Tron (1982)            Action|Adventur…
    ## 4      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…

Finally, here's an example of combining filter and arrange operations with the pipe:

``` r
ratings %>% filter(userId == 1 & rating > 3) %>% arrange(desc(rating))
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 3      1    2105    4   1260759139 Tron (1982)            Action|Adventur…
    ## 4      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…

Selecting columns with `select()`
---------------------------------

Select is a bit like `filter()` for columns. The syntax is straightforward, the first argument gives the dataframe, and then you list the variables you want to select!

``` r
select(u1_likes, title, rating)
```

    ## # A tibble: 4 x 2
    ##   title                                          rating
    ##   <fct>                                           <dbl>
    ## 1 Cinema Paradiso (Nuovo cinema Paradiso) (1989)    4  
    ## 2 Dracula (Bram Stoker's Dracula) (1992)            3.5
    ## 3 French Connection, The (1971)                     4  
    ## 4 Tron (1982)                                       4

To exclude variables just put a minus sign in front of them:

``` r
select(u1_likes, -userId, -timestamp)
```

    ## # A tibble: 4 x 4
    ##   movieId rating title                                          genres    
    ##     <int>  <dbl> <fct>                                          <fct>     
    ## 1    1172    4   Cinema Paradiso (Nuovo cinema Paradiso) (1989) Drama     
    ## 2    1339    3.5 Dracula (Bram Stoker's Dracula) (1992)         Fantasy|H…
    ## 3    1953    4   French Connection, The (1971)                  Action|Cr…
    ## 4    2105    4   Tron (1982)                                    Action|Ad…

You can also use `select()` to reorder variables. A useful function here is `everything()`.

``` r
# original order
u1_likes
```

    ## # A tibble: 4 x 6
    ##   userId movieId rating  timestamp title                  genres          
    ##    <int>   <int>  <dbl>      <int> <fct>                  <fct>           
    ## 1      1    1172    4   1260759205 Cinema Paradiso (Nuov… Drama           
    ## 2      1    1339    3.5 1260759125 Dracula (Bram Stoker'… Fantasy|Horror|…
    ## 3      1    1953    4   1260759191 French Connection, Th… Action|Crime|Th…
    ## 4      1    2105    4   1260759139 Tron (1982)            Action|Adventur…

``` r
# reorder so title is first
select(u1_likes, title, everything())
```

    ## # A tibble: 4 x 6
    ##   title                   userId movieId rating timestamp genres          
    ##   <fct>                    <int>   <int>  <dbl>     <int> <fct>           
    ## 1 Cinema Paradiso (Nuovo…      1    1172    4      1.26e9 Drama           
    ## 2 Dracula (Bram Stoker's…      1    1339    3.5    1.26e9 Fantasy|Horror|…
    ## 3 French Connection, The…      1    1953    4      1.26e9 Action|Crime|Th…
    ## 4 Tron (1982)                  1    2105    4      1.26e9 Action|Adventur…

Adding new variables with `mutate()`
------------------------------------

Mutating operations add a new column to a dataframe. Here's a trivial example to get started:

``` r
mutate(u1_likes, this_is = "stupid")  
```

    ## # A tibble: 4 x 7
    ##   userId movieId rating  timestamp title             genres        this_is
    ##    <int>   <int>  <dbl>      <int> <fct>             <fct>         <chr>  
    ## 1      1    1172    4   1260759205 Cinema Paradiso … Drama         stupid 
    ## 2      1    1339    3.5 1260759125 Dracula (Bram St… Fantasy|Horr… stupid 
    ## 3      1    1953    4   1260759191 French Connectio… Action|Crime… stupid 
    ## 4      1    2105    4   1260759139 Tron (1982)       Action|Adven… stupid

A more useful use of mutate is to construct a new variable based on existing variables. This is the way that `mutate` is almost always used.

``` r
mutate(u1, like = ifelse(rating > 3, 1, 0))  
```

    ## # A tibble: 20 x 7
    ##    userId movieId rating  timestamp title            genres           like
    ##     <int>   <int>  <dbl>      <int> <fct>            <fct>           <dbl>
    ##  1      1      31    2.5 1260759144 Dangerous Minds… Drama               0
    ##  2      1    1029    3   1260759179 Dumbo (1941)     Animation|Chil…     0
    ##  3      1    1061    3   1260759182 Sleepers (1996)  Thriller            0
    ##  4      1    1129    2   1260759185 Escape from New… Action|Adventu…     0
    ##  5      1    1172    4   1260759205 Cinema Paradiso… Drama               1
    ##  6      1    1263    2   1260759151 Deer Hunter, Th… Drama|War           0
    ##  7      1    1287    2   1260759187 Ben-Hur (1959)   Action|Adventu…     0
    ##  8      1    1293    2   1260759148 Gandhi (1982)    Drama               0
    ##  9      1    1339    3.5 1260759125 Dracula (Bram S… Fantasy|Horror…     1
    ## 10      1    1343    2   1260759131 Cape Fear (1991) Thriller            0
    ## 11      1    1371    2.5 1260759135 Star Trek: The … Adventure|Sci-…     0
    ## 12      1    1405    1   1260759203 Beavis and Butt… Adventure|Anim…     0
    ## 13      1    1953    4   1260759191 French Connecti… Action|Crime|T…     1
    ## 14      1    2105    4   1260759139 Tron (1982)      Action|Adventu…     1
    ## 15      1    2150    3   1260759194 Gods Must Be Cr… Adventure|Come…     0
    ## 16      1    2193    2   1260759198 Willow (1988)    Action|Adventu…     0
    ## 17      1    2294    2   1260759108 Antz (1998)      Adventure|Anim…     0
    ## 18      1    2455    2.5 1260759113 Fly, The (1986)  Drama|Horror|S…     0
    ## 19      1    2968    1   1260759200 Time Bandits (1… Adventure|Come…     0
    ## 20      1    3671    3   1260759117 Blazing Saddles… Comedy|Western      0

We can also use the pipe for mutating operations. Hopefully you're getting used to the pipe by now, so let's embed a mutating operation within a larger pipe than we've used before.

``` r
ratings %>% 
  mutate(like = ifelse(rating > 3, 1, 0)) %>% 
  filter(userId == 1) %>% 
  select(like, everything()) 
```

    ## # A tibble: 20 x 7
    ##     like userId movieId rating  timestamp title            genres         
    ##    <dbl>  <int>   <int>  <dbl>      <int> <fct>            <fct>          
    ##  1     0      1      31    2.5 1260759144 Dangerous Minds… Drama          
    ##  2     0      1    1029    3   1260759179 Dumbo (1941)     Animation|Chil…
    ##  3     0      1    1061    3   1260759182 Sleepers (1996)  Thriller       
    ##  4     0      1    1129    2   1260759185 Escape from New… Action|Adventu…
    ##  5     1      1    1172    4   1260759205 Cinema Paradiso… Drama          
    ##  6     0      1    1263    2   1260759151 Deer Hunter, Th… Drama|War      
    ##  7     0      1    1287    2   1260759187 Ben-Hur (1959)   Action|Adventu…
    ##  8     0      1    1293    2   1260759148 Gandhi (1982)    Drama          
    ##  9     1      1    1339    3.5 1260759125 Dracula (Bram S… Fantasy|Horror…
    ## 10     0      1    1343    2   1260759131 Cape Fear (1991) Thriller       
    ## 11     0      1    1371    2.5 1260759135 Star Trek: The … Adventure|Sci-…
    ## 12     0      1    1405    1   1260759203 Beavis and Butt… Adventure|Anim…
    ## 13     1      1    1953    4   1260759191 French Connecti… Action|Crime|T…
    ## 14     1      1    2105    4   1260759139 Tron (1982)      Action|Adventu…
    ## 15     0      1    2150    3   1260759194 Gods Must Be Cr… Adventure|Come…
    ## 16     0      1    2193    2   1260759198 Willow (1988)    Action|Adventu…
    ## 17     0      1    2294    2   1260759108 Antz (1998)      Adventure|Anim…
    ## 18     0      1    2455    2.5 1260759113 Fly, The (1986)  Drama|Horror|S…
    ## 19     0      1    2968    1   1260759200 Time Bandits (1… Adventure|Come…
    ## 20     0      1    3671    3   1260759117 Blazing Saddles… Comedy|Western

Aggregating over rows with `summarise()`
----------------------------------------

The `summarise()` verb (or `summarize()` will also work) summarises the rows in a data frame in some way. When applied to the whole data frame, it will collapse it to a single row. For example, here we take user 1's data, and calculate their average rating and the number of movies they have given a rating higher than 3 to:

``` r
summarise(u1, mean = mean(rating), likes = sum(rating > 3))
```

    ## # A tibble: 1 x 2
    ##    mean likes
    ##   <dbl> <int>
    ## 1  2.55     4

You need to watch out for NAs when using `summarise()`. If one exists, operations like `mean()` will return NA. You can exclude NAs from calculations using `na.rm = TRUE`:

``` r
# introduce an NA
u1$rating[1] <- NA

# see what happens
summarise(u1, mean = mean(rating), likes = sum(rating > 3))
```

    ## # A tibble: 1 x 2
    ##    mean likes
    ##   <dbl> <int>
    ## 1    NA    NA

``` r
# with na.rm = TRUE
summarise(u1, mean = mean(rating, na.rm = TRUE), likes = sum(rating > 3, na.rm = TRUE))
```

    ## # A tibble: 1 x 2
    ##    mean likes
    ##   <dbl> <int>
    ## 1  2.55     4

`summarise()` is most useful when combined with `group_by()`, which imposes a grouping structure on a data frame. After applying `group_by()`, subsequent dplyr verbs will be applied to individual groups, basically repeating the code for each group. That means that `summarise()` will calculate a summary for each group:

``` r
# tell dplyr to group ratings by userId
ratings_by_user <- group_by(ratings, userId)

# apply summarize() to see how many movies each user has rated
ratings_by_user %>% summarize(count = n()) %>% head()
```

    ## # A tibble: 6 x 2
    ##   userId count
    ##    <int> <int>
    ## 1      1    20
    ## 2      2    76
    ## 3      3    51
    ## 4      4   204
    ## 5      5   100
    ## 6      6    44

``` r
# get sorted counts (plus some presentation stuff)
ratings %>% 
group_by(userId) %>% 
summarize(count = n()) %>% 
arrange(desc(count)) %>% 
head(10) %>%     # take first ten rows
t()  # transpose 
```

    ##        [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
    ## userId  547  564  624   15   73  452  468  380  311    30
    ## count  2391 1868 1735 1700 1610 1340 1291 1063 1019  1011

``` r
# or with the pipe (last time)
ratings %>% group_by(userId) %>% summarize(count = n()) %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    userId count
    ##     <int> <int>
    ##  1      1    20
    ##  2      2    76
    ##  3      3    51
    ##  4      4   204
    ##  5      5   100
    ##  6      6    44
    ##  7      7    88
    ##  8      8   116
    ##  9      9    45
    ## 10     10    46

You can also pass your own summary functions to the pipe:

``` r
# my own function, computes the 60% quantile of a vector
compute_60q <- function(x){quantile(x, probs = 0.60)}
# use it in a grouped summary
ratings %>% group_by(userId) %>% summarize(count = n(), q60 = compute_60q(rating)) %>% head(10)
```

    ## # A tibble: 10 x 3
    ##    userId count   q60
    ##     <int> <int> <dbl>
    ##  1      1    20   2.7
    ##  2      2    76   4  
    ##  3      3    51   3.5
    ##  4      4   204   5  
    ##  5      5   100   4  
    ##  6      6    44   4  
    ##  7      7    88   4  
    ##  8      8   116   4  
    ##  9      9    45   4  
    ## 10     10    46   4

Other uses of `grouped_by()`: grouped filters and grouped mutates
-----------------------------------------------------------------

While you'll probably use `group_by()` most often with `summarise()`, it can also be useful when used in conjunction with `filter()` and `mutate()`. Grouped filters perform the filtering within each group. Below we use it to extract each user's favourite movie (or movies, if there's a tie).

``` r
# example of a grouped filter
ratings %>% group_by(userId) %>% filter(rank(desc(rating)) < 2)
```

    ## # A tibble: 102 x 6
    ## # Groups:   userId [69]
    ##    userId movieId rating  timestamp title              genres             
    ##     <int>   <int>  <dbl>      <int> <fct>              <fct>              
    ##  1     13       1      5 1331380058 Toy Story (1995)   Adventure|Animatio…
    ##  2     13     356      5 1331380018 Forrest Gump (199… Comedy|Drama|Roman…
    ##  3     14    3175      5  976244313 Galaxy Quest (199… Adventure|Comedy|S…
    ##  4     18      25      5  856006886 Leaving Las Vegas… Drama|Romance      
    ##  5     18      32      5  856006885 Twelve Monkeys (a… Mystery|Sci-Fi|Thr…
    ##  6     24       6      5  849321588 Heat (1995)        Action|Crime|Thril…
    ##  7     24     296      5  849282414 Pulp Fiction (199… Comedy|Crime|Drama…
    ##  8     35    3072      5 1174450056 Moonstruck (1987)  Comedy|Romance     
    ##  9     50     589      5  847412628 Terminator 2: Jud… Action|Sci-Fi      
    ## 10     72   55820      5 1464722872 No Country for Ol… Crime|Drama        
    ## # ... with 92 more rows

Here we use a grouped mutate to standardise each user's ratings so that they have a mean of zero (for each user, which guarantees the overall mean rating is also zero).

``` r
# example of a grouped mutate
ratings %>% 
  group_by(userId) %>%
  mutate(centered_rating = rating - mean(rating)) %>% 
  select(-movieId, -timestamp, -genres)
```

    ## # A tibble: 100,004 x 4
    ## # Groups:   userId [671]
    ##    userId rating title                                     centered_rating
    ##     <int>  <dbl> <fct>                                               <dbl>
    ##  1      1    2.5 Dangerous Minds (1995)                            -0.0500
    ##  2      1    3   Dumbo (1941)                                       0.45  
    ##  3      1    3   Sleepers (1996)                                    0.45  
    ##  4      1    2   Escape from New York (1981)                       -0.550 
    ##  5      1    4   Cinema Paradiso (Nuovo cinema Paradiso) …          1.45  
    ##  6      1    2   Deer Hunter, The (1978)                           -0.550 
    ##  7      1    2   Ben-Hur (1959)                                    -0.550 
    ##  8      1    2   Gandhi (1982)                                     -0.550 
    ##  9      1    3.5 Dracula (Bram Stoker's Dracula) (1992)             0.95  
    ## 10      1    2   Cape Fear (1991)                                  -0.550 
    ## # ... with 99,994 more rows

Putting it all together: extracting a sample set of reviews
-----------------------------------------------------------

In this section we'll take what we've learned and do something useful: build a 15x20 matrix containing the reviews made on 20 movies by 15 users. We'll use this matrix in one of the next lessons to build a recommendation system.

First, we select the 15 users we want to use. I've chosen to use 15 users with moderately frequent viewing habits (remember there are 700 users and 9000 movies), mainly to make sure there are some (but not too many) empty ratings.

``` r
users_frq <- ratings %>% group_by(userId) %>% summarize(count = n()) %>% arrange(desc(count))
my_users <- users_frq$userId[101:115]
```

Next, we select the 20 movies we want to use:

``` r
movies_frq <- ratings %>% group_by(movieId) %>% summarize(count = n()) %>% arrange(desc(count))
my_movies <- movies_frq$movieId[101:120]
```

Now we make a dataset with only those 15 users and 20 movies:

``` r
ratings_red <- ratings %>% filter(userId %in% my_users, movieId %in% my_movies) 
# and check there are 15 users and 20 movies in the reduced dataset
n_users <- length(unique(ratings_red$userId))
n_movies <- length(unique(ratings_red$movieId))
paste("number of users is", n_users)
```

    ## [1] "number of users is 15"

``` r
paste("number of movies is", n_movies)
```

    ## [1] "number of movies is 20"

Let's see what the 20 movies are:

``` r
movies %>% filter(movieId %in% my_movies) %>% select(title)
```

    ##                                                      title
    ## 1                                       Taxi Driver (1976)
    ## 2                                        Waterworld (1995)
    ## 3                                          Outbreak (1995)
    ## 4                            Star Trek: Generations (1994)
    ## 5                          Clear and Present Danger (1994)
    ## 6                                        Casablanca (1942)
    ## 7                                 Wizard of Oz, The (1939)
    ## 8                                    Apocalypse Now (1979)
    ## 9                                       Stand by Me (1986)
    ## 10                               Fifth Element, The (1997)
    ## 11                                       Armageddon (1998)
    ## 12                                         Rain Man (1988)
    ## 13                              Breakfast Club, The (1985)
    ## 14            Austin Powers: The Spy Who Shagged Me (1999)
    ## 15                                     American Pie (1999)
    ## 16 Crouching Tiger, Hidden Dragon (Wo hu cang long) (2000)
    ## 17                                Beautiful Mind, A (2001)
    ## 18                                  Minority Report (2002)
    ## 19                                Kill Bill: Vol. 1 (2003)
    ## 20                                        Inception (2010)

However, note all the movie titles are still being kept:

``` r
head(levels(ratings_red$title), 10)
```

    ##  [1] "¡Three Amigos! (1986)"                  
    ##  [2] "...And God Spoke (1993)"                
    ##  [3] "...And Justice for All (1979)"          
    ##  [4] "'burbs, The (1989)"                     
    ##  [5] "'Hellboy': The Seeds of Creation (2004)"
    ##  [6] "'Neath the Arizona Skies (1934)"        
    ##  [7] "'night Mother (1986)"                   
    ##  [8] "'Round Midnight (1986)"                 
    ##  [9] "'Salem's Lot (2004)"                    
    ## [10] "'Til There Was You (1997)"

This actually isn't what we want, so let's drop the ones we won't use.

``` r
ratings_red <- droplevels(ratings_red)
levels(ratings_red$title)
```

    ##  [1] "American Pie (1999)"                                    
    ##  [2] "Apocalypse Now (1979)"                                  
    ##  [3] "Armageddon (1998)"                                      
    ##  [4] "Austin Powers: The Spy Who Shagged Me (1999)"           
    ##  [5] "Beautiful Mind, A (2001)"                               
    ##  [6] "Breakfast Club, The (1985)"                             
    ##  [7] "Casablanca (1942)"                                      
    ##  [8] "Clear and Present Danger (1994)"                        
    ##  [9] "Crouching Tiger, Hidden Dragon (Wo hu cang long) (2000)"
    ## [10] "Fifth Element, The (1997)"                              
    ## [11] "Inception (2010)"                                       
    ## [12] "Kill Bill: Vol. 1 (2003)"                               
    ## [13] "Minority Report (2002)"                                 
    ## [14] "Outbreak (1995)"                                        
    ## [15] "Rain Man (1988)"                                        
    ## [16] "Stand by Me (1986)"                                     
    ## [17] "Star Trek: Generations (1994)"                          
    ## [18] "Taxi Driver (1976)"                                     
    ## [19] "Waterworld (1995)"                                      
    ## [20] "Wizard of Oz, The (1939)"

We now want to reshape the data frame into a 15x20 matrix i.e.from "long" format to "wide" format. We can do this using the `spread()` verb.

``` r
ratings_red %>% spread(key = movieId, value = rating)
```

    ## # A tibble: 106 x 24
    ##    userId timestamp title genres `111` `208` `292` `329` `349` `912` `919`
    ##  *  <int>     <int> <fct> <fct>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1    149    1.44e9 Ince… Actio…    NA    NA    NA    NA    NA    NA    NA
    ##  2    149    1.44e9 Brea… Comed…    NA    NA    NA    NA    NA    NA    NA
    ##  3    149    1.44e9 Fift… Actio…    NA    NA    NA    NA    NA    NA    NA
    ##  4    149    1.44e9 Amer… Comed…    NA    NA    NA    NA    NA    NA    NA
    ##  5    149    1.44e9 Stan… Adven…    NA    NA    NA    NA    NA    NA    NA
    ##  6    177    9.07e8 Arma… Actio…    NA    NA    NA    NA    NA    NA    NA
    ##  7    177    9.07e8 Fift… Actio…    NA    NA    NA    NA    NA    NA    NA
    ##  8    177    9.07e8 Star… Adven…    NA    NA    NA     4    NA    NA    NA
    ##  9    177    9.07e8 Clea… Actio…    NA    NA    NA    NA     4    NA    NA
    ## 10    177    9.07e8 Taxi… Crime…     4    NA    NA    NA    NA    NA    NA
    ## # ... with 96 more rows, and 13 more variables: `1208` <dbl>,
    ## #   `1259` <dbl>, `1527` <dbl>, `1917` <dbl>, `1961` <dbl>, `1968` <dbl>,
    ## #   `2683` <dbl>, `2706` <dbl>, `3996` <dbl>, `4995` <dbl>, `5445` <dbl>,
    ## #   `6874` <dbl>, `79132` <dbl>

The preceding line *doesn't* work: as you can see we land up with more than one row per user. But it is useful as an illustration of `spread()`. Question: why doesn't it work?

Here's the corrected version:

``` r
ratings_red %>% select(userId, title, rating) %>% spread(key = title, value = rating)
```

    ## # A tibble: 15 x 21
    ##    userId `American Pie (1999)` `Apocalypse Now (1979)` `Armageddon (1998…
    ##  *  <int>                 <dbl>                   <dbl>              <dbl>
    ##  1    149                   3                      NA                 NA  
    ##  2    177                  NA                      NA                  3  
    ##  3    200                   1.5                    NA                  3  
    ##  4    236                  NA                       5                 NA  
    ##  5    240                  NA                      NA                 NA  
    ##  6    270                  NA                       4                 NA  
    ##  7    287                  NA                      NA                  4  
    ##  8    295                  NA                      NA                 NA  
    ##  9    303                   2.5                    NA                 NA  
    ## 10    408                  NA                       5                  4  
    ## 11    426                   1                      NA                  3.5
    ## 12    442                   4.5                     4.5                3.5
    ## 13    500                   2                      NA                 NA  
    ## 14    522                   3                       3.5                2.5
    ## 15    562                   4.5                     4                  3.5
    ## # ... with 17 more variables: `Austin Powers: The Spy Who Shagged Me
    ## #   (1999)` <dbl>, `Beautiful Mind, A (2001)` <dbl>, `Breakfast Club, The
    ## #   (1985)` <dbl>, `Casablanca (1942)` <dbl>, `Clear and Present Danger
    ## #   (1994)` <dbl>, `Crouching Tiger, Hidden Dragon (Wo hu cang long)
    ## #   (2000)` <dbl>, `Fifth Element, The (1997)` <dbl>, `Inception
    ## #   (2010)` <dbl>, `Kill Bill: Vol. 1 (2003)` <dbl>, `Minority Report
    ## #   (2002)` <dbl>, `Outbreak (1995)` <dbl>, `Rain Man (1988)` <dbl>,
    ## #   `Stand by Me (1986)` <dbl>, `Star Trek: Generations (1994)` <dbl>,
    ## #   `Taxi Driver (1976)` <dbl>, `Waterworld (1995)` <dbl>, `Wizard of Oz,
    ## #   The (1939)` <dbl>

Finally, since we just want to know who has seen what, we replace all NAs with 0 and all other ratings with 1:

``` r
viewed_movies <- ratings_red %>% 
  complete(userId, title) %>% 
  mutate(seen = ifelse(is.na(rating), 0, 1)) %>% 
  select(userId, title, seen) %>% 
  spread(key = title, value = seen)
```

We could have got this more simply with a call to `table()`, which creates a two-way frequency table.

``` r
table(ratings_red$userId, ratings_red$title)
```

    ##      
    ##       American Pie (1999) Apocalypse Now (1979) Armageddon (1998)
    ##   149                   1                     0                 0
    ##   177                   0                     0                 1
    ##   200                   1                     0                 1
    ##   236                   0                     1                 0
    ##   240                   0                     0                 0
    ##   270                   0                     1                 0
    ##   287                   0                     0                 1
    ##   295                   0                     0                 0
    ##   303                   1                     0                 0
    ##   408                   0                     1                 1
    ##   426                   1                     0                 1
    ##   442                   1                     1                 1
    ##   500                   1                     0                 0
    ##   522                   1                     1                 1
    ##   562                   1                     1                 1
    ##      
    ##       Austin Powers: The Spy Who Shagged Me (1999)
    ##   149                                            0
    ##   177                                            0
    ##   200                                            0
    ##   236                                            0
    ##   240                                            0
    ##   270                                            0
    ##   287                                            0
    ##   295                                            0
    ##   303                                            0
    ##   408                                            1
    ##   426                                            0
    ##   442                                            1
    ##   500                                            1
    ##   522                                            0
    ##   562                                            1
    ##      
    ##       Beautiful Mind, A (2001) Breakfast Club, The (1985)
    ##   149                        0                          1
    ##   177                        0                          1
    ##   200                        1                          0
    ##   236                        0                          0
    ##   240                        1                          0
    ##   270                        1                          0
    ##   287                        0                          0
    ##   295                        1                          0
    ##   303                        1                          1
    ##   408                        0                          1
    ##   426                        1                          0
    ##   442                        1                          1
    ##   500                        1                          1
    ##   522                        1                          0
    ##   562                        0                          0
    ##      
    ##       Casablanca (1942) Clear and Present Danger (1994)
    ##   149                 0                               0
    ##   177                 0                               1
    ##   200                 0                               0
    ##   236                 1                               0
    ##   240                 0                               0
    ##   270                 0                               0
    ##   287                 0                               0
    ##   295                 1                               0
    ##   303                 0                               0
    ##   408                 0                               0
    ##   426                 0                               0
    ##   442                 0                               1
    ##   500                 0                               0
    ##   522                 0                               0
    ##   562                 0                               0
    ##      
    ##       Crouching Tiger, Hidden Dragon (Wo hu cang long) (2000)
    ##   149                                                       0
    ##   177                                                       0
    ##   200                                                       0
    ##   236                                                       1
    ##   240                                                       1
    ##   270                                                       0
    ##   287                                                       1
    ##   295                                                       1
    ##   303                                                       0
    ##   408                                                       0
    ##   426                                                       0
    ##   442                                                       0
    ##   500                                                       0
    ##   522                                                       0
    ##   562                                                       1
    ##      
    ##       Fifth Element, The (1997) Inception (2010) Kill Bill: Vol. 1 (2003)
    ##   149                         1                1                        0
    ##   177                         1                0                        0
    ##   200                         1                1                        0
    ##   236                         0                0                        0
    ##   240                         0                0                        1
    ##   270                         0                1                        1
    ##   287                         0                1                        0
    ##   295                         1                0                        1
    ##   303                         1                1                        1
    ##   408                         1                0                        0
    ##   426                         0                1                        1
    ##   442                         0                0                        1
    ##   500                         0                0                        0
    ##   522                         0                1                        1
    ##   562                         0                0                        1
    ##      
    ##       Minority Report (2002) Outbreak (1995) Rain Man (1988)
    ##   149                      0               0               0
    ##   177                      0               1               0
    ##   200                      1               0               0
    ##   236                      0               0               0
    ##   240                      1               0               0
    ##   270                      1               0               0
    ##   287                      1               0               0
    ##   295                      1               1               1
    ##   303                      0               0               1
    ##   408                      0               0               1
    ##   426                      0               0               1
    ##   442                      0               0               1
    ##   500                      0               0               0
    ##   522                      0               0               1
    ##   562                      1               1               0
    ##      
    ##       Stand by Me (1986) Star Trek: Generations (1994) Taxi Driver (1976)
    ##   149                  1                             0                  0
    ##   177                  1                             1                  1
    ##   200                  0                             0                  0
    ##   236                  0                             0                  1
    ##   240                  0                             0                  1
    ##   270                  0                             0                  0
    ##   287                  0                             1                  0
    ##   295                  0                             0                  0
    ##   303                  1                             0                  0
    ##   408                  1                             0                  0
    ##   426                  0                             0                  0
    ##   442                  0                             0                  0
    ##   500                  0                             1                  0
    ##   522                  0                             0                  0
    ##   562                  0                             0                  0
    ##      
    ##       Waterworld (1995) Wizard of Oz, The (1939)
    ##   149                 0                        0
    ##   177                 0                        0
    ##   200                 0                        0
    ##   236                 0                        0
    ##   240                 0                        1
    ##   270                 0                        0
    ##   287                 0                        1
    ##   295                 1                        1
    ##   303                 0                        1
    ##   408                 0                        1
    ##   426                 0                        0
    ##   442                 1                        1
    ##   500                 0                        1
    ##   522                 0                        0
    ##   562                 1                        0

Finally, we save our output for later use!

``` r
dir.create("output")
```

    ## Warning in dir.create("output"): 'output' already exists

``` r
save(ratings_red, viewed_movies, file = "output/recommender.RData")
```

Combining data frames with *joins*
----------------------------------

We'll often need to combine the information contained in two or more tables. To do this, we need various kinds of database *joins*. This section describes the basic join operations that we need to combine data frames. The examples are taken from [Chapter 13](http://r4ds.had.co.nz/relational-data.html) of R4DS, which also contains a lot more general information on relational data.

First, we make some very simple data tables to show how the joins work:

``` r
# make some example data
x <- tribble(
  ~key, ~xvalue,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~yvalue,
  1, "y1",
  2, "y2",
  4, "y3"
)

x 
```

    ## # A tibble: 3 x 2
    ##     key xvalue
    ##   <dbl> <chr> 
    ## 1     1 x1    
    ## 2     2 x2    
    ## 3     3 x3

``` r
y
```

    ## # A tibble: 3 x 2
    ##     key yvalue
    ##   <dbl> <chr> 
    ## 1     1 y1    
    ## 2     2 y2    
    ## 3     4 y3

### Mutating joins: `inner_join`, `left_join`, `right_join`, `full_join`

The first set of joins we look at are called mutating joins. These first match observations in two tables in some way, and then combine variables from the two tables.

There are four types of mutating joins: inner joins, left joins, right joins, and full joins.

An **inner join** keeps observations that appear in *both* tables.

``` r
inner_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 2 x 3
    ##     key xvalue yvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 x1     y1    
    ## 2     2 x2     y2

``` r
inner_join(y,x)
```

    ## Joining, by = "key"

    ## # A tibble: 2 x 3
    ##     key yvalue xvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 y1     x1    
    ## 2     2 y2     x2

The other three joints are all **outer joins**: they keep observations that appear in *at least one* of the tables.

A **left join** keeps all observations from the left table (first argument).

``` r
left_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 3 x 3
    ##     key xvalue yvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 x1     y1    
    ## 2     2 x2     y2    
    ## 3     3 x3     <NA>

``` r
left_join(y,x)
```

    ## Joining, by = "key"

    ## # A tibble: 3 x 3
    ##     key yvalue xvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 y1     x1    
    ## 2     2 y2     x2    
    ## 3     4 y3     <NA>

A **right join** keeps all observations from the right table (second argument).

``` r
# note this is the same as left_join(y,x)
right_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 3 x 3
    ##     key xvalue yvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 x1     y1    
    ## 2     2 x2     y2    
    ## 3     4 <NA>   y3

A **full join** keeps all observations from the left and right table.

``` r
full_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 4 x 3
    ##     key xvalue yvalue
    ##   <dbl> <chr>  <chr> 
    ## 1     1 x1     y1    
    ## 2     2 x2     y2    
    ## 3     3 x3     <NA>  
    ## 4     4 <NA>   y3

We can now re-examine the join we used to add movie titles to the ratings data frame earlier:

``` r
# reload the MovieLens data
load("data/movielens-small.RData")
ratings <- as.tibble(ratings)
movies <- as.tibble(movies)
```

Note that the same *movieId* can appear multiple times in the *ratings* data frame:

``` r
ratings %>% arrange(movieId) # note duplicate movieIds
```

    ## # A tibble: 100,004 x 4
    ##    userId movieId rating  timestamp
    ##     <int>   <int>  <dbl>      <int>
    ##  1      7       1    3    851866703
    ##  2      9       1    4    938629179
    ##  3     13       1    5   1331380058
    ##  4     15       1    2    997938310
    ##  5     19       1    3    855190091
    ##  6     20       1    3.5 1238729767
    ##  7     23       1    3   1148729853
    ##  8     26       1    5   1360087980
    ##  9     30       1    4    944943070
    ## 10     37       1    4    981308121
    ## # ... with 99,994 more rows

But each *movieId* only appears once in the *movies* data frame:

``` r
movies %>% arrange(movieId) # note unique movieIds
```

    ## # A tibble: 9,125 x 3
    ##    movieId title                              genres                      
    ##      <int> <fct>                              <fct>                       
    ##  1       1 Toy Story (1995)                   Adventure|Animation|Childre…
    ##  2       2 Jumanji (1995)                     Adventure|Children|Fantasy  
    ##  3       3 Grumpier Old Men (1995)            Comedy|Romance              
    ##  4       4 Waiting to Exhale (1995)           Comedy|Drama|Romance        
    ##  5       5 Father of the Bride Part II (1995) Comedy                      
    ##  6       6 Heat (1995)                        Action|Crime|Thriller       
    ##  7       7 Sabrina (1995)                     Comedy|Romance              
    ##  8       8 Tom and Huck (1995)                Adventure|Children          
    ##  9       9 Sudden Death (1995)                Action                      
    ## 10      10 GoldenEye (1995)                   Action|Adventure|Thriller   
    ## # ... with 9,115 more rows

In this case a left join by the *movieId* key copies across the movie title information (as well as any other information in the *movies* data frame):

``` r
left_join(ratings, movies, by = "movieId") %>% select(title, everything())
```

    ## # A tibble: 100,004 x 6
    ##    title                  userId movieId rating timestamp genres          
    ##    <fct>                   <int>   <int>  <dbl>     <int> <fct>           
    ##  1 Dangerous Minds (1995)      1      31    2.5    1.26e9 Drama           
    ##  2 Dumbo (1941)                1    1029    3      1.26e9 Animation|Child…
    ##  3 Sleepers (1996)             1    1061    3      1.26e9 Thriller        
    ##  4 Escape from New York …      1    1129    2      1.26e9 Action|Adventur…
    ##  5 Cinema Paradiso (Nuov…      1    1172    4      1.26e9 Drama           
    ##  6 Deer Hunter, The (197…      1    1263    2      1.26e9 Drama|War       
    ##  7 Ben-Hur (1959)              1    1287    2      1.26e9 Action|Adventur…
    ##  8 Gandhi (1982)               1    1293    2      1.26e9 Drama           
    ##  9 Dracula (Bram Stoker'…      1    1339    3.5    1.26e9 Fantasy|Horror|…
    ## 10 Cape Fear (1991)            1    1343    2      1.26e9 Thriller        
    ## # ... with 99,994 more rows

### Filtering joins: `semi_join`, `anti_join`

The last two joins we look at are **filtering joins**. These match observations in two tables, but do not add variables. There are two types of filtering joins: semi-joins and anti-joins.

A **semi join** keeps all observations from the first table that appear in the second (note variables are from the first table only):

``` r
semi_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 2 x 2
    ##     key xvalue
    ##   <dbl> <chr> 
    ## 1     1 x1    
    ## 2     2 x2

``` r
semi_join(y,x)
```

    ## Joining, by = "key"

    ## # A tibble: 2 x 2
    ##     key yvalue
    ##   <dbl> <chr> 
    ## 1     1 y1    
    ## 2     2 y2

while an **anti join** *drops* all observations from the first table that appear in the second table (note variables are from the first table only).

``` r
anti_join(x,y)
```

    ## Joining, by = "key"

    ## # A tibble: 1 x 2
    ##     key xvalue
    ##   <dbl> <chr> 
    ## 1     3 x3

``` r
anti_join(y,x)
```

    ## Joining, by = "key"

    ## # A tibble: 1 x 2
    ##     key yvalue
    ##   <dbl> <chr> 
    ## 1     4 y3

Exercises
---------

1.  Write a function called **my\_range** that computes the difference between the 90% and 10% quantiles of a vector, and another function called **my\_cov** that computes the coefficient of variation of a vector (defined as the standard deviation divided by mean). Use these functions to work out how "variable"" each movie's ratings are, and hence what the most variable (in the sense of love-them-or-hate-them) movies are. Do the same for users i.e. find out which users give the most variable ratings, in terms of your two variability functions.

2.  Do the exercises in [Chapter 5](http://r4ds.had.co.nz/transform.html) (data transformation using the **dplyr** verbs) and [Chapter 13](http://r4ds.had.co.nz/relational-data.html) (on database joins) of R4DS. There are exercises at the end of each major subsection. Do as many of these exercises as you need to feel comfortable with the material - I suggest doing at least the first two of each set of exercises.
