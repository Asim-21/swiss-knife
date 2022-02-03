rm -rf reproduction/

SWISS_WORKSPACE=`pwd`
echo $SWISS_WORKSPACE

mkdir -p reproduction
cd reproduction
mkdir -p result2.1
mkdir -p result2.2

git clone https://github.com/TUM-DSE/Swiss-Knife-LLVM-Assignments.git
cd Swiss-Knife-LLVM-Assignments
cd Assignment2

# 2.1
cp $SWISS_WORKSPACE/Assignment2.1/boundschecker_pass.cpp llvmpasses/
bash run.sh | tee ../../result2.1/run.log
clang -flto -Xclang -load -Xclang ./llvmpasses/SwissBoundsChecker.so  -lm -Xlinker ./runtime_lib/obj/runtime.o ./tests/main.c ./tests/src1.c ./tests/src2.c -S
clang -flto -Xclang -load -Xclang ./llvmpasses/SwissBoundsChecker.so  -lm -Xlinker ./runtime_lib/obj/runtime.o $SWISS_WORKSPACE/example.c -S
mv ./*.s ../../result2.1/

# 2.2
cp $SWISS_WORKSPACE/Assignment2.2/boundschecker_pass.cpp llvmpasses/
bash run.sh | tee ../../result2.2/run.log
clang -flto -Xclang -load -Xclang ./llvmpasses/SwissBoundsChecker.so  -lm -Xlinker ./runtime_lib/obj/runtime.o $SWISS_WORKSPACE/example.c -S
mv ./*.s ../../result2.2/

echo done
