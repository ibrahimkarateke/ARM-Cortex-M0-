# ARM Cortex M0+
This repository contains all the assigned homework for the BLG 212E Microprocessor System course during the 2023-2024 fall semester at Istanbul Technical University. The code is written in ARM Cortex M0+ assembly language. To run and debug the files in this project, it is recommended to use Keil µVision IDE v5.
# 1 - Calculating 1's complement
In this section, the value intended to undergo 1's complement is denoted as `var1`. To obtain the 1's complement of any given value, the specified variable (`var1` in this case) undergoes an XOR operation with a sequence of ones. In hexadecimal notation, this sequence is represented by Fs. In other words, the XOR operation is performed with the hexadecimal value 'FFFFFFFF'. Finally, the result is kept in the register `R0`.

# 2 - Calculating Power of a Number --recursively
In this section, two values, namely the base and exponent, are represented as `var1` and `var2`. Additionally, at the outset, these two values are moved into the registers `R5` and `R6`, respectively. The outcome of the power operation, based on the specified values, is computed by invoking the `POW` subroutine recursively, and the result is stored in the register `R5`.

# 3 - Analysis of Bubble Sort Algorithm
The task requires the implementation of a program in Arm Cortex M0+ assembly language to assess the performance of the Bubble Sort algorithm concerning array size. The initial step involves creating a timer interrupt with specified parameters, including those from SysTick Timer, to measure the microcontroller's running time in microseconds. The objective is to develop a program that utilizes the Bubble Sort algorithm to sort an array, while simultaneously recording execution times based on the element count. The unsigned numbers to be sorted are sourced from `array.txt` and must be integrated into the program in the specified sequence. Upon completion,  the memory address of the sorted array is stored in the `R0` register and the memory address of the execution times array is in the `R1` register. Additionally, the program saves both the sorted array and execution times to memory.

For this task, CPU frequency and timer interrupt period are given 64 MHz and 16 ms, respectively.

Hence, the calculation of the reload value is as follows.

$$ Period = \frac{1 + reloadValue}{F_{CPU}} $$

$$ (1 + reloadValue) = F_{CPU}.Period $$

$$ (1 + reloadValue) = 64\times10^6  \text{Hz} \times 16 \times 10^{-3} \text{s}$$

$$ (1 + reloadValue) = 64 \times 10^6 \frac{1}{\text{s}} \times 16 \times 10^{-3} \text{s}$$

$$ (1 + reloadValue) = 64 \times 16 \times 10^3 $$

$$ (1 + reloadValue) = 1,024,000 $$

$$ \textbf{reloadValue = 1,023,999}$$

$$ \textbf{0xF9FFF} \text{   in Hexadecimal}$$

The demonstration of the output is given below.

![registers](https://github.com/ibrahimkarateke/ARM-Cortex-M0-/assets/148653955/f0530530-f9b8-486d-8e02-e66024868fdf)

- R0 holds the address of the sorted array
- R1 holds the address of the execution times array



## Sorted Array
![array mem2](https://github.com/ibrahimkarateke/ARM-Cortex-M0-/assets/148653955/0e69a856-b3ea-4003-9974-fc4cb131e8d9)
## Time Array (in decimal)
![time mem3](https://github.com/ibrahimkarateke/ARM-Cortex-M0-/assets/148653955/31710ca8-2b6e-429a-b571-3308b642f281)

## The Relationship Between Array Size and Execution Time
![Figure_1](https://github.com/ibrahimkarateke/ARM-Cortex-M0-/assets/148653955/a1bb4dbc-d67a-4b7e-9f00-b4c8b36dbead)

Taking into consideration our prior knowledge that the bubble sort algorithm is known to operate in O(n<sup>2</sup>) time complexity, this theoretical expectation can be affirmed through the analysis and measurement of the time consumed for each sorting operation. Upon scrutiny of the time data and subsequent plotting, it becomes evident that the resulting graph manifests characteristics resembling those of a quadratic function. Therefore, this empirical evidence serves to reinforce the conclusion that the bubble sort algorithm is indeed characterized by O(n<sup>2</sup>) time complexity.

