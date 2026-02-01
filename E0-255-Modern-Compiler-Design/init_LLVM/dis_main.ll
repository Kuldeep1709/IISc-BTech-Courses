; ModuleID = 'main.bc'
source_filename = "main.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local noundef i32 @main() {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  ret i32 0
}
