---
title: 'Introduction to cohorts and to analyzing them'
description: 'In this chapter we will cover the basics of what a cohort is, an approach to analyzing cohort data, and some first steps in exploring the data. You''ll also learn what type of data values to be aware of and to consider when dealing with cohort datasets.'

output: learnr::tutorial
runtime: shiny_prerendered
---

```{r setup, include=FALSE}
library(learnr)
knitr::opts_chunk$set(echo = FALSE)
```

## Introduction to cohort studies










fd067459a73b16863b609297f96ac32c



## What makes it a cohort?









The Framingham cohort was set up to study what factors may influence the risk of cardiovascular disease (CVD). People from the town of Framingham, USA were recruited and followed over time. Data was collected on risk factors and CVD outcomes every few years.

The `framingham` dataset has been loaded for you to *optionally* explore, however, do note that the dataset has not yet been tidied. We'll go through tidying it in Chapter 2.

What specifically distinguishes the Framingham study as a *cohort*?


- It studies a disease (CVD).
- Participants all came from the town of Framingham, USA.
- Participants were followed over time.
- Participants had risk factors measured.

<div id="what-makes-it-a-cohort-hint">
- Cohorts are people who have *something in common*.
</div>

```{r what-makes-it-a-cohort-setup}
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
framingham$time <- NULL
```


```{r what-makes-it-a-cohort-check}
msg1 <- "Almost, but incorrect. Many types of scientific studies study a disease, but that alone doesn't distinguish them as a cohort study."
msg2 <- "Correct! Cohorts are people who share a common characteristic. In this case, the participants come from the same town and so have a similar environment."
msg3 <- "Almost, but incorrect. Many types of scientific studies follow their subjects over time (e.g. clinical trials), but that alone doesn't distinguish them as a cohort study."
msg4 <- "Incorrect. Many types of scientific studies measure risk factors, but that alone doesn't distinguish them as a cohort."
ex() %>% check_mc(2, feedback_msgs = c(msg1, msg2, msg3, msg4))
```



## What cohort type is the Framingham Heart Study?







It's usually possible to determine the cohort design from the variables within the dataset. There are at least two variables in the Framingham Heart study that give us some indication of the cohort design. Recall that cohorts involve a data collection *period*.

The `dplyr` package has been loaded, as well as the `framingham` dataset. Again, note that `framingham` has not yet been tidied up, which we will do later in the course.


```{r what-cohort-type-is-the-framingham-heart-study-setup}
library(dplyr)
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
framingham$time <- NULL
```


```{r what-cohort-type-is-the-framingham-heart-study, exercise=TRUE, exercise.setup='what-cohort-type-is-the-framingham-heart-study-setup'}
# Check out the variable names
names(framingham)

# Select two columns that indicate design
framingham %>% 
    select(_____, _____)
```

### 







**Instructions**:
- Familiarize yourself with the variables in the `framingham` dataset.
- Select the two variables that give the *most* indication on `framingham`'s cohort design.

<div id="what-cohort-type-is-the-framingham-heart-study-hint">
- The Framingham cohort was designed to study the disease `cvd`.
</div>

```{r what-cohort-type-is-the-framingham-heart-study, exercise=TRUE, exercise.setup='what-cohort-type-is-the-framingham-heart-study-setup'}
# Check out the variable names
names(framingham)

# Select the two columns that indicate design
framingham %>% 
    select(___, ___)
```


```{r what-cohort-type-is-the-framingham-heart-study-solution}
# Check out the variable names
names(framingham)

# Select two columns that indicate design
framingham %>% 
    select(period, cvd)
```


```{r what-cohort-type-is-the-framingham-heart-study-check}
"Great!"
```

### 








What is Framingham's cohort design? Remember, *when* the disease occurs is what distinguishes prospective from retrospective cohorts.


- Prospective.
- Retrospective.
- Neither.
- Both.

<div id="what-cohort-type-is-the-framingham-heart-study-hint">
- The study was designed to investigate how people *develop* CVD over time (i.e. they don't have the disease when the study starts).
</div>

```{r what-cohort-type-is-the-framingham-heart-study-check}
msg1 = "Correct."
msg2 = "Incorrect. Participants enter the study with a disease. In Framingham, participants did not have the disease."
msg3 = "Incorrect."
msg4 = "Incorrect. It can't be both!"
ex() %>% check_mc(1, feedback_msgs = c(msg1, msg2, msg3, msg4))
"Nice job! You've identified that period (the time component) and CVD (the disease) tell us that Framingham is a prospective cohort design!"
```



## Cohort types, variables, and the Framingham Study










9e3d8b35b89128ebb91908d3aa815cf1



## Select the outcome and some exposures









To properly analyze the data you need to know what each variable represents. Usually it's fairly easy to identify the outcome (the disease). However, knowing which variables are potential exposures to investigate can be tricky, since modern cohort studies often measure hundreds of variables on each participant. 

Initially, it can be helpful to keep only the variables of interest. For now, select a few interesting variables, renaming them so they are more descriptive, and exploring them more.

**Instructions**:
- Run `names(framingham)` in the console to find the exact names of the variables. 
- Choose the correct outcome for cardiovascular disease (CVD). Rename it to `got_cvd`.
- Rename the three predictors to `total_cholesterol`, `body_mass_index` and `currently_smokes`.
- Rename the `period` variable to `followup_visit_number`.

<div id="select-the-outcome-and-some-exposures-hint">
- Rename `bmi` to `body_mass_index`, `totchol` to `total_cholesterol`, and `cursmoke` to `currently_smokes`.
</div>

```{r select-the-outcome-and-some-exposures-setup}
library(dplyr)
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
```


```{r select-the-outcome-and-some-exposures, exercise=TRUE, exercise.setup='select-the-outcome-and-some-exposures-setup'}
# Select and rename the potential predictors and outcome
explore_framingham <- framingham %>%
    select(
        # Format: new_variable_name = old_variable_name
        # Outcome
        _____ = cvd,
        # Predictors
        _____ = totchol,
        _____ = bmi,
        _____ = cursmoke,
        # Visit number
        _____ = period 
    )
explore_framingham
```


```{r select-the-outcome-and-some-exposures-solution}
# Select and rename the potential predictors and outcome
explore_framingham <- framingham %>%
    select(
        # Format: new_variable_name = old_variable_name
        # Outcome
        got_cvd = cvd,
        # Predictors
        total_cholesterol = totchol,
        body_mass_index = bmi,
        currently_smokes = cursmoke,
        # Visit number
        followup_visit_number = period 
    )
explore_framingham
```


```{r select-the-outcome-and-some-exposures-check}
"Great job! You've selected and renamed the variables correctly."
```



## Simple summary of the exposures by outcome







Getting some simple summaries of the exposures by those with and without the disease should be done early in any analysis of cohort datasets. Even more so when there is a time component to the study, so you can identify how variables change over time or are different between groups.

Using what was shown in the video, calculate some means based on some groupings.

**Instructions**:
- Group the data by `followup_visit_number` and `got_cvd` using the `dplyr` function `group_by()`.
- Calculate the mean for `body_mass_index`, `currently_smokes`, and `total_cholesterol`  using `summarize()` and `mean()`.
- Make sure that `mean()` drops `NA` values by setting the `na.rm` argument to `TRUE`.

<div id="simple-summary-of-the-exposures-by-outcome-hint">
- Use `na.rm = TRUE` with `mean()` to exclude `NA` from the mean calculation.
</div>

```{r simple-summary-of-the-exposures-by-outcome-setup}
library(dplyr)
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
explore_framingham <- framingham %>%
    select(
        got_cvd = cvd,
        total_cholesterol = totchol,
        body_mass_index = bmi,
        currently_smokes = cursmoke,
        followup_visit_number = period
    )
```


```{r simple-summary-of-the-exposures-by-outcome, exercise=TRUE, exercise.setup='simple-summary-of-the-exposures-by-outcome-setup'}
explore_framingham %>% 
    # Group by visit and CVD status
    group_by(___, ___) %>% 
    # Mean of body mass, smoking, and cholesterol
    summarize(
        body_mass_mean = mean(___, na.rm = ___),
        smokes_mean = ___,
        cholesterol_mean = ___
    )
```


```{r simple-summary-of-the-exposures-by-outcome-solution}
explore_framingham %>% 
    # Group by visit and CVD status
    group_by(followup_visit_number, got_cvd) %>% 
    # Mean of body mass, smoking, and cholesterol
    summarize(
        body_mass_mean = mean(body_mass_index, na.rm = TRUE),
        smokes_mean = mean(currently_smokes, na.rm = TRUE),
        cholesterol_mean = mean(total_cholesterol, na.rm = TRUE)
    )
```


```{r simple-summary-of-the-exposures-by-outcome-check}
"Awesome! You learned how to compare the difference in some basic predictors in those who did and did not get CVD over the study duration."
```



## Prevalence and incidence in cohorts










d8b40a3d5d81b2b050f65eb79581aa42



## Count number of participants and cases per visit







Here, you will count the number of cases and non-cases for both prevalent myocardial infarction (MI), or `prevalent_mi`, and coronary heart disease (CHD), or `prevalent_chd`, at each visit. Remember, for longitudinal data, like that in prospective cohorts, you need to count by the time period since each participant will have several rows for each of the data collection visits.

Both `dplyr` and `tidyr` are loaded and all variables have been added back into `explore_framingham`.


```{r count-number-of-participants-and-cases-per-visit-setup}
library(dplyr)
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
explore_framingham <- framingham %>%
    rename(
        got_cvd = cvd, 
        total_cholesterol = totchol,
        body_mass_index = bmi,
        currently_smokes = cursmoke,
        followup_visit_number = period,
        prevalent_chd = prevchd,
        prevalent_mi = prevmi
    )
```


```{r count-number-of-participants-and-cases-per-visit, exercise=TRUE, exercise.setup='count-number-of-participants-and-cases-per-visit-setup'}
# Count number of participants per visit
explore_framingham %>%
    count(___)
```

### 







**Instructions**:
- Use `count()` to find the number of participants at each `followup_visit_number`.

<div id="count-number-of-participants-and-cases-per-visit-hint">
- The code is `count(followup_visit_number)`.
</div>

```{r count-number-of-participants-and-cases-per-visit, exercise=TRUE, exercise.setup='count-number-of-participants-and-cases-per-visit-setup'}
# Count number of participants per visit
explore_framingham %>%
    count(___)
```


```{r count-number-of-participants-and-cases-per-visit-solution}
# Count number of participants per visit
explore_framingham %>% 
    count(followup_visit_number)
```


```{r count-number-of-participants-and-cases-per-visit-check}
"Great!"
```

### 







**Instructions**:
- Count the number of participants with `prevalent_mi` at each `followup_visit_number`.

<div id="count-number-of-participants-and-cases-per-visit-hint">
- Include both variables in `count()`, separated by a comma.
</div>

```{r count-number-of-participants-and-cases-per-visit, exercise=TRUE, exercise.setup='count-number-of-participants-and-cases-per-visit-setup'}
explore_framingham %>% 
    count(followup_visit_number)

# Count by visit, then prevalent cases of MI
explore_framingham %>% 
    count(___, ___)
```


```{r count-number-of-participants-and-cases-per-visit-solution}
explore_framingham %>% 
    count(followup_visit_number)

# Count by visit, then prevalent cases of MI
explore_framingham %>% 
    count(followup_visit_number, prevalent_mi)
```


```{r count-number-of-participants-and-cases-per-visit-check}
"Amazing!"
```

### 







**Instructions**:
- Lastly, do the same thing for `prevalent_chd`.

<div id="count-number-of-participants-and-cases-per-visit-hint">
- Use the same syntax as for the `prevalent_mi` code.
</div>

```{r count-number-of-participants-and-cases-per-visit, exercise=TRUE, exercise.setup='count-number-of-participants-and-cases-per-visit-setup'}
explore_framingham %>% 
    count(followup_visit_number)

explore_framingham %>% 
    count(followup_visit_number, prevalent_mi)

# Count by visit, then prevalent cases of CHD
explore_framingham %>% 
    count(___, ___)
```


```{r count-number-of-participants-and-cases-per-visit-solution}
explore_framingham %>% 
    count(followup_visit_number)

explore_framingham %>% 
    count(followup_visit_number, prevalent_mi)

# Count by visit, then prevalent cases of CHD
explore_framingham %>% 
    count(followup_visit_number, prevalent_chd)
```


```{r count-number-of-participants-and-cases-per-visit-check}
"Woohoo! Nice job. You now know how to count the number of cases by visit."
```



## Remove prevalent cases at the baseline







From the previous exercise, we know that there are prevalent cases of cardiovascular events at the first visit. Prevalent cases of disease at the recruitment visit can introduce bias, so we need to remove these cases before continuing with any further analyses.

**Instructions**:
- Exclude (with `!`) observations where `followup_visit_number` is equal to 1 *and* where `prevalent_chd` is equal to 1.
- Count the number of observations to make sure that patients with CHD at the first visit were dropped.

<div id="remove-prevalent-cases-at-the-baseline-hint">
- Filtering logic has the form `variable == condition`, for instance `followup_visit_number == 1`.
</div>

```{r remove-prevalent-cases-at-the-baseline-setup}
library(dplyr)
load(url("https://assets.datacamp.com/production/repositories/2079/datasets/8ebd3fc8dc74530ce5a24fe07bca6abf380f9e62/framingham.rda"))
explore_framingham <- framingham %>%
    rename(
        got_cvd = cvd, 
        total_cholesterol = totchol,
        body_mass_index = bmi,
        participant_age = age,
        currently_smokes = cursmoke,
        followup_visit_number = period,
        prevalent_chd = prevchd,
        prevalent_mi = prevmi
    )
```


```{r remove-prevalent-cases-at-the-baseline, exercise=TRUE, exercise.setup='remove-prevalent-cases-at-the-baseline-setup'}
# Drop prevalent chd cases from first visit
no_prevalent_cases <- explore_framingham %>% 
    filter(!(___ == ___ & ___ == ___)) 

# Confirm the number by counting visit then chd cases
no_prevalent_cases %>% 
    count(___, ___) 
```


```{r remove-prevalent-cases-at-the-baseline-solution}
# Drop prevalent chd cases from first visit
no_prevalent_cases <- explore_framingham %>% 
    filter(!(followup_visit_number == 1 & prevalent_chd == 1)) 

# Confirm the number by counting visit then chd cases
no_prevalent_cases %>% 
    count(followup_visit_number, prevalent_chd) 
```


```{r remove-prevalent-cases-at-the-baseline-check}
"Excellent! You've dropped baseline prevalent cases of CHD and started making sure that you've reduced bias in the final results!"
```
