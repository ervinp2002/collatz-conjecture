/*
Ervin Pangilinan
CSC 330: Organization of Programming Languages - Fall 2022
Project 3: The Collatz Conjecture
Recursive Implementation in Rust
*/

use std::env;
use std::mem;

// Recursive Solution
fn extend_sequence(mut number: i64) -> i64 {
    // PRE: Collatz number is passed in. 
    // POST: Changes the argument based on parity and recusively returns the Collatz length. 

    if number == 1 {
        return 0;
    } else if number % 2 == 0 {
        number /= 2;
        return 1 + extend_sequence(number);
    } else {
        number = (3 * number) + 1;
        return 1 + extend_sequence(number);
    }
}

fn search_duplicates(arr: &[i64], sequence: i64) -> i32 {
    // PRE: Array of sequence lengths and a Collatz sequence length is passed in. 
    // POST: Returns index of integer in array that is the same as the passed sequence length.

    let mut index: i32 = -1;
    for i in 0..arr.len() as usize {
        if arr[i] == sequence {
            index = i as i32;
            break;
        }
    }

    return index;
}

fn bubble_sort(keys: &mut [i64], values: &mut [i64]) {
    // PRE: Parallel arrays passed in are completely filled. 
    // POST: Sorts key array by values in descending order. 

    let mut needs_swap: bool = true;
    while needs_swap {
        needs_swap = false;
        for i in 0..keys.len() - 1 as usize {
            if values[i] < values[i + 1] {
                keys.swap(i, i + 1);
                values.swap(i, i + 1);
                needs_swap = true;
            }
        }
    }
}

fn main() {
    // PRE: Command line arguments are passed to determine bounds. 
    // POST: Outputs Collatz numbers by sequence length and integer size.

    let args: Vec<String> = env::args().collect();
    let mut lower: i64 = args[1].parse().unwrap();
    let mut upper: i64 = args[2].parse().unwrap();

    if lower > upper {
        mem::swap(&mut lower, &mut upper);
    }

    let mut numbers = vec![0; 10 as usize];
    let mut lengths = vec![0; 10 as usize];
    let mut counter: usize = 0;                                 // Keeps track of index in parallel arrays. 

    for i in lower..upper {
        let current: i64 = i;
        let sequence: i64 = extend_sequence(current);            // Recursive approach. 
        let temp: i32 = search_duplicates(&lengths, sequence);  // Keeps track of index that holds duplicate Collatz length.
        if counter < 10 {
            // Handle the first 10 elements to be added to the parallel arrays.
            if temp == -1 {
                numbers[counter] = i;
                lengths[counter] = sequence;
                counter += 1;
            } else {
                // Handle duplicates.
                if i < numbers[temp as usize] {
                    numbers[temp as usize] = i - 1;
                }
            }
        } else {
            // Every case afterwards. 
            if temp != -1 {
                // Handle duplicates.
                if i < numbers[temp as usize] {
                    numbers[temp as usize] = i;
                }
            } else {
                // Push out the pair with the smallest Collatz length. 
                if sequence > lengths[9] {
                    lengths[9] = sequence;
                    numbers[9] = i;
                    counter += 1;
                }
            }
        }

        bubble_sort(&mut numbers, &mut lengths);
    }
    
    // Sort based on sequence length.
    bubble_sort(&mut numbers, &mut lengths);
    println!("Sorted based on sequence length");
    for i in 0..numbers.len() as usize {
        if numbers[i] != 0 && lengths[i] != 0 {
            println!("\t{0}\t{1}", numbers[i], lengths[i]);
        }  
    }
    println!("");

    // Sort based on integer size.
    bubble_sort(&mut lengths, &mut numbers);
    println!("Sorted based on integer size");
    for i in 0..numbers.len() as usize {
        if numbers[i] != 0 && lengths[i] != 0 {
            println!("\t{0}\t{1}", numbers[i], lengths[i]);
        }  
    }
    println!("");

}
