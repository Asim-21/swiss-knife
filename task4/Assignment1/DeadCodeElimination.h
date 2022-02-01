#ifndef LLVM_TRANSFORMS_UTILS_DEADCODEELIMINATION_H
#define LLVM_TRANSFORMS_UTILS_DEADCODEELIMINATION_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class DeadCodeEliminationPass : public PassInfoMixin<DeadCodeEliminationPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
  void removeDeadInstructions(Function &F);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_DEADCODEELIMINATION_H
