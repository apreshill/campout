---
title: Count With Your Data
key: 598f9582872d0d3ee4c733a4a2faa99a
video_link:
    hls: https://s3.amazonaws.com/videos.datacamp.com/transcoded/6012_working_with_data_in_the_tidyverse/v1/hls-6012_ch1_3.master.m3u8
    mp4: https://s3.amazonaws.com/videos.datacamp.com/transcoded_mp4/6012_working_with_data_in_the_tidyverse/v1/6012_ch1_3.mp4
transformations:
    translateX: 55
    translateY: 0
    scale: 1

---
## Count With Your Data

```yaml
type: "TitleSlide"
key: "b96f69ad4e"
```

`@lower_third`

name: Alison Hill
title: Professor & Data Scientist


`@script`
Now that we have gotten to know our data better, it's time to do some careful counting. While glimpse and skim give nice overviews, counting values within variables will help you to better understand the underlying structure of your data and can help guide you toward asking good questions about your data.


---
## All the bakers

```yaml
type: "FullSlide"
key: "d1142dde94"
```

`@part1`
```{r}
glimpse(bakers)
```
```
Observations: 95
Variables: 10
$ series           <fct> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
$ baker            <chr> "Lea", "Mark", "Annetha", "L...
$ age              <dbl> 51, 48, 30, 44, 25, 31, 45, ...
$ num_episodes     <dbl> 1, 1, 2, 2, 3, 4, 5, 6, 6, 6...
$ aired_us         <lgl> FALSE, FALSE, FALSE, FALSE, ...
$ last_date_uk     <date> 2010-08-17, 2010-08-17, 201...
$ occupation       <chr> "Retired", "Bus Driver", "Si...
$ hometown         <chr> "Midlothian, Scotland", "Sou...
$ star_baker       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
$ technical_winner <dbl> 0, 0, 0, 0, 1, 0, 0, 2, 2, 0...
```{{1}}


`@script`
We'll work with the "bakers" data again, but this time we'll use the full data for all bakers who have appeared on "The Great British Bake Off". Here is a glimpse of bakers. We have 95 observations, or bakers, and 10 variables.

Let's start with a simple question: how many series of the TV show do we have data for?


---
## Distinct series

```yaml
type: "FullSlide"
key: "d12751ff04"
```

`@part1`
```{r}
bakers %>% 
  distinct(series)
```{{1}}
```
# A tibble: 8 x 1
  series
  <fct> 
1 1     
2 2     
3 3     
4 4     
5 5     
6 6     
7 7     
8 8 
```{{2}}


`@script`
More specifically, how many *distinct* series are there? 

For that, we can use the distinct function from the dplyr package. And we see that there are 8! So we have 8 series, and we know that each row is a baker. How can we count the number of distinct bakers per series?


---
## Count rows by one variable

```yaml
type: "FullSlide"
key: "ffe70ac1ab"
```

`@part1`
```{r}
bakers %>% 
  count(series)
```{{1}}
```
# A tibble: 8 x 2
  series     n
  <fct>  <int>
1 1         10
2 2         12
3 3         12
4 4         13
5 5         12
6 6         12
7 7         12
8 8         12
```{{2}}


`@script`
We'll use a new dplyr verb: count. The argument to count is a variable or variables to group by. 

Count adds a new column named "n" to store the counts. Since each row is a baker, we know that most series feature a dozen bakers. Series 1 had only 10, and series 4 had a baker's dozen or 13.


---
## Count does group_by and summarize for you

```yaml
type: "TwoColumns"
key: "1855479494"
disable_transition: true
```

`@part1`
```{r}
bakers %>% 
  count(series)
```
```
# A tibble: 8 x 2
  series     n
  <fct>  <int>
1 1         10
2 2         12
3 3         12
4 4         13
5 5         12
6 6         12
7 7         12
8 8         12
```


`@part2`
```{r}
bakers %>% 
  group_by(series) %>% 
  summarize(n = n()) 
```{{1}}
```
# A tibble: 8 x 2
  series     n
  <fct>  <int>
1 1         10
2 2         12
3 3         12
4 4         13
5 5         12
6 6         12
7 7         12
8 8         12
```{{1}}


`@script`
Using count gives you the same output as using group underscore by followed by summarize to count the rows by group.


---
## Count rows by two variables

```yaml
type: "FullSlide"
key: "c2d00cb799"
```

`@part1`
```{r}
bakers %>% 
  count(aired_us, series) 
```{{1}}
```
# A tibble: 8 x 3
  aired_us series     n
  <lgl>    <fct>  <int>
1 FALSE    1         10
2 FALSE    2         12
3 FALSE    3         12
4 FALSE    8         12
5 TRUE     4         13
6 TRUE     5         12
7 TRUE     6         12
8 TRUE     7         12
```{{2}}


`@script`
We can also count by more than one variable. Here we count by two variables: aired underscore us and series. 

We can see that series 4, 5, 6, and 7 have aired in the US. The n column is still the number of bakers.


---
## Count also ungroups for you

```yaml
type: "TwoColumns"
key: "7b1654e5a2"
```

`@part1`
```{r}
bakers %>% 
  count(aired_us, series) %>% 
  mutate(prop_bakers = n/sum(n))
```{{1}}
```
# A tibble: 8 x 4
  aired_us series     n prop_bakers
  <lgl>    <fct>  <int>       <dbl>
1 FALSE    1         10       0.105
2 FALSE    2         12       0.126
3 FALSE    3         12       0.126
4 FALSE    8         12       0.126
5 TRUE     4         13       0.137
6 TRUE     5         12       0.126
7 TRUE     6         12       0.126
8 TRUE     7         12       0.126
```{{2}}


`@part2`
```{r}
bakers %>% 
  group_by(aired_us, series) %>% 
  summarize(n = n()) %>% 
  mutate(prop_bakers = n/sum(n))

# A tibble: 8 x 4
# Groups:   aired_us [2]
  aired_us series     n prop_bakers
  <lgl>    <fct>  <int>       <dbl>
1 FALSE    1         10       0.217
2 FALSE    2         12       0.261
3 FALSE    3         12       0.261
4 FALSE    8         12       0.261
5 TRUE     4         13       0.265
6 TRUE     5         12       0.245
7 TRUE     6         12       0.245
8 TRUE     7         12       0.245
```{{3}}


`@script`
Count helpfully does an extra ungroup step for you. Let's say that after counting, we add a mutate to make a new column with the proportion of bakers in each series for the whole show. 

If we use count before mutate, our proportion is right: there are 95 bakers total, and 10.5% appeared in series 1. 

But if we instead used group by then summarize, the result might be surprising! This is because our tibble is still grouped, which you can see on the right.


---
## Count also ungroups for you

```yaml
type: "TwoColumns"
key: "e9da2f2726"
disable_transition: true
```

`@part1`
```{r}
bakers %>% 
  count(aired_us, series) %>% 
  mutate(prop_bakers = n/sum(n))
```
```
# A tibble: 8 x 4
  aired_us series     n prop_bakers
  <lgl>    <fct>  <int>       <dbl>
1 FALSE    1         10       0.105
2 FALSE    2         12       0.126
3 FALSE    3         12       0.126
4 FALSE    8         12       0.126
5 TRUE     4         13       0.137
6 TRUE     5         12       0.126
7 TRUE     6         12       0.126
8 TRUE     7         12       0.126
```


`@part2`
```{r}
bakers %>% 
  group_by(aired_us, series) %>% 
  summarize(n = n()) %>% 
  ungroup() %>% 
  mutate(prop_bakers = n/sum(n))

# A tibble: 8 x 4
  aired_us series     n prop_bakers
  <lgl>    <fct>  <int>       <dbl>
1 FALSE    1         10       0.105
2 FALSE    2         12       0.126
3 FALSE    3         12       0.126
4 FALSE    8         12       0.126
5 TRUE     4         13       0.137
6 TRUE     5         12       0.126
7 TRUE     6         12       0.126
8 TRUE     7         12       0.126
```{{1}}


`@script`
To get the answer we are after here, we would need to add an ungroup before the mutate. This ensures that the denominator is as expected. 

Comparing the code on the left and the right, they both do the same thing, but the left is more straightforward and easier to read.


---
## Count to roll up a level

```yaml
type: "TwoColumns"
key: "94aade05f1"
```

`@part1`
```{r}
bakers %>% 
  count(aired_us, series) 
```
```
# A tibble: 8 x 3
  aired_us series     n
  <lgl>    <fct>  <int>
1 FALSE    1         10
2 FALSE    2         12
3 FALSE    3         12
4 FALSE    8         12
5 TRUE     4         13
6 TRUE     5         12
7 TRUE     6         12
8 TRUE     7         12
```


`@part2`
```{r}
bakers %>% 
  count(aired_us, series) %>% 
  count(aired_us)
```{{1}}
```
# A tibble: 2 x 2
  aired_us    nn
  <lgl>    <int>
1 FALSE        4
2 TRUE         4
```{{2}}


`@script`
What if we want to know how many series have aired in the US? 
To answer this question, we don't care about the number of bakers in the far right column- we only care about the first two columns here.  

To just count the number of series that aired in the US, ignoring the number of bakers, we can "count" by the same variable twice to roll up a level. 

The output here has only two rows, one for when aired underscore US is FALSE and one for when it is TRUE. The column named "nn" is the number of series that aired in the US and the number that did not. This second "count" ignores the values in the "n" column that we see on the left. 

Now we know that there has been an even split so far! US viewers have seen only half of the series aired in the UK.


---
## Let's get to work!

```yaml
type: "FinalSlide"
key: "d94d805efa"
```

`@script`
Now it's time to practice your counting skills with our bakeoff data!

