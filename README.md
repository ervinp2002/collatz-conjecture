# The Collatz Conjecture

## Compilation and Execution

Fortran 95

    gfortran diffusion.f95 -O2
    gfortran recursive.f95 -O2
    ./a.out [lower bound] [upper bound]

Rust

    rustc collatrz.rs -O
    ./collatz [lower bound] [upper bound]

    rustc recursive.rs -O
    ./recursive [lower bound] [upper bound]

Julia

    chmod u+x collatz.jl
    ./collatz.jl [lower bound] [upper bound]

    chmod u+x recursive.jl
    ./recursive.jl [lower bound] [upper bound]

Go

    go run collatz.go [lower bound] [upper bound]
    go run recursive.go [lower bound] [upper bound]

Common Lisp

    chmod u+x collatz.lisp
    ./collatz.lisp [lower bound] [upper bound]

    chmod u+x recursive.lisp
    ./recursive.lisp [lower bound] [upper bound]

