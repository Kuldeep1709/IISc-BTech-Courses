# Hoist Anticipated Expressions - LLVM Pass

This repository contains a custom LLVM pass named hoist-anticipated-expressions.

### Algorithm: Hoist Anticipated Expressions


The pass runs in a continuous loop until the intermediate representation (IR) stops changing.

1. Find all unique, side effect free instructions (for example math operations and casts).
2. For every basic block B, find:
   - USE[B]: Expressions computed before any of their operands are modified locally.
   - DEF[B]: Expressions killed locally.
3. Backward Dataflow: Iteratively calculate the anticipated expressions until the sets stabilize:
   - OUT[B] = Intersection of IN[S] for all successors S.
   - IN[B] = Union of USE[B] and (OUT[B] - DEF[B])
4. Hoisting: If an expression is in OUT[B] and block B strictly dominates its successors, copy the instruction to the end of B and delete it from the successors.
5. Deduplicate (CSE): If the same expression exists multiple times globally, replace the dominated copies with the dominating one.

--------------------------------------------------------------------------------------------------------------------------

### How I Build and Ran the code

1. Go to llvm-project folder and create build folder and move to it

2. Now build (once in begining) using cmake as told in tutorial session

   cmake -G Ninja ../llvm -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++

3. Now run ninja opt after each change i make.

4. For testing I created a test.ll file in build folder and pasted all testcases in it from hoist-anticipated-expressions.ll.

5. and then inside build folder run the command:

   ./bin/opt < test.ll -passes=hoist-anticipated-expressions -S | FileCheck-18 test.ll

   I tried using Filecheck instead of Filecheck-18 but in that case it gave following error:
   bash: test.ll: No such file or directory
   FileCheck: command not found

--------------------------------------------------------------------------------------------------------------------------

## ChatGPT and AI Prompts i used while doing assignments
Mainly I google and the documentations reffered by you and here are the prompts i used.

- "Pasted the HelloWorld Pass Code" and then asked to explain how does it work and how to run the print statements and debug statemetns in helloworld pass to get familiar with llvm.

- How to hash custom struct?

- Standard API's and Data Structures i can directly use from llvm.

- How to iterate over basic blocks in reverse post order (RPO) and post order in LLVM?

- ./bin/opt < test.ll -passes=hoist-anticipated-expressions -S | FileCheck-18 test.ll

- how to run the hoist-anticipated-expressions pass code using lit
