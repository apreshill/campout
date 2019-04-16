---
title: Import Your Data
key: 5db22793e6d4becbe4b19772996c6c1d
video_link:
    hls: https://s3.amazonaws.com/videos.datacamp.com/transcoded/6012_working_with_data_in_the_tidyverse/v1/hls-6012_ch1_1.master.m3u8
    mp4: https://s3.amazonaws.com/videos.datacamp.com/transcoded_mp4/6012_working_with_data_in_the_tidyverse/v1/6012_ch1_1.mp4
transformations:
    translateX: 55
    translateY: 0
    scale: 1

---
## Import Your Data

```yaml
type: TitleSlide
key: 45b5e05a2c
```

`@lower_third`
name: Alison Hill
title: Professor & Data Scientist

`@script`

Hi, I'm Alison Hill and I'll be your instructor. This course will introduce you to more data science tools from the tidyverse to help you work with your data better using the R programming language. 

---
## 

```yaml
type: FullSlide
key: e0fcf7f7f1
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/b6de6540346be4a0413831f8337cf1be072c5c2b/01.01_tidyverse_wrangle.png)

`@script`

You'll learn to explore, tame, tidy, and transform your data in R. We'll start at the beginning of the data science pipeline by reading data into R, which is an important first step to working with your own data.

`@citations`

- R for Data Science (http://r4ds.had.co.nz/wrangle-intro.html)


---
## Rectangular data 

```yaml
type: FullSlide
key: 552480588d
```

`@part1`

![](https://assets.datacamp.com/production/repositories/1613/datasets/919dd3b06350ece34054f795d7b65559bc3d4ec2/01.01_rectangle_cols.png)

`@script`

We'll focus on reading rectangular data into R. In rectangular data, columns hold variables like "series" and "baker". Here, column names are in the first row. Each column holds different kinds of data, like numbers, characters, or dates.  

---
## Rectangular data 

```yaml
type: FullSlide
key: 64042772bc
disable_transition: TRUE
```

`@part1`
![](https://assets.datacamp.com/production/repositories/1613/datasets/82c06c2bc6455d0a5c4cbd876303750a5b9768ab/01.01_rectangle_rows.png)

`@script`

Rows correspond to observations on an individual unit. Here the first row holds values corresponding to Natasha from series 3. We are looking at data from a popular television baking competition called "The Great British Bake Off." In it, amateur bakers compete against each other, facing different baking challenges that test their skills. Let's see how this looks in R as a tibble.

---
## Rectangular data in R

```yaml
type: FullSlide
key: 1683f78f8f
```

`@part1`

```{r}
bakers
```{{1}}
```
# A tibble: 10 x 6
   series baker        age num_episodes aired_us last_date_uk
   <dbl>  <chr>      <dbl>        <dbl> <lgl>    <date>      
 1 3      Natasha      36.           1. FALSE    2012-08-14  
 2 3      Sarah-Jane   28.           7. FALSE    2012-09-25  
 3 3      Cathryn      27.           8. FALSE    2012-10-02  
 4 4      Lucy         38.           2. TRUE     2013-08-27  
 5 4      Howard       51.           6. TRUE     2013-09-24  
 6 4      Beca         31.           9. TRUE     2013-10-15  
 7 4      Kimberley    30.          10. TRUE     2013-10-22  
 8 5      Enwezor      39.           2. TRUE     2014-08-13  
 9 5      Jordan       32.           3. TRUE     2014-08-20  
10 5      Iain         31.           4. TRUE     2014-08-27  
```{{2}}

`@script`

...First, this data has a name- "bakers".

When we call "bakers", a tibble with rows and columns is printed. A tibble is a special kind of data frame. Data frames are useful because column values in the same row correspond to the same observation. Don't be confused by the terms tibble and data frame- for this course, the most important thing to know is that they both store rectangular data in R.


---
## The readr package

```yaml
type: FullSlide
key: 15a4d876dc
```

`@part1`

```
library(readr) # once per work session
```

![](http://s3.amazonaws.com/assets.datacamp.com/production/course_6012/datasets/readr.png)

`@citations`

- http://readr.tidyverse.org 

`@script`

The readr package is for reading rectangular data into R. We'll use the read underscore csv function to read data from a CSV file, which stands for Comma Separated Values. This means that commas separate values within a row, and each row is a new observation. 



---
## Functions in R

```yaml
type: TwoColumns
key: 895efbb306
```

`@part1`

```{r}
recipe_name(ingredients)
```{{1}}

![](https://assets.datacamp.com/production/repositories/1613/datasets/e340fdc64bd4fd15c451b3bb8ec402d7d0c116dc/function_recipe.jpg)

`@part2`

```{r}
function_name(arguments)
```{{2}}

`@script`

Think of read underscore csv like a recipe...it tells R what to do and how to do it. But every recipe needs ingredients. In the same way, functions need arguments to work. Function arguments go within the parentheses. 

---
## The read_csv function

```yaml
type: FullSlide
key: 4836fc542f
```

`@part1`

```{r}
?read_csv
```{{1}}

![](http://s3.amazonaws.com/assets.datacamp.com/production/course_6012/datasets/01-readcsv_ref.png){{2}}

`@script`

How do you know which arguments to use? 

In your R console, you can type question mark, then the name of the function to see the help documents. Let's zoom in on usage first.

---


```yaml
type: FullSlide
key: 422c250b92
```

`@part1`

```{r}
?read_csv
```

Usage

```
read_csv(file, col_names = TRUE, col_types = NULL,
  locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
  quote = "\"", comment = "", trim_ws = TRUE, skip = 0, n_max = Inf,
  guess_max = min(1000, n_max), progress = show_progress())
```{{1}}

`@script`

Usage tells you the ingredients for this recipe. 

The first here is "file". Others have an argument name on the left, like col underscore names. An equals sign separates the argument name from the value on the right. read underscore csv will use these argument values unless you override them. The default values are sensible, so it is good practice to start experimenting with the arguments that don't have defaults first. We will start with the file argument, which has no default value and must be set.

---
## The file argument

```yaml
type: FullSlide
key: 2fd7ec25ae
```

`@part1`

```
?read_csv
```

![](http://s3.amazonaws.com/assets.datacamp.com/production/course_6012/datasets/01-readcsv_args.png)

`@script`

...After usage are the arguments. The file argument is a path to a file. We'll provide a single string, which means the path needs to be in quotes.

---

## Read the CSV file

```yaml
type: FullSlide
key: 27abd22c65
```

`@part1`

```{r}
bakers <- read_csv("bakers.csv")
```{{1}}
```{r}
Parsed with column specification:
cols(
  series = col_double(),
  baker = col_character(),
  age = col_double(),
  num_episodes = col_double(),
  aired_us = col_logical(),
  last_date_uk = col_date(format = "")
)
```{{2}}

`@script`

...We use the assignment operator to name this new object "bakers." The read underscore csv function goes on the right. The only argument is the name of the file in quotes. If your data and script are in the same directory, R will look for the named data file in that directory.

We'll dig deeper into this output in chapter two. But for now, readr was able to parse each column, which means we are ready to proceed. Let's look at the bakers data.

---
## Print bakers

```yaml
type: FullSlide
key: 9842699c60
```

`@part1`

```{r}
bakers

# A tibble: 10 x 6
   series baker        age num_episodes aired_us last_date_uk
   <dbl>  <chr>      <dbl>        <dbl> <lgl>    <date>      
 1 3      Natasha      36.           1. FALSE    2012-08-14  
 2 3      Sarah-Jane   28.           7. FALSE    2012-09-25  
 3 3      Cathryn      27.           8. FALSE    2012-10-02  
 4 4      Lucy         38.           2. TRUE     2013-08-27  
 5 4      Howard       51.           6. TRUE     2013-09-24  
 6 4      Beca         31.           9. TRUE     2013-10-15  
 7 4      Kimberley    30.          10. TRUE     2013-10-22  
 8 5      Enwezor      39.           2. TRUE     2014-08-13  
 9 5      Jordan       32.           3. TRUE     2014-08-20  
10 5      Iain         31.           4. TRUE     2014-08-27  
```{{1}}

`@script`

Typing bakers prints the tibble to our console. We see 10 observations of 6 columns, or variables. The column names, variable types, and values look right here- in the exercises, you'll see some examples of when these look wrong.

---
## Other functions and packages

```yaml
type: FullSlide
key: 6ea774885f
```

`@part1`

![](http://s3.amazonaws.com/assets.datacamp.com/production/course_6012/datasets/01.01_read_packages.png)

`@script`

The readr package has other functions to read in different rectangular file formats. There are also tidyverse packages like haven and readxl for reading in other file types.


---
## Let's practice!

```yaml
type: FinalSlide
key: 0701dcb4b7
```

`@script`

Now let's practice reading in a new csv file of the bakeoff data.
