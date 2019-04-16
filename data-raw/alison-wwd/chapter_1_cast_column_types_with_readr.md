---
title: Cast Column Types
key: 86d6aef57ef874954a2d2f82892a7915
video_link:
    hls: https://s3.amazonaws.com/videos.datacamp.com/transcoded/6012_working_with_data_in_the_tidyverse/v1/hls-6012_ch2_1.master.m3u8
    mp4: https://s3.amazonaws.com/videos.datacamp.com/transcoded_mp4/6012_working_with_data_in_the_tidyverse/v1/6012_ch2_1.mp4
transformations:
    translateX: 55
    translateY: 0
    scale: 1

---
## Cast Column Types

```yaml
type: "TitleSlide"
key: "7a743550f6"
```

`@lower_third`

name: Alison Hill
title: Professor & Data Scientist


`@script`
What does it mean to tame your data? 

To start, we'll learn how to convert variable types when reading data, so that the variable type stored in R matches the values. This is called type casting, and it is an important step in taming your data.


---
## Why bother?

```yaml
type: "TwoColumns"
key: "3f1472e912"
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/5c4dfc48def6a42b29bdd48e2caccfd1139b2357/shutterstock_cast1.jpg){{1}}


`@part2`
![](https://assets.datacamp.com/production/repositories/1613/datasets/443e7c33beba693224527b5fb75d793dda968e81/shutterstock_cast2.jpg){{2}}


`@script`
Casting column types when you import your data will save you time and pain in the future. It is like the difference between baking in the kitchen on the left versus on the right. 

All wrangling, analyses, and plotting will be easier when you start with a tame data frame. Knowing and setting your column types in your R scripts will help you do that.


---
## The readr package

```yaml
type: "FullSlide"
key: "15a4d876dc"
```

`@part1`
```
library(readr) # once per work session
```

![](http://s3.amazonaws.com/assets.datacamp.com/production/course_6012/datasets/readr.png)


`@citations`
- http://readr.tidyverse.org


`@script`
We'll use the readr package again, this time adding the col underscore types argument to do the type casting for us.


---
## read_csv

```yaml
type: "FullSlide"
key: "0e2e53f576"
```

`@part1`
```{r}
?read_csv
```

**Usage**{{1}}

```
read_csv(file, col_names = TRUE, col_types = NULL,
  locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
  quote = "\"", comment = "", trim_ws = TRUE, skip = 0, n_max = Inf,
  guess_max = min(1000, n_max), progress = show_progress())
```{{1}}


`@script`
We have used other arguments for read underscore csv, like skip and na. You can see that the default argument for col underscore types is NULL.


---
## The col_types argument

```yaml
type: "FullSlide"
key: "be063d0a1d"
```

`@part1`
**Arguments**

![](https://assets.datacamp.com/production/repositories/1613/datasets/6efafd8fa01f3dde111369f67709397b0182cb4a/01.02_readcsv_coltypes.png)


`@script`
If we leave the default, all column types are guessed from the first 1000 rows. This usually works, but sometimes we know our data better!


---
## bakers_tame

```yaml
type: "FullSlide"
key: "cbcef4b678"
```

`@part1`
```{r}
bakers_tame
```{{1}}
```
# A tibble: 10 x 6
   series baker        age num_episodes aired_us last_date_uk
    <dbl> <chr>      <dbl>        <dbl> <lgl>    <date>      
 1     3. Natasha      36.           1. FALSE    2012-08-14  
 2     3. Sarah-Jane   28.           7. FALSE    2012-09-25  
 3     3. Cathryn      27.           8. FALSE    2012-10-02  
 4     4. Lucy         38.           2. TRUE     2013-08-27  
 5     4. Howard       51.           6. TRUE     2013-09-24  
 6     4. Beca         31.           9. TRUE     2013-10-15  
 7     4. Kimberley    30.          10. TRUE     2013-10-22  
 8     5. Enwezor      39.           2. TRUE     2014-08-13  
 9     5. Jordan       32.           3. TRUE     2014-08-20  
10     5. Iain         31.           4. TRUE     2014-08-27  
```{{2}}


`@script`
Here is the tame version of the bakers data:

- series, age, and number of episodes are numbers
- baker is a character, 
- aired_us is a logical, 
- and last date uk is a date.

Now let's take a look at the raw variable types, before type casting.


---
## Tame versus raw bakers

```yaml
type: "FullSlide"
key: "d78951a9e7"
disable_transition: true
```

`@part1`
```{r}
bakers_tame %>% dplyr::slice(1:4) 
```
```
# A tibble: 4 x 6
  series baker        age num_episodes aired_us last_date_uk
   <dbl> <chr>      <dbl>        <dbl> <lgl>    <date>      
1     3. Natasha      36.           1. FALSE    2012-08-14  
2     3. Sarah-Jane   28.           7. FALSE    2012-09-25  
3     3. Cathryn      27.           8. FALSE    2012-10-02  
4     4. Lucy         38.           2. TRUE     2013-08-27  
```

```{r}
bakers_raw %>% dplyr::slice(1:4) 
```{{1}}
```
# A tibble: 4 x 6
  series baker      age      num_episodes aired_us last_date_uk     
   <dbl> <chr>      <chr>           <dbl>    <dbl> <chr>            
1     3. Natasha    36 years           1.       0. 14 August 2012   
2     3. Sarah-Jane 28 years           7.       0. 25 September 2012
3     3. Cathryn    27 years           8.       0. 2 October 2012   
4     4. Lucy       38 years           2.       1. 27 August 2013  
```{{1}}


`@script`
Let's take a slice of the first four rows to compare. 

The raw age variable in the bottom slice is a character. Why? Because the word years appears after each number.

How can we cast this variable to a number?


---
## parse_number

```yaml
type: "FullSlide"
key: "535478d474"
disable_transition: true
```

`@part1`
```{r}
bakers_raw %>% dplyr::slice(1:4)
```
```
# A tibble: 4 x 6
  series baker      age      num_episodes aired_us last_date_uk     
   <dbl> <chr>      <chr>           <dbl>    <dbl> <chr>            
1     3. Natasha    36 years           1.       0. 14 August 2012   
2     3. Sarah-Jane 28 years           7.       0. 25 September 2012
3     3. Cathryn    27 years           8.       0. 2 October 2012   
4     4. Lucy       38 years           2.       1. 27 August 2013 
```

```{r}
parse_number("36 years")

[1] 36
```{{1}}


`@script`
We start by parsing the variable first. readr has several parsing functions, where the column type you want goes after the underscore. 

Using parse underscore number, we can view the string "36 years" as a number instead.


---
## From parsing to casting

```yaml
type: "FullSlide"
key: "6c4f59cfb6"
disable_transition: true
```

`@part1`
```{r}
parse_number("36 years")
```
```
[1] 36
```

```{r}
bakers_tame <- read_csv(file = "bakers.csv",
                         col_types = cols(age = col_number())
                        )

bakers_tame %>% slice(1:4)

# A tibble: 4 x 6
  series baker        age num_episodes aired_us last_date_uk     
   <dbl> <chr>      <dbl>        <dbl> <lgl>    <chr>            
1     3. Natasha      36.           1. FALSE    14 August 2012   
2     3. Sarah-Jane   28.           7. FALSE    25 September 2012
3     3. Cathryn      27.           8. FALSE    2 October 2012   
4     4. Lucy         38.           2. TRUE     27 August 2013
```{{1}}


`@script`
Now that we know we can parse that string as a number, we can cast the whole column in the tibble to numeric using col underscore types.

The column name goes on the left, and the column type to cast, like col underscore number, goes on the right.

Now our age variable is a number.

But notice that the last underscore date underscore uk variable also needs taming. Let's parse, then cast this variable next.


---
## parse_date

```yaml
type: "FullSlide"
key: "aa081fe119"
disable_transition: true
```

`@part1`
```{r}
bakers_tame %>% dplyr::slice(1:4)
```
```
# A tibble: 4 x 6
  series baker        age num_episodes aired_us last_date_uk     
   <dbl> <chr>      <dbl>        <dbl> <lgl>    <chr>            
1     3. Natasha      36.           1. FALSE    14 August 2012   
2     3. Sarah-Jane   28.           7. FALSE    25 September 2012
3     3. Cathryn      27.           8. FALSE    2 October 2012   
4     4. Lucy         38.           2. TRUE     27 August 2013 
```

```{r}
?parse_date
```{{1}}


`@script`
Parsing a date is a little trickier.

Dates have a day, month, and year. But there could be dashes or slashes instead of spaces, year could be listed first instead of last, and months could be abbreviated or numeric. 

The help documents for this parsing function provide a key for specifying your date format. 

These help documents are shared for the family of readr functions for parsing dates and times.


---
## Format the day

```yaml
type: "FullSlide"
key: "bbf5d9e114"
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/c468f20f3e11a925e3826899d178e39d5a9900b8/01.02_parse_date_day.png)

```{r}
parse_date("14 August 2012", format = "%d ___ ___")
```{{2}}


`@script`
Following this key, we parse this date from left to right with % lower-case d for day.


---
## Format the month

```yaml
type: "FullSlide"
key: "9872895858"
disable_transition: true
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/ff0ad095f8940ec55c3429ceb17fa5ad2309b52f/01.02_parse_date_month.png)

```{r}
parse_date("14 August 2012", format = "%d %B ___")
```{{1}}


`@script`
% upper-case B for month, which needs to be spelled out.


---
## Format the year

```yaml
type: "FullSlide"
key: "6f3be0a265"
disable_transition: true
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/8b940c1e7513f862f74f8cb3e546d2e84d41a1b2/01.02_parse_date_year.png)

```{r}
parse_date("14 August 2012", format = "%d %B %Y")
```{{1}}
```
[1] "2012-08-14"
```{{2}}


`@script`
And finally % upper-case Y for the 4-digit year.

We also have spaces in between each date element, but other separators like dashes and slashes can also be used.

Now that we can parse this date, we can cast the variable to a date.


---
## Parse & cast `last_date_uk`

```yaml
type: "FullSlide"
key: "1140218432"
```

`@part1`
```{r}
bakers <- read_csv("bakers.csv",
                   col_types = cols(
                     last_date_uk = col_date(format = "%d %B %Y")
                   ))
```{{3}}
```
# A tibble: 10 x 6
   series baker        age num_episodes aired_us last_date_uk
    <dbl> <chr>      <dbl>        <dbl> <lgl>    <date>      
 1     3. Natasha      36.           1. FALSE    2012-08-14  
 2     3. Sarah-Jane   28.           7. FALSE    2012-09-25  
 3     3. Cathryn      27.           8. FALSE    2012-10-02  
 4     4. Lucy         38.           2. TRUE     2013-08-27  
 5     4. Howard       51.           6. TRUE     2013-09-24  
 6     4. Beca         31.           9. TRUE     2013-10-15  
 7     4. Kimberley    30.          10. TRUE     2013-10-22  
 8     5. Enwezor      39.           2. TRUE     2014-08-13  
 9     5. Jordan       32.           3. TRUE     2014-08-20  
10     5. Iain         31.           4. TRUE     2014-08-27  
```{{4}}


`@script`
Notice that the column type is date, and all the values in the column are re-formatted as Year-Month-Day with integers.


---
## Parse functions in readr

```yaml
type: "FullSlide"
key: "b36121d2dc"
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/31eef34367115f03e811440ebb3ba8f6e786f8e3/02.01_glimpse_parse_cast.png)


`@script`
For every column type, there is a `parse_*()` function and a `col_*()` function. If you want to change any column type, you can practice using the `parse()` function with a character vector.

In this video, we used parse number and parse date, but there is a way to parse any variable type using this workflow.


---
## Let's get to work!

```yaml
type: "FinalSlide"
key: "3fb527781d"
assignment: "![](https://assets.datacamp.com/production/repositories/1613/datasets/12ac6b9c22c52be5c214b33c8595cf37bbf62bb1/shutterstock_cast3.jpg)"
```

`@script`
Now let's get to work casting some column types!

