---
title: "Making sense of antibody tests"
date: 2020-05-07
toc: false
categories: ['COVID-19']
summary: 'A quick stats primer on interpreting antibody tests.'
---

{{% admonition type="info" title="Update (May 27)" details="true" %}}

Seems like the 'no better than a coin-flip' soundbite has started getting some traction in the news. However, as this thread does a good job pointing out, improvements in test sensitivity and specificity is improving PPV across the board.

{{<tweet 1265474771187142661>}}

You can [read the FDA's guidance on serology tests here](https://www.fda.gov/medical-devices/emergency-situations-medical-devices/eua-authorized-serology-test-performance) (updated May 22). In populations with low prevalence, the current recommendation is to use two independent tests. The page also includes summaries of expected performance for tests that have received emergency approval (EUA).
{{% /admonition %}}

How does a test that's '99% accurate' become the practical equivalent of a coin flip? It's a question that's garnered some attention as the scrunity on antibody tests [^4] increases. I'm paraphrasing the question from this explanation by Dr. Deborah Birx, responding to a question about how to interpret positive antibody tests:

> ... if you have 1 percent of your population infected and you have a test that’s only 99 percent specific, that means that when you find a positive, 50 percent of the time will be a real positive and 50 percent of the time it won’t be.”  
> --- *Dr. Deborah Birx, April 20* [^1]  

[^1]: Source: <https://www.vox.com/2020/5/1/21240123/coronavirus-quest-diagnostics-antibody-test-covid>

[^4]: tests designed to see whether you've previously had COVID-19

While there's been some understandable confusion about this statistic, there's also been some strong explanatory journalism. Here's a good piece from [Vox](https://www.vox.com/2020/5/1/21240123/coronavirus-quest-diagnostics-antibody-test-covid), and a [great video from ProPublica](https://youtu.be/qtlSu7OhkYE) (via [kottke.org](https://kottke.org/20/05/on-the-accuracy-of-covid-19-testing)) on how these tests work and what we can expect to learn from them.

If you've ever tried to teach someone statistics, you'll appreciate the value of a vivid example. I'm sure I'll be referencing this one for a while, so I thought I'd throw together a quick [ELI5](https://www.reddit.com/r/explainlikeimfive/) style explanation for posterity.

## What makes a test good?

Here's how you'd want a test to work:

- If you had COVID-19, the test should come back positive.
- If you never had COVID-19, the test should come back negative.

That's pretty much it. Let's add a way to measure how a test performs on these tasks.

> If you had COVID-19, the test should come back positive.

This is measured by the **True Positive Rate (TPR)**. [^2]

Let's say an antibody test has TPR of 95%. Here's what that means: if you tested 100 people who actually had the disease:

- 95 of them would correctly test positive.
- 5 people who had COVID-19 would test negative, and would not be tagged as recovered COVID cases (i.e. *false negatives*).

> If you never had COVID-19, the test should come back negative.

This is measured by the **True Negative Rate (TNR)**. [^3]

What happens when a test has a 95% TNR? If you tested 100 people who never had the disease:

- 95 of them would be correctly test negative.
- 5 people who never had the disease would test positive, and would be incorrectly  categorized as recovered COVID-19 cases (i.e. *false positives*).

[^2]: also called *sensitivity*, easily confused with *specificity*, which you'll see in a minute. Don't worry, I don't plan on using either of them.

[^3]: also called *specificity*

To have faith in a test, you want both TPR and TNR to be as high as possible: you want the test to do a great job at both ruling you *in* if you had COVID-19 and ruling you *out* if you didn't. There's an inherent trade off when you optimize for one over the other (ex: an over-zealous positive classification will lead to more false positives).

To summarize: if you had COVID-19, you want to be in bucket A; if you never had COVID-19, you want to be in bucket B.

| | Had COVID-19  | Never had COVID-19  |
|:-:|:-:|:-:|
| Antibody test positive | :white_check_mark: A | :x: false positive|
| Antibody test negative | :x: | :white_check_mark: B  |

## What does a positive test mean for me?

Understanding this setup is important, but *'How good is the test at spotting true positives and true negatives?'* isn't the question we ultimately care about. The real question is, *'If I test positive, how sure can I be that I really had COVID-19?'* [^5] In other words, what's the test's **Positive Predictive Value (PPV)**?

[^5]: We could frame this from the negative perspective too, but the same principle applies.


The short answer to that question: it depends. Specifically, it depends on what proportion of the population has been infected with COVID-19, i.e. the **prevalence** of the disease. 

Here's why: when really few people have had COVID-19 (low prevalence), there just aren't that many positive cases to be found. So if you test positive, you can't easily tell if you're one of the real positives who was correctly captured, or one of the false positives who slipped through the cracks. Conversely, when the proportion of infected people is high, the true positives vastly outnumber the false positives, making a positive test result much more conclusive.

This effect is particularly pronounced when prevalence is low. With a prevalance of 1% and an antibody test with TPR and TNR of 99%, 50% of positive tests results will be real positives.

{{% admonition type="note" title="Show me the math" details="true" %}}

Say you live in a town of 10,000 people, with a COVID-19 prevalence of 1%. Everyone gets an antibody test with a TPR of 99% and a TNR of 99%.  

Of those 10,000 people:

- 100 people had COVID-19 (1% of 10,000)
  - 99 of them correctly test positive (since TPR is 99%)
  - 1 person tests negative (i.e. 1 false negative)
- 9900 people never had COVID-19 (99% of 10,000)
  - 9801 of them test correctly test negative (since TNR is 99%)
  - 99 people test positive (i.e. 99 false positives)

See the problem? The number of true positives and false positives is exactly the same, giving you a 50-50 chance of really being positive if you test positive.

{{% /admonition %}}

If you're curious, here's a chart showing how PPV changes as prevalence increases. At a prevalence of ~2%, there's still a one-third chance that a positive test is wrong.

{{% figure class="center" src="/files/covid_prevalence_zoomed.svg" caption="*Positive predictive value when prevalence is low (click/tap to enlarge)*" alt="" %}}

Zooming out, you can see how once prevalence gets past 10%, positive tests start becoming pretty reliable.

{{% figure class="center" src="/files/covid_prevalence_no_zoom.svg" caption="" alt="" %}}

Here's an [example script](https://gist.github.com/anantd/7ceb6392f1bf5f0ec29e22cacc1038b3) if you want to generate your own data. Hopefully that helps build some intution for how disease prevalance factors into a test's effectiveness. It's the reason why seroprevalance studies are so important; without them, it's anyone's guess where we fall on that curve.

To see the motion-graphics version of this explanation, check out this video from ProPublica:

{{< youtube qtlSu7OhkYE >}}
