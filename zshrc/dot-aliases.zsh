# commands
alias ll="ls -lh"
alias la="ls -altrh"
alias vim="nvim"
alias vimdiff="nvim -d"
alias vi="nvim"

# tmux
alias tmux="tmux -2"
alias tls="tmux ls"

# git
alias gs="git status"

# Numerical Libraries
export NUMERICAL_LIBRARIES="$HOME/NumericalLibraries"

switch_compiler() {
    if [[ "$1" == "gnu" ]]; then
        export CC="/opt/homebrew/bin/gcc-13"
        export CXX="/opt/homebrew/bin/g++-13"
        export FC="/opt/homebrew/bin/gfortran-13"

        export Boost_ROOT="$NUMERICAL_LIBRARIES/boost/boost-1.83.0-gcc-13.2.0"
        export BLAS_ROOT="$NUMERICAL_LIBRARIES/openblas/openblas-0.3.24-gcc-13.2.0"
    elif [[ "$1" == "llvm" ]]; then
        export CC="/opt/homebrew/opt/llvm/bin/clang"
        export CXX="/opt/homebrew/opt/llvm/bin/clang++"
        export FC="/opt/homebrew/bin/gfortran-13"
        # One day will be flang
        # export FC="/opt/homebrew/opt/llvm/bin/flang"

        export Enzyme_DIR="/opt/homebrew/Cellar/enzyme/0.0.103/lib/cmake/Enzyme/"
        export Boost_ROOT="$NUMERICAL_LIBRARIES/boost/boost-1.83.0-clang-17.0.1"
        export BLAS_ROOT="$NUMERICAL_LIBRARIES/openblas/openblas-0.3.24-clang-17.0.3"
    else
        echo "Usage: switch_compiler [gnu|llvm]"
        return 1
    fi

    export autodiff_DIR=$NUMERICAL_LIBRARIES/autodiff/lib/cmake/autodiff/
    export OpenSMOKEpp_ROOT="$HOME/Documents/GitHub/OpenSMOKEpp"
    export OpenSMOKEppSolvers_ROOT="$HOME/Documents/GitHub/OpenSMOKEppSolvers"
    export Eigen3_ROOT="$NUMERICAL_LIBRARIES/eigen/eigen-3.4.0/share/eigen3/cmake"
    export CEQ_ROOT="$NUMERICAL_LIBRARIES/ceq/lib/linux/"
    return 0
}
# By default llvm is the compiler
switch_compiler llvm

# libraries
alias set-dakota-6.19.0-clang="export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/dakota/dakota-6.19.0-clang-17.0.3/lib:$DYLD_LIBRARY_PATH"
alias set-boost-1.83.0-clang="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/boost/boost-1.83.0-clang-17.0.1/lib:$DYLD_LIBRARY_PATH"
alias set-boost-1.83.0-gcc="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/boost/boost-1.83.0-gcc-13.2.0/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.24-clang="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.24-clang-17.0.3/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.24-gcc="export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.24-gcc-13.2.0/lib:$DYLD_LIBRARY_PATH"
alias set-gfortran-13="export DYLD_LIBRARY_PATH=/opt/homebrew/opt/gfortran/lib/gcc/13:$DYLD_LIBRARY_PATH"

# tools
alias set-geir="export PATH=$HOME/.tools/geirDA:$PATH"
alias set-numdiff="export PATH=$HOME/.tools/numdiff/numdiff-5.9.0/bin:$PATH"
alias set-opensmoke-0.21.0="export PATH=$HOME/.tools/opensmoke/opensmoke-0.21.0/bin:$PATH; set-boost-1.83.0-gcc"
alias set-opensmoke-0.20.0="export PATH=$HOME/.tools/opensmoke/opensmoke-0.20.0/bin:$PATH; set-boost-1.83.0-gcc"
alias set-zrk="export DYLD_LIBRARY_PATH=$HOME/.tools/zero-rk/lib:$DYLD_LIBRARY_PATH;export PATH=$HOME/.tools/zero-rk/bin:$PATH"


export DYLD_LIBRARY_PATH=/opt/homebrew/opt/gfortran/lib/gcc/13:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$NUMERICAL_LIBRARIES/openblas/openblas-0.3.24-clang-17.0.3/lib:$DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/dakota/dakota-6.19.0-clang-17.0.3/lib:$DYLD_LIBRARY_PATH
alias set-optismoke="export PATH=$HOME/Documents/GitHub/OptiSMOKE_toolbox/build:$PATH"
alias set-devsmoke="export PATH=$HOME/.tools/opensmoke/devsmoke/bin:$PATH;set-boost-1.83.0-gcc"

# Basilisk
alias set-basilisk="export BASILISK=/Users/tdinelli/Documents/GitHub/basilisk/src; export PATH=$PATH:$BASILISK"
