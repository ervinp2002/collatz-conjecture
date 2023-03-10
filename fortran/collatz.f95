! Ervin Pangilinan
! CSC 330: Organization of Programming Languages - Fall 2022
! Project 3: The Collatz Conjecture
! Iterative Implementation in Fortran 95

program collatz 
    implicit none

    ! For setting bounds of range and traversing range.
    integer(kind = 16) :: lower
    integer(kind = 16) :: upper
    integer(kind = 16) :: temp
    integer(kind = 16) :: current
    character(len = 20) :: arg

    ! Parallel arrays to hold Collatz numbers and their sequence length.
    integer(kind = 16) :: numbers(10)
    integer(kind = 16) :: length(10)

    ! To be used for keeping track of number in Collatz sequence. 
    integer(kind = 16) :: number
    integer(kind = 16) :: sequence
    integer :: counter

    numbers = (/0, 0, 0, 0, 0, 0, 0, 0, 0, 0 /)
    length = (/0, 0, 0, 0, 0, 0, 0, 0, 0, 0 /)

    call get_command_argument(1, arg)
    read(arg, *) lower
    call get_command_argument(2, arg)
    read(arg, *) upper

    if (lower > upper) then
        temp = lower
        lower = upper
        upper = temp
    end if 

    ! Iterative approach to find collatz sequence of integers within range. 
    counter = 1
    do current = lower, upper
        number = current
        sequence = 0
        call extendSequence(number, sequence)       ! Iterative approach to find collatz sequence of integers within range.
        temp = searchDuplicates(length, sequence)   ! Holds index of duplicate sequence length.

        ! Handle the first 10 elements to be added to the array.
        if (counter < 10) then
            if (temp == -1) then
                numbers(counter) = current
                length(counter) = sequence
                counter = counter + 1
            else 
                ! Case for handling duplicates.
                if (current < numbers(temp)) then
                    numbers(temp) = current - 1
                end if
            end if
        else 
            ! Every case afterwards. 
            if (temp /= -1) then 
                ! Case for handling duplicates.
                if (current < numbers(temp)) then
                    numbers(temp) = current
                end if  
            else    
                ! Push out minimum pair. 
                temp = minloc(length, 1)
                if (sequence > length(temp)) then 
                    length(temp) = sequence 
                    numbers(temp) = current
                    counter = counter + 1
                end if
            end if
        end if
        
        call bubble_sort(numbers, length)
    end do

    ! Sort based on sequence length.
    call bubble_sort(numbers, length)
    print *, "Sorted based on sequence length"
    do counter = 1, size(length)
        if (numbers(counter) /= 0 .and. length(counter) /= 0) then
            print "(2i10)", numbers(counter), length(counter)
        end if
    end do

    print *, ""

    ! Sort based on integer size.
    call bubble_sort(length, numbers)
    print *, "Sorted based on integer size"
    do counter = 1, size(length)
        if (numbers(counter) /= 0 .and. length(counter) /= 0) then
            print "(2i10)", numbers(counter), length(counter)
        end if
    end do

    print *, ""

    contains
        subroutine bubble_sort(keys, values)
            ! PRE: Parallel arrays that are passed in are completely filled. 
            ! POST: Sorts key array by values in descending order. 
            implicit none

            integer(kind = 16), intent(inout) :: keys(:)
            integer(kind = 16), intent(inout) :: values(:)

            integer :: index
            logical :: needs_swap

            integer(kind = 16) :: temp_key
            integer(kind = 16) :: temp_value

            needs_swap = .true.
            do while (needs_swap .eqv. .true.)
                needs_swap = .false.
                do index = 1, size(values) - 1
                    if (values(index) < values(index + 1)) then

                        ! Temp variables to hold current.
                        temp_key = keys(index)
                        temp_value = values(index)

                        ! Move the bigger key-value pair to the front.
                        keys(index) = keys(index + 1)
                        values(index) = values(index + 1)

                        ! Move the smaller key-value pair to the back.
                        keys(index + 1) =  temp_key
                        values(index + 1) = temp_value

                        needs_swap = .true.
                    end if
                end do
            end do  

        end subroutine bubble_sort

        subroutine extendSequence(number, length)
            implicit none 
            ! PRE: Number in Collatz sequence is passed in. 
            ! POST: Changes the argument based on parity. 

            integer(kind = 16), intent(inout) :: number
            integer(kind = 16), intent(inout) :: length 
            
            do while (number /= 1)
                if (mod(number, 2) == 0) then
                    number = number / 2
                    length = length + 1
                else
                    number = (3 * number) + 1
                    length = length + 1
                end if
            end do

        end subroutine extendSequence

        integer function searchDuplicates(length, sequence)
            ! PRE: Array of sequence lengths and a Collatz sequence length is passed in. 
            ! POST: Searches if there is a another number with the same sequence length in the array.
            implicit none 

            integer(kind = 16), intent(inout) :: length(:)
            integer(kind = 16), intent(in) :: sequence 
            integer :: i

            searchDuplicates = -1
            do i = 1, size(length)
                if (length(i) == sequence) then
                    searchDuplicates = i 
                    exit
                end if
            end do

        end function searchDuplicates

end program collatz
