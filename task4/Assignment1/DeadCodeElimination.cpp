//===-- DeadCodeElimination.cpp - Example Transformations --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Utils/DeadCodeElimination.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"

using namespace llvm;

PreservedAnalyses DeadCodeEliminationPass::run(Function &F,
                                      FunctionAnalysisManager &AM) {
  removeDeadInstructions(F);
  return PreservedAnalyses::all();
}

void DeadCodeEliminationPass::removeDeadInstructions(Function &F) {
  SmallPtrSet<Instruction *, 32> aliveSet;
  SmallVector<Instruction *, 128> tempSet;

  // get all alive instructions
  for (Instruction &I: instructions(F)) {
    if (!I.isSafeToRemove()) {
      aliveSet.insert(&I);
      tempSet.push_back(&I);
    }
  }

  // get all instructions affected by alive instructions
  while (!tempSet.empty()) {
    Instruction *aliveInst = tempSet.pop_back_val();
    for (Use &oi: aliveInst->operands()) {
      if (Instruction *inst = dyn_cast<Instruction>(oi)) {
        if (aliveSet.insert(inst).second) {
          tempSet.push_back(inst);	// duplicated instructions
        }
      }
    }
  }

  // clean up dead instructions
  for (Instruction &I: instructions(F)) {
    if (!aliveSet.count(&I)) {
      tempSet.push_back(&I);
      I.dropAllReferences();
    }
  }

  for (Instruction *&I: tempSet) {
    I->eraseFromParent();
  }

  return;
}
