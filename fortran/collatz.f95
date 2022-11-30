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
    integer(kind = 4) :: counter

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

        do while (number /= 1)
            if (mod(number, 2) == 0) then
                number = number / 2
                sequence = sequence + 1
            else
                number = (3 * number) + 1
                sequence = sequence + 1
            end if
        end do

        if (counter < 10) then
            numbers(counter) = current
            length(counter) = sequence
            counter = counter + 1
        else 
            ! Push out pair in the parallel arrays with the minimum Collatz length.
            if (sequence < minval(length) .or. &
               (sequence == minval(length) .and. number < numbers(minloc(length, 1)))) then
                ! Second conditions accounts for possibility of numbers with the same Collatz length. 
                numbers(minloc(length, 1)) = number
                length(minloc(length, 1)) = sequence
                call bubble_sort(length, numbers)
            end if
        end if
    end do

    ! Sort based on sequence length.
    call bubble_sort(numbers, length)
    print *, "Sorted based on sequence length"
    do counter = 1, 10
        print "(2i20)", numbers(counter), length(counter)
    end do

    print *, ""

    ! Sort based on integer size.
    call bubble_sort(length, numbers)
    print *, "Sorted based on integer size"
    do counter = 1, 10
        print "(2i20)", numbers(counter), length(counter)
    end do

    contains
        subroutine bubble_sort(keys, values)
            ! PRE: Parallel arrays that are passed in are completely filled. 
            ! POST: Sorts key array by values in descending order. 
            implicit none

            integer(kind = 16), intent(inout) :: keys(:)
            integer(kind = 16), intent(inout) :: values(:)

            integer :: index
            logical :: needs_swap = .true.

            integer(kind = 16) :: temp_key
            integer(kind = 16) :: temp_value

            do while (needs_swap .eqv. .true.)
                needs_swap = .false.
                do index = 1, 10
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

end program collatz
