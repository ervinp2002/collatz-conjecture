/*
Ervin Pangilinan
CSC 330: Organization of Programming Languages - Fall 2022
Project 3: The Collatz Conjecture
Recursive Implementation in Go
*/

package main 

import (
	"fmt"
	"os"
	"strconv"
)

func swap(arg1 *int64, arg2 *int64) {
	// PRE: Addresses passed in have initialized values.
	// POST: Swaps the addresses of the passed arguments.
	temp := *arg1
	*arg1 = *arg2
	*arg2 = temp
}

// Recursive Solution
func extendSequence(number int64) int64 {
	// PRE: Number in Collatz sequence is passed in. 
    // POST: Changes the argument based on parity and recursively calculates Collatz length. 

	if number == 1 {
		return 0
	} else if number % 2 == 0 {
		number /= 2
		return 1 + extendSequence(number)
	} else {
		number *= 3
		number += 1
		return 1 + extendSequence(number)
	}
}

func searchDuplicates(arr []int64, sequence int64) int {
	// PRE: Array of sequence lengths and a Collaz sequence length is passed in. 
	// POST: Returns index of integer in array that is the same as the passed sequence length. 

	var index int = -1
	for i := 0; i < len(arr); i++ {
		if arr[i] == sequence {
			index = i
			break
		}
	}

	return index
}

func minLoc(arr []int64) int {
	// PRE: Array is passed in.
	// POST: Returns the index of the minimum value of the array. 

	var min int = 0
	for i := 0; i < len(arr); i++ {
		if arr[i] < arr[min] {
			min = i
		}
	}

	return min
}

func bubbleSort(keys []int64, values []int64) {
	// PRE: Parallel arrays passed in are completely filled.
	// POST: Sorts key array by values in descending order. 

	var needsSwap bool = true
	for needsSwap == true {
		needsSwap = false
		for i := 0; i < len(values) - 1; i++ {
			if values[i] < values[i + 1] {
				swap(&values[i], &values[i + 1])
				swap(&keys[i], &keys[i + 1])
				needsSwap = true
			}
		}
	}
}

func main() {
	// PRE: Command line arguments are passed to determine bounds.
	// POST: Outputs Collatz numbers by sequence length and integer size. 

	lower, err := strconv.ParseInt(os.Args[1], 10, 64)
	upper, err := strconv.ParseInt(os.Args[2], 10, 64)

	if lower > upper {
		swap(&lower, &upper)
	}

	if err == nil {
		numbers := make([]int64, 10)
		lengths := make([]int64, 10)

		var counter int			// Keeps track of index in parallel arrays. 
		var current int64		// Integer to be manipulated.
		var sequence int64		// Keeps track of the Collatz length of a specific integer.
		var temp int 			// Keeps track of index in array that holds duplicate Collatz length. 

		counter = 0
		for i := lower; i <= upper; i++ {
			current = i 
			sequence = 0 

			sequence = extendSequence(i)					// Recursive approach. 
			temp = searchDuplicates(lengths, sequence)

			if counter < 10 {
				// Handle the first 10 elements to be added to the parallel arrays. 
				if temp == -1 {
					numbers[counter] = i
					lengths[counter] = sequence 
					counter += 1
				} else {
					// Handle temps. 
					if i < numbers[temp] {
						numbers[temp] = i - 1
					}
				}
			} else {
				// Every case afterwards.
				if temp != -1 {
					// Handle temps. 
					if i < numbers[temp] {
						numbers[temp] = i
					}
				} else {
					// Push out the pair with the smallest Collatz length. 
					temp = minLoc(lengths)
					if sequence > lengths[temp] {
						lengths[temp] = sequence 
						numbers[temp] = current 
						counter += 1
					}
				}
			}

			bubbleSort(numbers, lengths)
		}

		// Sort based on sequence length
		bubbleSort(numbers, lengths)
		fmt.Println("Sorted based on sequence length")
		for i := 0; i < len(numbers); i++ {
			if numbers[i] != 0 && lengths[i] != 0 {
				fmt.Println("\t", numbers[i], "\t", lengths[i])
			}
		}
		fmt.Println(" ")

		// Sort based on integer size
		bubbleSort(lengths, numbers)
		fmt.Println("Sorted based on integer size")
		for i := 0; i < len(numbers); i++ {
			if numbers[i] != 0 && lengths[i] != 0 {
				fmt.Println("\t", numbers[i], "\t", lengths[i])
			}
		}
		fmt.Println(" ")

	} else {
		fmt.Println("Command line arguments are missing.")
	}
}

