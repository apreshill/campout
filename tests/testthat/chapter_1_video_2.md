---
title: Cohort types, variables, and the Framingham Study
key: 9e3d8b35b89128ebb91908d3aa815cf1

---
## Cohort types, variables, and the Framingham Study

```yaml
type: "TitleSlide"
key: "26a03a5d84"
```

`@lower_third`

name: Luke Johnston
title: Diabetes epidemiologist


`@script`
Before we get more into Framingham, we'll cover some more differences between the two cohort types. Since Framingham is a prospective cohort, I'll also highlight why I chose a prospective cohort over a retrospective one for this course.


---
## Comparisons between the two study designs

```yaml
type: "FullSlide"
key: "583fae4d2d"
```

`@part1`
![Retrospective vs prospective cohorts. ](https://assets.datacamp.com/production/repositories/2079/datasets/a183894d11c7317da3f4831b9e6b75cb4929942d/pro-vs-retro.png)


`@citations`
Source from DOI: 10.1159/000235241


`@script`
In the previous video, we covered how the main difference between the study types were related to when the outcome occurs relative to the study start. In retrospective cohorts, people have the disease at the start and their data is collected from past records. They are often used when data has been collected in a frequent or consistent manner, such as in hospital settings, or is easily available. 

In prospective cohorts, people don't have a disease when the study begins. They are then followed over time until the study end, with data collected throughout. Both designs have their strengths and weaknesses. The strengths from prospective cohorts, however, provide stronger scientific evidence, because people are recruited without the disease. Which is why the Framingham study is used for this course.


---
## How a prospective cohort looks over time

```yaml
type: "FullImageSlide"
key: "b7cc4ddc54"
```

`@part1`
![Visual example of a prospective cohort](https://assets.datacamp.com/production/repositories/2079/datasets/b5ecf50ee5eb89363a736373c556732dff9b0f59/ch1-v2-prospective-outcome.png)


`@script`
Here's a graphic showing how a cohort study may look like. In this graph, each line is a hypothetical participant. At the beginning, no one has a disease. As time passes, some people get the disease while others don't. When the study ends, or when the analysis is conducted, there will be a group of people who have the disease, shown here in orange, and a lot more who don't, shown here in blue. Data is collected at several time points over the study duration. You can then compare how these two groups of people differ. What factors distinguish those with and without the disease? That is what we try to answer when we analyze the data.


---
## Main variables of interest

```yaml
type: "FullSlide"
key: "278d9126a9"
```

`@part1`
- *Outcome*: {{1}}
    - Disease or health state (e.g. cancer)
    - Commonly shown as the $y$ in regression analysis

- *Exposure/predictor*: {{2}}
    - Variable hypothesized to relate to a disease (e.g. tobacco smoking)
    - Commonly shown as the $x$ in regression analysis


`@script`
In cohort studies, there are commonly two terms used, outcome and exposure or predictor. 

The term outcome is used to mean the disease and it is the y or dependent variable commonly seen in statistical notation.

The term exposure or predictor represents the variables that relate to or potentially influence the outcome in some way. These are the variables that we think may predict whether someone gets the disease, for example, with cigarette smoking and lung cancer.


---
## Follow-up time in the prospective Framingham cohort

```yaml
type: "FullSlide"
key: "77bd85b3d8"
```

`@part1`
```{r}
library(dplyr)
framingham %>%
    select(followup_visit_number = period, days_of_followup = time)
    summarise(number_visits = max(followup_visit_number),
              number_years = round(max(days_of_followup) / 365, 1))
```
{{1}}

```
# A tibble: 1 x 2
  number_visits number_years
          <dbl>        <dbl>
1             3         13.3
```
{{2}}


`@script`
Let's look at the Framingham data now and determine some simple descriptions about the duration of the study and number of visits. We'll use the dplyr package to select and rename the two time variables. One is visit number and the other is days since recruitment. Then we pipe the data into summarize to calculate the maximum number of visits and years of followup, converted from days. 

In the Framingham study there were a maximum three visits over up to 13 years of follow-up.


---
## Number of participants at each visit in Framingham

```yaml
type: "FullSlide"
key: "8155410b68"
```

`@part1`
```{r}
framingham %>% 
    select(followup_visit_number = period) %>% 
    group_by(followup_visit_number) %>% 
    summarise(number_participants = n())
```
{{1}}

```{r}
# A tibble: 3 x 2
  followup_visit_number number_participants
                  <int>               <int>
1                     1                4434
2                     2                3930
3                     3                3263
```
{{2}}


`@script`
Next, let's see how many participants came to each visit. Again, we'll use select to keep and rename the visit number variable. Then we use the group-underscore-by function to then calculate the number of participants at each visit using summarize with the n function.

More than four thousand participants were recruited, quite a large study!


---
## "Untidy" variable names in Framingham

```yaml
type: "FullSlide"
key: "fd098b73b9"
```

`@part1`
```{r}
names(framingham)
```
{{1}}

```
 [1] "randid"   "sex"      "totchol"  "age"      "sysbp"   
 [6] "diabp"    "cursmoke" "cigpday"  "bmi"      "diabetes"
[11] "bpmeds"   "heartrte" "glucose"  "educ"     "prevchd" 
[16] "prevap"   "prevmi"   "prevstrk" "prevhyp"  "time"    
[21] "period"   "hdlc"     "ldlc"     "death"    "angina"  
[26] "hospmi"   "mi_fchd"  "anychd"   "stroke"   "cvd"     
[31] "hyperten" "timeap"   "timemi"   "timemifc" "timechd" 
[36] "timestrk" "timecvd"  "timedth"  "timehyp" 
```
{{1}}


`@script`
Looking at Framingham, we quickly see there are many things that aren't tidy. For instance, look at the variable randid. What does it mean? We can't immediately tell, because it isn't clearly communicated. We'll have to tidy the data up as we explore it.


---
## Lesson summary

```yaml
type: "FullSlide"
key: "75da8bcc42"
```

`@part1`
- Design types {{1}}
    - Prospective: No disease, data collected as time passes
    - Retrospective: Disease at start, data obtained from past records
- Variables of interest {{2}}
    - Outcome: The disease 
    - Exposure/predictor: Factor that may influence the outcome
- Framingham: {{3}}
    - 3 visits, > 13 years follow up
    - ~ 4400 participants


`@script`
In summary, we compared that prospective and retrospective studies differ in when the disease occurs, defined the terms outcome and exposure or predictor, and took a quick look at the data.


---
## Let's practice and explore the dataset!

```yaml
type: "FinalSlide"
key: "ddbf9a5e1a"
```

`@script`
Let's practice on the dataset!

