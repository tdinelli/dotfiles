# commands
alias ll="ls -lh"
alias la="ls -altrh"
alias vim="nvim"
alias vimdiff="nvim -d"
alias vi="nvim"

# tmux
alias tmux="tmux -2"
alias tls="tmux ls"
alias tms="tmux a"

# git
alias gs="git status"

# HomeBrew
alias brew="HOMEBREW_NO_AUTO_UPDATE=1 brew"

# Numerical Libraries
export NUMERICAL_LIBRARIES="$HOME/NumericalLibraries"

switch_compiler() {
    if [[ "$1" == "gnu" ]]; then
        export CC=/opt/homebrew/bin/gcc-14
        export CXX=/opt/homebrew/bin/g++-14
        export FC=/opt/homebrew/bin/gfortran-14

        export Boost_ROOT=$NUMERICAL_LIBRARIES/boost/boost-1.85.0-gcc-14.1.0
        export BLAS_ROOT=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-gcc-14.1.0
        export OpenBLAS_DIR=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-gcc-14.1.0/lib/cmake/openblas
    elif [[ "$1" == "llvm" ]]; then
        export CC=/opt/homebrew/opt/llvm/bin/clang
        export CXX=/opt/homebrew/opt/llvm/bin/clang++
        export FC=/opt/homebrew/bin/gfortran-14
        # One day will be flang
        # export FC=/opt/homebrew/opt/llvm/bin/flang

        export Enzyme_DIR=opt/homebrew/Cellar/enzyme/0.0.103/lib/cmake/Enzyme
        export Boost_ROOT=$HOME/NumericalLibraries/boost/boost-1.83.0-clang-17.0.1/
        export BLAS_ROOT=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-clang-18.1.7
        export OpenBLAS_DIR=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-clang-18.1.7/lib/cmake/openblas
        export GSL_ROOT_DIR=$NUMERICAL_LIBRARIES/gsl/gsl-2.8-clang-18.1.7
        export Dakota_DIR=$NUMERICAL_LIBRARIES/dakota/dakota-6.19.0-clang-18.1.7/lib/cmake/Dakota
    else
        echo "Usage: switch_compiler [gnu | llvm]"
        return 1
    fi

    export OpenSMOKEpp_ROOT="$HOME/Documents/GitHub/OpenSMOKEpp"
    export OpenSMOKEppSolvers_ROOT="$HOME/Documents/GitHub/OpenSMOKEppSolvers"
    export Eigen3_ROOT="$NUMERICAL_LIBRARIES/eigen/eigen-3.4.0/share/eigen3/cmake"
    return 0
}
# By default llvm is the compiler
switch_compiler llvm

# libraries
alias set-gfortran="export DYLD_LIBRARY_PATH=/opt/homebrew/opt/gfortran/lib/gcc/14:$DYLD_LIBRARY_PATH"
alias set-dakota-6.19.0-clang="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/dakota/dakota-6.19.0-clang-18.1.7/bin:$DYLD_LIBRARY_PATH; export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/dakota/dakota-6.19.0-clang-18.1.7/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.26-clang="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-clang-18.1.7/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.26-gcc="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.26-gcc-14.1.0/lib:$DYLD_LIBRARY_PATH"
alias set-boost-1.83.0-clang="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/boost/boost-1.83.0-clang-17.0.1/lib:$DYLD_LIBRARY_PATH"
alias set-boost-1.85.0-gcc="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/boost/boost-1.85.0-gcc-14.1.0/lib:$DYLD_LIBRARY_PATH"

# tools
alias set-numdiff="export PATH=$HOME/.tools/numdiff/numdiff-5.9.0/bin:$PATH"
alias set-devsmoke="export PATH=$HOME/.tools/opensmoke/devsmoke/bin:$PATH;set-boost-1.85.0-gcc"
alias set-sootsmoke="export PATH=/Users/tdinelli/Documents/GitHub/SootGen/build:$PATH"
set-optismoke() {
    export PATH=$HOME/Documents/GitHub/OptiSMOKE_toolbox/build:$PATH
    export DYLD_LIBRARY_PATH=$HOME/NumericalLibraries/openblas/openblas-0.3.26-clang-18.1.7/lib:$DYLD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH=/opt/homebrew/opt/gfortran/lib/gcc/14:$DYLD_LIBRARY_PATH
}
