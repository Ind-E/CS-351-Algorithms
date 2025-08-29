# pyright: reportWildcardImportFromLibrary=false

import random
from manim import *
from manim.opengl import *

SCREEN_WIDTH = 14 + (2 / 9)
MARGIN = 2 / 9 + 0.5
MARGIN_WIDTH = SCREEN_WIDTH - MARGIN

BOX_SIZE = 1.0
INNER_MARGIN = 0.25 * BOX_SIZE
SHIFT = BOX_SIZE + INNER_MARGIN

ITEMS = 10

RUN_TIME = 0.5


class Node:
    def __init__(self, group: VGroup, nums: list[int]):
        self.group = group
        self.nums = nums
        self.left = None
        self.right = None
        self.layer = -1


def debug_group(group, indent=0):
    spacer = "  " * indent
    for i, mob in enumerate(group.submobjects):
        print(f"{spacer}{i}: {mob.__class__.__name__}")
        if mob.submobjects:
            debug_group(mob, indent + 1)


def boxed(input: int) -> VGroup:
    g = VGroup()
    box = Square(BOX_SIZE)
    g.add(box)
    g.add(Text(str(input)))
    return g


def split(
    self: Scene, items: VGroup, layer: int, nums: list[int], rectangles: VGroup
) -> Node:
    node = Node(items, nums)

    n = len(items)
    if n <= 1:
        return node

    mid = n // 2
    l = items[:mid]
    r = items[mid:]

    shift = (0, -SHIFT, 0)
    l_rect = SurroundingRectangle(l, color=RED)
    r_rect = SurroundingRectangle(r, color=BLUE)
    rectangles.add(l_rect)
    rectangles.add(r_rect)

    self.play(FadeIn(l_rect), run_time=RUN_TIME)
    self.play(l.animate.shift(shift), run_time=RUN_TIME)

    self.play(FadeIn(r_rect), run_time=RUN_TIME)
    self.play(r.animate.shift(shift), run_time=RUN_TIME)

    node.left = split(self, l, layer + 1, nums[:mid], rectangles)
    node.right = split(self, r, layer + 1, nums[mid:], rectangles)
    node.layer = layer
    return node


def merge(self: Scene, node: Node):
    if not node or not node.left or not node.right:
        return

    merge(self, node.right)
    merge(self, node.left)

    left_nums = node.left.nums
    right_nums = node.right.nums

    l, r = 0, 0
    result = []

    while l < len(left_nums) and r < len(right_nums):
        if left_nums[l] <= right_nums[r]:
            result.append(left_nums[l])
            l += 1
        else:
            result.append(right_nums[r])
            r += 1
    result.extend(left_nums[l:])
    result.extend(right_nums[r:])

    node.nums = result

    result_group = VGroup(boxed(num) for num in result)
    result_group.arrange()
    result_group.move_to(node.group.get_center())
    result_group.to_edge(UP)
    result_group.shift((0, (node.layer) * -SHIFT, 0))

    for item2 in result_group:
        for item in node.group:
            if item.submobjects[1].text == item2.submobjects[1].text:
                self.play(item.animate.set_color(GREEN), run_time=RUN_TIME)
                self.play(Transform(item, item2), run_time=RUN_TIME)

    node.group = result_group

    return node


class MergeSort(Scene):
    def construct(self):
        global RUN_TIME
        random.seed(44)
        nums = [random.randint(1, 99) for _ in range(ITEMS)]
        items = VGroup(boxed(num) for num in nums)

        items.arrange().to_edge(UP)
        if items.width > MARGIN_WIDTH:
            scale = MARGIN_WIDTH / items.width
            items.scale(scale)
        else:
            scale = 1

        self.play(FadeIn(items), run_time=RUN_TIME)

        rectangles = VGroup()
        root = split(self, items, 0, nums, rectangles)

        self.play(rectangles.animate.shift((0, -SHIFT, 0)), run_time=RUN_TIME * 3)

        merge(self, root)

        # assert sorted(nums) == nums
        self.wait(RUN_TIME)
