! Ervin Pangilinan
! CSC 330: Organization of Programming Languages - Fall 2022
! Project 3: The Collatz Conjecture
! Iterative Implementation in Fortran 95

program collatz 
    implicit none

    ! For setting bounds of range and traversing range.
    integer(kind = 8) :: lower
    integer(kind = 8) :: upper
    integer(kind = 8) :: temp
    integer(kind = 8) :: current
    character(len = 20) :: arg

    ! Parallel arrays to hold Collatz numbers and their sequence length.
    integer(kind = 8) :: numbers(10)
    integer(kind = 8) :: length(10)

    call get_command_argument(1, arg)
    read(arg, *) lower
    call get_command_argument(2, arg)
    read(arg, *) upper

    if (lower > upper) then
        temp = lower
        lower = upper
        upper = temp
    end if 

    do current = lower, upper



    end do

end program collatz
