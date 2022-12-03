#!/usr2/local/julia-1.8.2/bin/julia

#=
Ervin Pangilinan
CSC 330: Organization of Programming Languages - Fall 2022
Project 3: The Collatz Conjecture
Recursive Implmentation in Julia
=#

using Printf

# Recursive Solution
function extendSequence(number)
    # PRE: Number in Collatz sequence in passed in. 
    # POST: Changes the argument based on parity and iteratively calculates Collatz length. 

    if number == 1
        return 0
    elseif number % 2 == 0
        number /= 2
        return 1 + extendSequence(number)
    else 
        number = (3 * number) + 1
        return 1 + extendSequence(number)
    end

end

function searchDuplicates(arr, sequence)
    # PRE: Array of sequence lengths and a Collatz sequence length is passed in. 
    # POST: Returns index of integer in array that is the same as the sequence length. 

    index = -1 
    for i in 1 : length(arr)
        if arr[i] == sequence
            index = i 
            break
        end 
    end 

    return index

end 

function bubbleSort(keys, values)
    # PRE: Parallel arrays passed in are completely filled. 
    # POST: Sorts key array by its values in descending order

    needsSwap = true 
    while needsSwap 
        needsSwap = false
        for i in 1 : length(keys) - 1 
            if values[i] < values[i + 1] 
                values[i], values[i + 1] = values[i + 1], values[i]
                keys[i], keys[i + 1] = keys[i + 1], keys[i]
                needsSwap = true 
            end 
        end 
    end 

end 

function main()
    # PRE: Command line arguments are passed to determine bounds. 
    # POST: Outputs Collatz numbers by sequence length and integer size. 

    lower = parse(Int64, ARGS[1])
    upper = parse(Int64, ARGS[2])

    if upper < lower 
        upper, lower = lower, upper 
    end 

    numbers = zeros(Int64, 10)
    lengths = zeros(Int64, 10)

    counter = 1
    for i in lower : upper 
        sequence = extendSequence(i)                    # Iterative approach
        index = searchDuplicates(lengths, sequence)     # Holds index containing duplicate sequence length

        if counter < 10
            # Handle the first 10 elements to be added to the parallel arrays. 
            if index == -1
                numbers[counter] = i 
                lengths[counter] = sequence 
                counter += 1
            else 
                # Handle duplicates.
                if i < numbers[index] 
                    numbers[index] = i - 1
                end
            end 

        else
            # Every case afterwards. 
            if index != -1 
                # Handle duplicates. 
                if i < numbers[index]
                    numbers[index] = i 
                end 
            else
            # Push out the pair with the smallest Collatz length. 
                index = argmin(lengths)
                if sequence > lengths[index] 
                    lengths[index] = sequence
                    numbers[index] = i 
                    counter += 1
                end 
            end
        end

        bubbleSort(numbers, lengths)

    end 

    # Sort based on sequence length
    bubbleSort(numbers, lengths)
    println("Sorted based on sequence length")
    for i in 1 : length(numbers)
        if numbers[i] != 0 && lengths[i] != 0
            println(string("\t", numbers[i], "\t", lengths[i]))
        end
    end 
    println("")

    # Sort based on integer size
    bubbleSort(lengths, numbers)
    println("Sorted based on integer size")
    for i in 1 : length(numbers)
        if numbers[i] != 0 && lengths[i] != 0
            println(string("\t", numbers[i], "\t", lengths[i]))
        end
    end 
    println("")

end 

main()