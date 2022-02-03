; ModuleID = './tests/src2.c'
source_filename = "./tests/src2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [25 x i8] c"> assign_malloc. %u: %d\0A\00", align 1

; Function Attrs: nounwind sspstrong uwtable
define void @assign_malloc(i8* %0, i32 %1) local_unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %2
  %5 = bitcast i8* %0 to i32*
  br label %7

6:                                                ; preds = %7, %2
  ret void

7:                                                ; preds = %4, %7
  %8 = phi i32 [ %16, %7 ], [ 0, %4 ]
  %9 = phi i32* [ %15, %7 ], [ %5, %4 ]
  %10 = mul i32 %8, 10
  %11 = bitcast i32* %9 to i8*
  %12 = tail call i8* @__runtime_checkbound(i8* %11) #2
  %13 = bitcast i8* %12 to i32*
  store i32 %10, i32* %13, align 4, !tbaa !3
  %14 = tail call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0), i32 %8, i32 %10) #2
  %15 = getelementptr i32, i32* %9, i64 1
  %16 = add nuw i32 %8, 1
  %17 = icmp eq i32 %16, %1
  br i1 %17, label %6, label %7, !llvm.loop !7
}

declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr #1

declare i8* @__runtime_checkbound(i8*) local_unnamed_addr

attributes #0 = { nounwind sspstrong uwtable "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="4" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="4" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 12.0.1"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
