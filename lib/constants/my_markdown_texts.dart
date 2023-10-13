class MyMarkdownTexts {
  static const introMarkdown = """
# Register Machine Simulator

This website offers simulation and Gödelisation for **Register Machines**. As a part of the "Models of Computation" syllabus at Imperial College, I made this tool (originally as a CLI written in Haskell) during the term. Since then, I have decided to hide away the Haskell complications and release it as a website so that it can be more accessible.

A good way to start is to click on the [Simulation](!!Simulate) tab and check out the examples there : )

This page contains a short description of what are Register Machines and how to use this website. For more information, please check out [here](https://github.com/MMZK1526/Haskell-RM#readme).

## Introduction

A Register Machine is a simple system involving a finite number of registers (each can hold a natural number), a finite number of lines, and only three instructions (increment, decrement and halt).  

An increment instruction takes a register and a line. It increments a the register and jumps to the given line.  

A decrement instruction takes a register and two line s (say `m` and `n`). If the register is positive, it decrements the value and jumps to line `m`. Otherwise it jump to line `n` (without changing the register, which is still 0).  

A halt instruction terminates the machine. If we jump to a line that does not exist, it is treated as a halt instruction as well.

Consider the following example:

```Register Machine
L0: R1- 1 2
L1: R0+ 0
L2: R2- 3 4
L3: R0+ 2
L4: HALT
```

Assume `R0 = 0`, `R1 = 1` and `R2 = 2`. We start from line 0; which decrements R1 and goes to line 1; which increments R0 and goes back to line 0; which goes to line 2 since `R1 = 0`; which decrements R2 and goes to line 3; which increments R0 and goes to line 2; which decrements R2 and goes to line 3; which increments R0 and goes to line 3; which goes to line 4 since `R2 = 0`; which halts with `R0 = 3`, `R1 = 0` and `R2 = 0`.

If we treat R0 as the result and the other registers as the input, then a Register Machine that has registers from R0 to R{n} is a partial function from N^n to N (it is partial because the machine may not terminate, thus not providing any result). In our previous example, the function is `f(R1, R2) = R1 + R2`.  

Despite its first appearance, Register Machines are actually very powerful: the system is Turing-complete. This means they are capable of basically whatever modern computers can do.

## Performance

As one may imagine, Register Machines are in general very inefficient since it can increment or decrement at most one register at a time. For example (they are available in the [Simulation](!!Simulate) tab), the adder machine which computes `f(x, y) = x + y` takes `2(x + y) + 3` steps, and the multiplier machine which computes `f(x, y) = xy` takes `5xy + 3x + 2` steps. If we take the input size as the number of digits the inputs have, then these two "trivial" functions both have exponential time complexity.

As a result, a naïve Register Machine simulation is pretty useless except for extremely small inputs. In my implementation, the simulator analyses the control flow of the machine, detecting execution cycles, and execute the iterations in one go. For example, the adder machine consists of a R0-R1 cycle and a R0-R2 cycle where the contents of both inputs "flow" into R0. With my optimisation, each cycle only consists of one step during the simulation so that the execution has *de juro* constant-time.

This optimisation also makes simulating the Universal Register Machine(a Register Machine that can simulate all Register Machines) possible.

If an infinite loop is detected, the simulator would end immediately and report the machine is never going to terminate. Of course, it is not able to detect all infinite loops since the Halting Problem is undecidable.

## Gödelisation

Intriguingly, there is a ONE TO ONE correspondence between natural number and Register Machines (**Gödelisation**). In other words, any natural number uniquely represents a Register Machine and *vice versa*.  

The foundation of Gödelisation lies in the following functions: let `p(x, y) = 2^x + (2y + 1)` and `p'(x, y) = p(x, y) - 1`, it can be proven that the former is a bijection between pairs of natural number to positive number and the latter a bijection to natural number:

p'|p|(x, y)
----|---|----
0|1|(0, 0)
1|2|(1, 0)
2|3|(0, 1)
3|4|(2, 0)
4|5|(0, 2)
5|6|(1, 1)
6|7|(0, 3)
7|8|(3, 0)
8|9|(0, 4)

With `p`, we can recursively define a function, `s`, that is a bijection between finite lists of natural number and singular natural number: `s([]) = 0; s(x : xs) = p(x, s(xs))`:

s|xs|s|xs
----|---|----|---
0|[]|10|[1, 1]
1|[0]|11|[0, 0, 1]
2|[1]|12|[2, 0]
3|[0, 0]|13|[0, 1, 0]
4|[2]|14|[1, 0, 0]
5|[0, 1]|15|[0, 0, 0, 0]
6|[1, 0]|16|[4]
7|[0, 0, 0]|17|[0, 3]
8|[3]|18|[1, 2]
9|[0, 2]|19|[0, 0, 2]

There is a trick to "decode" a number to a list of numbers, namely expressing the number in binary form and count number of zeros between ones from right to left. For example, 998 in binary is 1111100110, and if we count from the rightmost digit, it starts with 1 zero before reaching a one, then 0 zeros due to the consecutive ones, then 2 zeros, and so on. The result is then [1, 0, 2, 0, 0, 0, 0].

With the functions `p` and `p'`, we can then encode each line of a Register Machine. If the instruction is `HALT`, encode it with 0; if it is an increment, then it has a register number `r` with a line number `l`, and we encode it with `p(2r, l)`; if it is a decrement, then it has a register number `r` with two line numbers `l1` and `l2`, and we encode it with `p(2r + 1, p'(l1, l2))`.

Finally, once we encode each line of a Register Machine into a number, we can then encode the list of number into a single number by `s`.

If we convert a natual number to a Register Machine, then most likely it will contain instruction that makes no sense, for example jumping to a non-existing line. This does not cause any problem, however, since we treat bad line number as Halt instructions.

Go to the [Gödel Number Conversion](!!Convert) tab for automated conversion tools.
""";

  static const decodeMarkdown = """
# Gödelisation

## Decoding

Enter a non-negative number below and convert it to the corresponding pair, list, and Register Machine.
""";

  static const encodeRMmarkdown = """
## Register Machine Encoding

Convert a Register Machine to a list and a Gödel number.

Either select from one of the examples, or enter/upload your custom Register Machine below.

Click the [Help](https://github.com/MMZK1526/Haskell-RM#Syntax) button for syntax guide.
""";

  static const encodePairOrListMarkdown = """
## Pair/List Encoding

Convert a pair or a list of natural numbers to a Gödel number.

Please separate the numbers by spaces, commas, or semicolons.
""";

  static const simulateMarkdown = """
## Register Machine Simulation
Simulate a the execution of a Register Machine with the given Register inputs.

Register values are zero if not specified.

The Registers start from R1 by default since R0 is treated as the output Register. If you want to set R0, please tick the "Start From R0" checkbox.

Either select from one of the examples, or enter/upload your custom Register Machine below.

Click the [Help](https://github.com/MMZK1526/Haskell-RM#Syntax) button for syntax guide.

If the "Show First n Steps" checkbox is ticked, the simulator will only show the first n steps of the execution. If the Register Machine is not going to terminate, the simulator will stop immediately without reporting the result. If it not ticked (by default), the simulator will only report the result of the execution.
""";

  static const simulateUniversalMarkdown = """
""";

  static const convertMarkdown = """
""";

  static const helpMarkdown = """
""";
}
