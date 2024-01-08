# --- commands
alias ll="ls -lh"
alias la="ls -altrh"
alias vim="nvim"
alias vi="nvim"

# --- libraries
alias set-boost-1.83.0-clang="export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/boost/boost-1.83.0-clang-17.0.1/lib:$DYLD_LIBRARY_PATH"
alias set-boost-1.83.0-gcc="export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/boost/boost-1.83.0-gcc-13.2.0/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.24-clang="export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/openblas/openblas-0.3.24-clang-17.0.3/lib:$DYLD_LIBRARY_PATH"
alias set-openblas-0.3.24-gcc="export DYLD_LIBRARY_PATH=/Users/tdinelli/NumericalLibraries/openblas/openblas-0.3.24-gcc-13.2.0/lib:$DYLD_LIBRARY_PATH"
alias set-gfortran-13="export DYLD_LIBRARY_PATH=/opt/homebrew/opt/gfortran/lib/gcc/13:$DYLD_LIBRARY_PATH"

# --- tools
alias set-optismoke="export PATH=/Users/tdinelli/Documents/GitHub/OptiSMOKE_toolbox/build:$PATH"
alias set-opensmoke-0.21.0="export PATH=/Users/tdinelli/Tools/opensmoke/opensmoke-0.21.0/bin:$PATH; set-boost-1.83.0-gcc"
alias set-opensmoke-0.20.0="export PATH=/Users/tdinelli/Tools/opensmoke/opensmoke-0.20.0/bin:$PATH; set-boost-1.83.0-gcc"
alias set-devsmoke="export PATH=/Users/tdinelli/Documents/GitHub/OpenSMOKEppSolvers/build:$PATH; set-boost-1.83.0-gcc"
alias set-numdiff="export PATH=/Users/tdinelli/Tools/numdiff/numdiff-5.9.0/bin:$PATH"

