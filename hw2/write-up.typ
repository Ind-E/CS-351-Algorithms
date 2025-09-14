
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
  #v(0.25em)
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

#maketitle[Assignment 2][Due 9/15]

= Complexity Analysis
== Time
=== Best Case
In the best case, the first triplet we check is a valid triplet - $O(1)$
=== Worst Case
In the worst case, there is no valid triplet and so we have to check every
combination - $O(n^3)$
=== Average Case
Depends on the data. If the chance to find a triplet is small, average case is
$O(n^3)$

== Space
In the brute force implementation, we aren't creating any additional arrays, so
the only space used is from things like stack frames which are mostly constant,
so $O(1)$ space complexity


#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  image("runtime.png"), image("runtime-log.png"),
  image("operations.png"), image("operations-log.png"),
)

#align(center, include "_table.typ")

= Theoretical Comparison

== 1. Sorted Array + Two Pointers
*Explanation:* Start by sorting the input array. Then, for each value $x$ in the
array, calculate its subtarget. The subtarget is what 2 other numbers would have
to add to make $x$ part of a valid triple. Once you have the subtarget, iterate
through every value greater than $x$ using 2 pointers at the start and end. If
the values at the pointers add up to more than the subtarget, increment the left
pointer, otherwise decrement the right pointer. Repeat this process for all
possible values of $x$

*Time Complexity:* $O(n^2)$ because for each value of $x$ we are iterating
through $n-"idx"(x)$ values

*Space Complexity:* $O(1)$ because there are no extra allocations

*Speedup for 1000 Elements:* $1000^3 / 1000^2 = 1000$, so it would be approx. 1000 times faster than the
brute force method


== 2. Hash Table Approach
For each value $x$ in the array, calculate its subtarget. Then, iterate through
every value greater than $x$. For each value $y$, check if $"subtarget" - y$ is
already in the hashmap. If not, add it to the hashmap. Repeat for all possible
values of $x$.

*Time Complexity:* $O(n^2)$ because for each value of $x$, we are iterating
through $n-"idx"(x)$ values

*Space Complexity:* $O(n)$ because for each value of $x$, we create a hashmap
of size up to $n-"idx"(x)$. (Memory can be freed between iterations)


= Reflection
I chose to use rust to collect data because the faster speed compared to python
allowed me to gather more data in a reasonable amount of time. I then wrote that
data to a file and read it in with python in order to create plots.

The brute force approach becomes impractical for large arrays because it takes
orders magnitude longer than other approaches. It's particularly important for
this problem because the worst case scenario occurs somewhat frequently when
there is no valid triplet.

My results were generally higher than the prediced $O(n^3)$, but it looks like
they started to converge near the end. There was a lot of variability in the
number of operations though, because the algorithm can short circuit depending
on what the input array looks like.

Factors that might cause deviations from the theoretical predictions include
cache effects, input data variation, and OS-level overhead.

It's important to consider complexity before implementation because at scale,
choosing the wrong algorithm could mean that it never completes in your
lifetime, or at the very least causes a noticable slowdown or bottleneck.



= Appendix
All code is on my
#link("https://github.com/Ind-E/CS-351-Algorithms/tree/main/hw2")[github]

use `make` to generate data + plots

use `make test` to run tests
