---
title: Know Your Data
key: 4cfd91fcbc986579858c55482728e057
video_link:
    hls: https://s3.amazonaws.com/videos.datacamp.com/transcoded/6012_working_with_data_in_the_tidyverse/v1/hls-6012_ch1_2.master.m3u8
    mp4: https://s3.amazonaws.com/videos.datacamp.com/transcoded_mp4/6012_working_with_data_in_the_tidyverse/v1/6012_ch1_2.mp4
transformations:
    translateX: 55
    translateY: 0
    scale: 1

---
## Know Your Data

```yaml
type: "TitleSlide"
key: "26c199cd36"
```

`@lower_third`

name: Alison Hill
title: Professor & Data Scientist


`@script`
Now that we have read our data into R, let's start with getting to know it a little better.


---
## The Great British Bake Off

```yaml
type: "FullSlide"
key: "532b00ccff"
center_content: true
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/d0e58c4fd891e77ed29c0c38ac05f01c08e1d5f9/01.02_gbbo-overview_smaller.png)


`@script`
One of the most important things you can do when working with any new data is to learn about how it was collected, and do a exploratory data analysis. We have been working with the bakers data from The Great British Bake Off. 

On each episode of the show, one baker is eliminated, one wins the technical challenge, and one is chosen as star baker. The title of star baker is based on the baker's performance across three timed challenges; the signature, the technical, and the showstopper.

Now, let's have another look at the bakers data.


---
## Look at your data

```yaml
type: "FullSlide"
key: "187ba7f717"
```

`@part1`
```{r}
bakers_mini
```{{1}}
```
# A tibble: 10 x 10
   series baker    age num_episodes aired_us last_date_uk
   <fct>  <chr>  <dbl>        <dbl> <lgl>    <date>      
 1 3      Natas…   36.           1. FALSE    2012-08-14  
 2 3      Sarah…   28.           7. FALSE    2012-09-25  
 3 3      Cathr…   27.           8. FALSE    2012-10-02  
 4 4      Lucy     38.           2. TRUE     2013-08-27  
 5 4      Howard   51.           6. TRUE     2013-09-24  
 6 4      Beca     31.           9. TRUE     2013-10-15  
 7 4      Kimbe…   30.          10. TRUE     2013-10-22  
 8 5      Enwez…   39.           2. TRUE     2014-08-13  
 9 5      Jordan   32.           3. TRUE     2014-08-20  
10 5      Iain     31.           4. TRUE     2014-08-27  
# ... with 4 more variables: occupation <chr>,
#   hometown <chr>, star_baker <dbl>,
#   technical_winner <dbl>
```{{2}}


`@script`
So far, we've printed tibbles to view them. But, if you have lots of columns, most will be cut off when you print.

Here, when we print our bakers data with 10 columns, we see that there are 4 more variables that are hidden.


---
## Use glimpse

```yaml
type: "FullSlide"
key: "83e618b465"
```

`@part1`
```{r}
glimpse(bakers_mini)
```{{1}}
```
Observations: 10
Variables: 10
$ series           <fct> 3, 3, 3, 4, 4, 4, 4, 5, 5, 5
$ baker            <chr> "Natasha", "Sarah-Jane", "Ca...
$ age              <dbl> 36, 28, 27, 38, 51, 31, 30, ...
$ num_episodes     <dbl> 1, 7, 8, 2, 6, 9, 10, 2, 3, 4
$ aired_us         <lgl> FALSE, FALSE, FALSE, TRUE, T...
$ last_date_uk     <date> 2012-08-14, 2012-09-25, 201...
$ occupation       <chr> "Midwife", "Vicar's wife", "...
$ hometown         <chr> "Tamworth, Staffordshire", "...
$ star_baker       <dbl> 0, 0, 0, 0, 0, 0, 2, 0, 0, 0
$ technical_winner <dbl> 0, 1, 1, 0, 0, 1, 3, 0, 0, 0
```{{2}}


`@script`
To see all the columns, we use the function glimpse from the dplyr package. The argument for glimpse is the name of your tibble.

The glimpse output is a transposed view of your data, where each variable appears in rows from top to bottom instead of left to right. Going across each row, glimpse prints the first few observed values for every variable.

We also see the number of observations and variables at the top.


---
## Use skim

```yaml
type: "FullSlide"
key: "94412df8c9"
```

`@part1`
```{r}
library(skimr) 
skim(bakers_mini)
```{{1}}
```
Skim summary statistics
 n obs: 10 
 n variables: 10 

Variable type: character 
    variable missing complete  n min max empty n_unique
1      baker       0       10 10   4  10     0       10
2   hometown       0       10 10   6  26     0       10
3 occupation       0       10 10   7  28     0       10
```{{2}}


`@script`
You may also want to summarize your data by looking at summary statistics for each variable. A quick way to do this is with the skim function from the skimr package.

Like glimpse, the argument for skim is the name of your tibble.

Skim provides statistics for every column depending on the type of variable. The results are printed horizontally with one row per variable, divided in sections for each variable type. 

Let's break down the first section of output summarizing our three character variables.

For baker, there are no missing values, and 10 complete observations for each variable. The minimum and maximum values refer to string length. Also, each value is unique here- there are no bakers with the same name.


---
## Skim date, factor, and logical variables

```yaml
type: "FullSlide"
key: "4029887045"
```

`@part1`
```{r}
skim(bakers_mini)
```{{1}}
```
Variable type: Date 
      variable missing complete  n        min        max     median n_unique
1 last_date_uk       0       10 10 2012-08-14 2014-08-27 2013-10-04       10
```{{2}}
```
Variable type: factor 
  variable missing complete  n n_unique             top_counts ordered
1   series       0       10 10        3 4: 4, 3: 3, 5: 3, 1: 0 FALSE
```{{3}}
```
Variable type: logical 
  variable missing complete  n mean                 count
1 aired_us       0       10 10  0.7 TRU: 7, FAL: 3, NA: 0
```{{4}}


`@script`
The next sections of the skim output summarize dates.

The variable last underscore date underscore uk is the last date that each baker appeared on the show in the UK. From the min and max values, we can tell that our data spans about 2 years.

For the series factor, there are only 3 unique values across the 10 observations. Looking at the top counts, series 4 is the most common. 

The logical column named aired underscore us is TRUE if that baker appeared in a series that aired in the US, and FALSE if not. The mean tells us that 70% of the bakers here were seen by US viewers.


---
## Skim numeric variables

```yaml
type: "FullSlide"
key: "e4fa8ec2b1"
```

`@part1`
```{r}
skim(bakers_mini)
```{{1}}
```
Variable type: numeric 
          variable missing complete  n mean   sd min   p25 median   p75 max
1              age       0       10 10 34.3 7.12  27 30.25   31.5 37.5   51
2     num_episodes       0       10 10  5.2 3.22   1  2.25    5    7.75  10
3       star_baker       0       10 10  0.2 0.63   0  0       0    0      2
4 technical_winner       0       10 10  0.6 0.97   0  0       0    1      3
      hist
1 ▇▇▂▅▁▁▁▂
2 ▇▂▂▁▂▂▂▅
3 ▇▁▁▁▁▁▁▁
4 ▇▁▃▁▁▁▁▁
```{{2}}


`@script`
Numeric variables are summarized last.

In addition to the number of missing and complete values, skim returns the means, standard deviations, and quantiles of the variables.

A mini histogram is also printed to give you a sense for the distribution of each variable. 

From this skimmed output, we know that the average age of these bakers is 34, and bakers appeared in anywhere from 1 to 10 episodes, with a median of 5. Only one of these 10 bakers was crowned star baker in their time on the show- and they won it twice! Most bakers in this tibble never won the technical challenge, but one did win three technical challenges.


---
## Let's get to work!

```yaml
type: "FinalSlide"
key: "e886455c54"
```

`@script`
Now it's time to put glimpse and skim into practice with our bakeoff data.

