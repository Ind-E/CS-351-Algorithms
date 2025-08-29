#let code_block_bg = luma(235)
#let code_block_radius = 2pt

#show raw.where(block: false): it => box(
  text(fill: blue)[#it],
  fill: code_block_bg,
  radius: code_block_radius,
  outset: 2pt,
)

#show raw.where(block: true): it => box(
  text(it),
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

#set text(font: "FiraCode Nerd Font Propo")

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

+ recursively split input by keeping track of `start` and `end` indices for each
  split
+ Merge splits together

*Selection Sort* (In-place)

+ set `sorted` index to 0
+ find the minimum element in the subset of the input after `sorted` index
+ swap element at `sorted` index with minimum element
+ increase `sorted` index by 1
+ repeat steps 1-4 until `sorted` index equals the length of the input minus 1

*Timing and Data Generation*

I used the `timeit` library to collect data, both for timing and repetitions. It
uses `time.perf_counter()` internally. For each (algorithm, n) pair, I ran 10
trials. In each trial, I generated data by randomly shuffling the integers from
1 to n using `random.shuffle()`, then ran the sorting algorithm and took the
median time.

= Results
#align(center, include "_table.typ")
#image("linear.png")
#image("log.png")

= Reflection

For greater experimental rigor, I would perform more than 10 trials for
each input.

= Appendix
all source code can be found on my
#link("https://github.com/Ind-E/CS-351-Algorithms/tree/main/hw1")[github].

`main.py` contains the implementation and testing of the sorting algorithms,
including generating the plots and table. To run it, use `python main.py`

`write-up.typ` is the source code for this pdf.

`merge_sort_viz.py` is something extra I did, it contains code to visualize
merge sort using #link("https://www.manim.community/")[manim].

