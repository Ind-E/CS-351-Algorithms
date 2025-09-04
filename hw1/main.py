import random
import statistics
import timeit
import matplotlib.pyplot as plt


def merge_sort(arr: list[int]):
    merge_sort_inner(arr, 0, len(arr) - 1)


def merge_sort_inner(arr: list[int], left: int, right: int):
    if left < right:
        mid = (left + right) // 2

        merge_sort_inner(arr, left, mid)
        merge_sort_inner(arr, mid + 1, right)
        merge(arr, left, mid, right)


def merge_sort_iterative(arr: list[int]):
    n = len(arr)

    curr_size = 1
    while curr_size <= n - 1:
        l_start = 0
        while l_start < n - 1:
            mid = min(l_start + curr_size - 1, n - 1)
            r_end = min(l_start + 2 * curr_size - 1, n - 1)

            merge(arr, l_start, mid, r_end)

            l_start += 2 * curr_size

        curr_size *= 2


def merge(arr: list[int], left: int, mid: int, right: int):
    n_l = mid - left + 1
    n_r = right - mid

    L = arr[left : left + n_l]
    R = arr[mid + 1 : mid + 1 + n_r]

    i_l = 0
    i_r = 0

    x = left

    while i_l < n_l and i_r < n_r:
        if L[i_l] <= R[i_r]:
            arr[x] = L[i_l]
            i_l += 1
        else:
            arr[x] = R[i_r]
            i_r += 1
        x += 1

    if i_l < n_l:
        arr[x : x + (n_l - i_l)] = L[i_l:n_l]

    if i_r < n_r:
        arr[x : x + (n_r - i_r)] = R[i_r:n_r]


def selection_sort(arr: list[int]) -> None:
    n = len(arr)
    for i in range(n):
        min_index = i + arr[i:].index(min(arr[i:]))
        arr[i], arr[min_index] = arr[min_index], arr[i]


REPETITIONS = 10


def test_sorts(dict, items, *sorts):
    data = [i for i in range(items)]
    random.shuffle(data)
    for sort in sorts:
        times = timeit.repeat(
            lambda: sort(data),
            setup=lambda: random.shuffle(data),
            number=1,
            repeat=REPETITIONS,
        )
        median = statistics.median(times)
        dict[sort].append((items, median))


def generate_typst_table(dict):
    n_values = [n for n, _ in next(iter(dict.values()))]

    lines = [
        "#table(",
        "  columns: (auto, " + ", ".join(["auto"] * len(dict)) + "),",
        "  inset: 8pt,",
        "  table.header([*n*], "
        + ", ".join(f"[*{func.__name__}*]" for func in dict)
        + "),",
    ]

    for i, n in enumerate(n_values):
        row = [str(n)]
        for func in dict:
            avg_time = dict[func][i][1]
            row.append(f"{avg_time:.6f}s")
        lines.append("  " + ", ".join(f'"{c}"' for c in row) + ",")

    lines.append(")")

    with open("_table.typ", "w") as f:
        f.write("\n".join(lines))


def main():
    random.seed(420)

    # sanity check
    input1 = [random.randint(1, 1000) for _ in range(20)]
    merge_sort(input1)
    assert sorted(input1) == input1

    input2 = [random.randint(1, 1000) for _ in range(20)]
    selection_sort(input2)
    assert sorted(input2) == input2

    sort_times = {merge_sort: [], selection_sort: []}

    n_values = [100, 500, 1000, 5000, 10000, 25000]

    for n in n_values:
        test_sorts(sort_times, n, merge_sort, selection_sort)

    generate_typst_table(sort_times)

    plt.figure(figsize=(8, 5))
    for sort_func, data in sort_times.items():
        xs = [n for n, _ in data]
        ys = [t for _, t in data]
        plt.plot(xs, ys, marker="o", label=sort_func.__name__)

    plt.xlabel("Input size (n)")
    plt.ylabel("Median time (seconds)")
    plt.title("Sorting Algorithm Comparison (linear)")
    plt.legend()
    plt.grid(True)
    plt.savefig("linear.png")

    plt.yscale("log")
    plt.xscale("log")
    plt.title("Sorting Algorithm Comparison (logarithmic)")
    plt.savefig("log.png")


if __name__ == "__main__":
    main()
