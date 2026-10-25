; RUN: opt < %s -passes=hoist-anticipated-expressions -S | FileCheck %s

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

attributes #2 = { nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

; metadata
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"any pointer", !5, i64 0}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}

; Generated from an if/else.

; CHECK-LABEL: @simple_if_else
define dso_local i32 @simple_if_else(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 2
  br i1 %3, label %4, label %8

4:                                                ; preds = %2
  %5 = mul i32 %0, %0
  %6 = add i32 %5, %0
  %7 = add i32 %6, 5
  br label %12
  ; Only one instance of mul + add + add should be left.
  ; CHECK: %[[M:.*]] = mul i32
  ; CHECK: add {{.*}} %[[M]]
  ; CHECK: add
  ; CHECK-NOT: mul
  ; CHECK-NOT: add
  ; CHECK: ret

8:                                                ; preds = %2
  %9 = mul i32 %0, %0
  %10 = add i32 %9, %0
  %11 = add i32 %10, 5
  br label %12

12:                                               ; preds = %8, %4
  %13 = phi i32 [ %7, %4 ], [ %11, %8 ]
  ret i32 %13
}

; A multiple if/else if/else block with anticipated expressions.

; CHECK-LABEL: @simple_if_else_multiple
define dso_local i32 @simple_if_else_multiple(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 3
  br i1 %3, label %4, label %8

4:                                                ; preds = %2
  %5 = mul i32 %0, %0
  %6 = add i32 %5, %0
  %7 = add i32 %6, 5
  br label %18
  ; Only one instance of mul + add + add should be left.
  ; CHECK: mul
  ; CHECK: add
  ; CHECK: add
  ; CHECK-NOT: mul
  ; CHECK-NOT: add
  ; CHECK: ret

8:                                                ; preds = %2
  %9 = icmp ugt i32 %0, 2
  br i1 %9, label %10, label %14

10:                                               ; preds = %8
  %11 = mul i32 %0, %0
  %12 = add i32 %11, %0
  %13 = add i32 %12, 5
  br label %18

14:                                               ; preds = %8
  %15 = mul i32 %0, %0
  %16 = add i32 %15, %0
  %17 = add i32 %16, 5
  br label %18

18:                                               ; preds = %10, %14, %4
  %19 = phi i32 [ %7, %4 ], [ %13, %10 ], [ %17, %14 ]
  ret i32 %19
}

; No optimization needs to be performed on the memory form (it's okay to not
; optimize and so we don't check anything here except that the pass shouldn't
; crash on this.
; CHECK: if_else_memory
define dso_local i32 @if_else_memory(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %6, align 4
  %8 = load i32, ptr %6, align 4
  %9 = icmp ugt i32 %8, 2
  br i1 %9, label %10, label %17

10:                                               ; preds = %2
  %11 = load i32, ptr %6, align 4
  %12 = load i32, ptr %6, align 4
  %13 = mul i32 %11, %12
  %14 = load i32, ptr %6, align 4
  %15 = add i32 %13, %14
  %16 = add i32 %15, 5
  store i32 %16, ptr %6, align 4
  br label %24

17:                                               ; preds = %2
  %18 = load i32, ptr %6, align 4
  %19 = load i32, ptr %6, align 4
  %20 = mul i32 %18, %19
  %21 = load i32, ptr %6, align 4
  %22 = add i32 %20, %21
  %23 = add i32 %22, 3
  store i32 %23, ptr %6, align 4
  br label %24

24:                                               ; preds = %17, %10
  %25 = load i32, ptr %6, align 4
  ret i32 %25
}

; Generated from a simple for loop.

; CHECK-LABEL: @for_loop_invariant_expr
define dso_local i32 @for_loop_invariant_expr(i32 noundef %0, ptr noundef %1) #0 {
  br label %3

3:                                                ; preds = %9, %2
  %4 = phi i32 [ 0, %2 ], [ %12, %9 ]
  %5 = icmp ult i32 %4, 10
  br i1 %5, label %9, label %6

6:                                                ; preds = %3
  %7 = mul nsw i32 %0, %0
  %8 = srem i32 %7, %0
  ret i32 %8

9:                                                ; preds = %3
  %10 = mul nsw i32 %0, %0
  %11 = srem i32 %10, %0
  %12 = add i32 %4, 1
  br label %3
  ; CHECK: %[[M:.*]] = mul
  ; CHECK: srem i32 %[[M]], %{{.*}}
  ; CHECK-NOT: mul
  ; CHECK-NOT: srem
  ; CHECK: ret
}

; Generated from a switch statement.

; CHECK: @switch
define dso_local i32 @switch(i32 noundef %0, ptr noundef %1) #0 {
  switch i32 %0, label %11 [
    i32 0, label %3
    i32 1, label %3
    i32 2, label %7
    i32 3, label %7
  ]

  ; CHECK: mul
  ; CHECK: add
  ; CHECK: add
  ; CHECK-NOT: mul
  ; CHECK-NOT: mul
  ; CHECK: ret

3:                                                ; preds = %2, %2
  %4 = mul i32 %0, %0
  %5 = add i32 %4, %0
  %6 = add i32 %5, 3
  br label %15

7:                                                ; preds = %2, %2
  %8 = mul i32 %0, %0
  %9 = add i32 %8, %0
  %10 = add i32 %9, 3
  br label %15

11:                                               ; preds = %2
  %12 = mul i32 %0, %0
  %13 = add i32 %12, %0
  %14 = add i32 %13, 3
  br label %15

15:                                               ; preds = %11, %7, %3
  %16 = phi i32 [ %14, %11 ], [ %10, %7 ], [ %6, %3 ]
  ret i32 %16
}

; if/else with a math function call.

attributes #3 = { nounwind }

; Function Attrs: nounwind
declare dso_local double @exp(double noundef) #2

; Function Attrs: nounwind uwtable
; CHECK: @if_else_math_call
define dso_local i32 @if_else_math_call(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 3
  br i1 %3, label %4, label %12

  ; CHECK: mul
  ; CHECK: call double @exp
  ; CHECK-NOT: call

4:                                                ; preds = %2
  %5 = mul i32 %0, %0
  %6 = uitofp i32 %5 to double
  %7 = uitofp i32 %0 to double
  %8 = call double @exp(double noundef %7) #3
  %9 = fadd double %6, %8
  %10 = fadd double %9, 5.000000e+00
  %11 = fptoui double %10 to i32
  br label %30

12:                                               ; preds = %2
  %13 = icmp ugt i32 %0, 2
  br i1 %13, label %14, label %22

14:                                               ; preds = %12
  %15 = mul i32 %0, %0
  %16 = uitofp i32 %15 to double
  %17 = uitofp i32 %0 to double
  %18 = call double @exp(double noundef %17) #3
  %19 = fadd double %16, %18
  %20 = fadd double %19, 3.000000e+00
  %21 = fptoui double %20 to i32
  br label %30

22:                                               ; preds = %12
  %23 = mul i32 %0, %0
  %24 = uitofp i32 %23 to double
  %25 = uitofp i32 %0 to double
  %26 = call double @exp(double noundef %25) #3
  %27 = fadd double %24, %26
  %28 = fadd double %27, 1.000000e+00
  %29 = fptoui double %28 to i32
  br label %30

30:                                               ; preds = %14, %22, %4
  %31 = phi i32 [ %11, %4 ], [ %21, %14 ], [ %29, %22 ]
  ret i32 %31
}

; if/else with multiple redundant expressions in the block.

; Function Attrs: nounwind uwtable
; CHECK-LABEL: @if_else_multiple_redundant_exprs
define dso_local i32 @if_else_multiple_redundant_exprs(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 2
  br i1 %3, label %4, label %9

  ; There should be only one mul left
  ; CHECK: mul
  ; CHECK-NOT: mul
  ; CHECK: ret

4:                                                ; preds = %2
  %5 = mul i32 %0, %0
  %6 = add i32 %5, %0
  %7 = add i32 %6, 5
  %8 = add i32 %7, 5
  br label %14

9:                                                ; preds = %2
  %10 = mul i32 %0, %0
  %11 = add i32 %10, %0
  %12 = add i32 %11, 3
  %13 = mul i32 %0, %0
  br label %14

14:                                               ; preds = %9, %4
  %15 = phi i32 [ %8, %4 ], [ %13, %9 ]
  %16 = phi i32 [ %7, %4 ], [ %12, %9 ]
  %17 = add i32 %16, %15
  ret i32 %17
}

; CHECK: @not_anticipated_for_loop
define dso_local i32 @not_anticipated_for_loop(i32 noundef %0, ptr noundef %1) {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi i32 [ undef, %2 ], [ %10, %8 ]
  %5 = phi i32 [ 0, %2 ], [ %11, %8 ]
  %6 = icmp ult i32 %5, 10
  br i1 %6, label %8, label %7

7:                                                ; preds = %3
  ret i32 %4

  ; CHECK: mul
  ; CHECK-NEXT: srem
  ; CHECK-NEXT: add
  ; CHECK-NEXT: br label %{{.*}}, !llvm.loop

8:                                                ; preds = %3
  %9 = mul nsw i32 %0, %0
  %10 = srem i32 %9, %0
  %11 = add i32 %5, 1
  br label %3, !llvm.loop !3
}

; Not anticipated expression here.
; CHECK: @not_anticipated_switch
define dso_local i32 @not_anticipated_switch(i32 noundef %0, ptr noundef %1) {
  switch i32 %0, label %8 [
    i32 0, label %3
    i32 1, label %3
    i32 2, label %3
  ]
  ; CHECK: urem
  ; CHECK-NEXT: mul
  ; CHECK-NEXT: add
  ; CHECK-NEXT: add


  ; CHECK: mul
  ; CHECK-NEXT: add
  ; CHECK-NEXT: add

3:                                                ; preds = %2, %2, %2
  %4 = urem i32 %0, 2
  %5 = mul i32 %4, %4
  %6 = add i32 %5, %4
  %7 = add i32 %6, 3
  br label %12

8:                                                ; preds = %2
  %9 = mul i32 %0, %0
  %10 = add i32 %9, %0
  %11 = add i32 %10, 2
  br label %12

12:                                               ; preds = %8, %3
  %13 = phi i32 [ %11, %8 ], [ %7, %3 ]
  ret i32 %13
}