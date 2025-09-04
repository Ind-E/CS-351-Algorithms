#let code_block_bg = luma(235)
#let code_block_radius = 2pt

#show raw.where(block: false): it => box(
  text(fill: blue)[#it],
  fill: code_block_bg,
  radius: code_block_radius,
  outset: 2pt,
)

#show raw.where(block: true): it => box(
  it,
  width: 1fr,
  fill: code_block_bg,
  radius: code_block_radius,
  inset: 8pt,
)

#show heading: it => [
  #v(1em)
  #it
  #v(0.5em)
]

#show link: it => text(fill: orange, weight: "semibold")[#it]

#set text(font: "FiraCode Nerd Font")

#set page(header: align(right)[
  CS 351 - Algorithms \
  Indi Esneault
])

#let maketitle(title, date) = {
  align(center)[
    #text(24pt)[#title]

    #text(14pt)[#date]
  ]
}

#maketitle[Assignment 1][Due 9/3]

Name: Indi Esneault \
Language Used: Python \
OS: Linux (NixOS) \
Hardware: AMD Ryzen 7 7735HS - 8/16 cores, 32 GB RAM

= Methods

*Merge Sort* (In-place)

+ Recursively split input by keeping track of `start` and `end` indices for each
  split
+ Merge splits together

*Selection Sort* (In-place)

+ Set `sorted` index to 0
+ Find the minimum element after `sorted` index
+ Swap element at `sorted` index with minimum element
+ Increase `sorted` index by 1
+ Repeat steps 1-4 until input is sorted

*Timing and Data Generation*

I used the `timeit` library to collect data, both for timing and repetitions. For each (algorithm, n) pair, I ran 10
trials. In each trial, I generated data by randomly shuffling the integers from
1 to n using `random.shuffle()`, then ran the sorting algorithm and took the
median time. I ran each sorting algorithm once at the beginning of the program
both as a warmup and as a sanity check.

= Results
#align(center, include "_table.typ")
#image("linear.png")
#image("log.png")

= Reflection

My curves seem to line up with the expected predictions $O(n^2)$ and $O(n log
  n)$.

Since I'm using python, there's the overhead of the garbage collector. I used
the following libraries:

```python
import random
import statistics
import timeit
import matplotlib.pyplot as plt
```

At $n>5000$ merge sort seems to pull away from selection sort. This can be seen
more clearly in the log-log plot.

In order to
improve experimental rigor, I would increase the number of trials, have multiple
repetitions of the same input for each trial, and test larger and larger values
of n.

= Appendix
all source code can be found on my
#link("https://github.com/Ind-E/CS-351-Algorithms/tree/main/hw1")[github].

`main.py` contains the implementation and testing of the sorting algorithms,
including generating the plots and table. To run it, use `python main.py`.

`write-up.typ` is the source code for this pdf.

`merge_sort_viz.py` is something extra I did, it contains code to visualize
merge sort using #link("https://www.manim.community/")[manim].

