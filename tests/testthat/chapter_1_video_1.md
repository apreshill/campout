---
title: Introduction to cohort studies
key: fd067459a73b16863b609297f96ac32c

---
## Introduction to cohort studies

```yaml
type: "TitleSlide"
key: "0e5ec8f7ed"
```

`@lower_third`

name: Luke Johnston
title: Diabetes epidemiologist


`@script`
Hi! I'm Luke Johnston and I'm a diabetes epidemiology researcher. In this course, we will discuss the general workflow for analyzing cohort datasets and in this first chapter we will cover some of the basics of cohort studies and designs.


---
## What is a cohort study?

```yaml
type: "TwoColumns"
key: "9039aa5cb9"
```

`@part1`
Features:
- Usually investigate risk factors for diseases
- Type of longitudinal study: Repeated measurements throughout time
- *Participants share common characteristic(s)*


`@part2`
![Example cohort recruitment and sample. Font Awesome Icons, using emojifonts package.](https://assets.datacamp.com/production/repositories/2079/datasets/4f1ae5179ba09672f8f19c1a005b71d883467a2c/plot-cohort-sample.png)


`@script`
So, what is a cohort study? Cohorts are scientific studies that investigate how factors influence the risk for a disease. Cohorts are always a type of longitudinal study where participants have repeatedly collected measures throughout time. Most importantly, participants in a cohort all share a common characteristic, hence the term "cohort". For example, the US Nurses' Health Study only includes participants that are married, female nurses.


---
## Purpose and usefulness of cohorts

```yaml
type: "TwoRowsTwoColumns"
key: "3020a2875a"
```

`@part1`
![Risk factors and health management. Font Awesome Icons, using emojifonts package.](https://assets.datacamp.com/production/repositories/2079/datasets/c3805372fcdf0f8d07a371a2a3167578bed0a36f/plot-purpose-risk-factors.png)


`@part2`
![Informing diagnosis decisions](https://assets.datacamp.com/production/repositories/2079/datasets/e820bcda71d9330dfe338754432df5fd316a2b7a/plot-purpose-diagnosis.png)


`@part3`
![Tracking side effects and safety from drugs](https://assets.datacamp.com/production/repositories/2079/datasets/62af4f9f6bf1799107925f3a937b84ab945ba2f9/plot-purpose-side-effects.png)


`@part4`



`@script`
Cohort studies are fundamental to epidemiology and are a key study design for answering questions about human health and behavior. Cohort studies are very common in health and biomedical research. They help identify risk factors for disease to better understand how to prevent and manage them. They are also incredibly powerful for helping inform evidence-based clinical decision-making.


---
## Two cohort study designs

```yaml
type: "TwoColumns"
key: "5a578ef6a6"
```

`@part1`
#### Prospective

Study participants:

- *Doesn't have the disease*
- Followed over time:
    - Multiple visits over time
    - Health and other conditions measured at each visit


`@part2`
#### Retrospective

Study participants:

- *Have the disease* 
- Take data from the past:
    - Asked about past conditions or past medical health records are examined


`@script`
There are two main types of cohort designs, prospective and retrospective. Prospective cohorts are the more common and arguably the most powerful form of cohort design to study disease development. 

Retrospective cohorts, on the other hand, are useful when health records are easy to access or when it is impractical or even impossible to conduct a prospective cohort. 

The main difference between these designs is that for prospective cohorts, participants don't have the disease at the start of the study, while for retrospective cohorts they do. We will cover these designs in more detail later.


---
## Why are the basics important to know?

```yaml
type: "FullSlide"
key: "d2a6af7c52"
```

`@part1`
- Context is vital: Cohorts study health, so impacts on lives {{1}}
- Analysis and interpretation restricted by: {{2}}
    - Design type
    - What was measured and how
- Examples: {{3}}
    - Data with noise often in retrospective cohorts - be cautious
    - Measure is physiological abstraction - useful to transform


`@script`
Cohort studies usually investigate some disease, so the results have the potential to have a real-world impact on people's lives and health. As the researcher, you need to know what data you are dealing with and how it was collected in order to appropriately analyze and interpret the results. You need to know the context of the data, so it's important that you understand the basics of the study designs.

For cohorts, both the study design and the types of the measured variables influence how you analyze your data. 

For instance, retrospective cohorts tend to have imprecise measures because of how and what data is collected, such as from questionnaires or medical forms. So when interpreting your results you'll have to be extra cautious. Or, some measures may be abstractions of a physiological process and applying some mathematical transformation may create more meaningful and interpretable results. This means there are many ways of analyzing cohort datasets. We'll get into these concepts in more detail as we go through the course.


---
## Framingham Heart Study

```yaml
type: "TwoRows"
key: "6fa4470529"
```

`@part1`
![Original Framingham Heart Study publication. PubMedID: PMC1525365.](https://assets.datacamp.com/production/repositories/2079/datasets/fb4a5797d1d3f1ea761ce274b23248e606775bf0/framingham-study.png)


`@part2`
```{r}
framingham
```

```
# A tibble: 11,627 x 39
  randid   sex totchol   age sysbp diabp cursmoke cigpday   bmi diabetes
   <int> <int>   <int> <int> <dbl> <dbl>    <int>   <int> <dbl>    <int>
1   2448     1     195    39  106   70          0       0  27.0        0
2   2448     1     209    52  121   66          0       0  NA          0
3   6238     2     250    46  121   81          0       0  28.7        0
# ... with 29 more variables...
```


`@script`
We will be working with the Framingham Heart Study dataset. This study started in the 1950s to investigate and establish the role of lifestyle on cardiovascular disease. Many health tips, such as being physically active, eating healthy foods, and not smoking, were first widely recognized because of the results of this study. There are about 4400 participants, with data collected a max of 3 times on the participants over the course of 15 years. This makes it a great dataset to practice on for analyzing cohorts. You'll notice that the data is a "tibble", which comes from the tidyverse. We make heavy use of the tidyverse throughout the course so we recommend that you familiarize yourself with it a bit.


---
## Lesson summary

```yaml
type: "FullSlide"
key: "cc6f1efcb4"
```

`@part1`
- Features of a cohort: health, time, commonality
- Powerful study design to investigate health
- Two types: prospective and retrospective
- Using Framingham Study throughout course


`@script`
To summarize, we covered features of cohorts, why we use them in health research, the two design types, and that we'll use the Framingham dataset.


---
## Let's do some exercises!

```yaml
type: "FinalSlide"
key: "97f61fb6b7"
```

`@script`
Alright, let's do a few exercises to review and test your knowledge!

