; ModuleID = 'test_ll_swift.ll'
source_filename = "test_ll_swift.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%swift.type = type { i64 }
%swift.full_existential_type = type { ptr, %swift.type }
%Any = type { [24 x i8], ptr }
%TSi = type <{ i64 }>
%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ ptr }>
%swift.metadata_response = type { ptr, i64 }

@"$sSiN" = external global %swift.type, align 8
@"$sypN" = external global %swift.full_existential_type
@"\01l_entry_point" = private constant { i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (ptr @main to i64), i64 ptrtoint (ptr @"\01l_entry_point" to i64)) to i32), i32 0 }, section "swift5_entry", align 4
@".str.1.\0A" = private unnamed_addr constant [2 x i8] c"\0A\00"
@".str.1. " = private unnamed_addr constant [2 x i8] c" \00"
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [102 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00-lswift_Concurrency\00-lswift_StringProcessing\00-lswift_RegexParser\00", section ".swift1_autolink_entries", no_sanitize_address, align 8
@llvm.used = appending global [4 x ptr] [ptr @main, ptr @"\01l_entry_point", ptr @__swift_reflection_version, ptr @_swift1_autolink_entries], section "llvm.metadata"

define protected i32 @main(i32 %0, ptr %1) #0 {
entry:
  %2 = call swiftcc { ptr, ptr } @"$ss27_allocateUninitializedArrayySayxG_BptBwlFyp_Tg5"(i64 1)
  %3 = extractvalue { ptr, ptr } %2, 0
  %4 = extractvalue { ptr, ptr } %2, 1
  %5 = call swiftcc i64 @"$s13test_ll_swift3sqr1nS2i_tF"(i64 100)
  %6 = getelementptr inbounds %Any, ptr %4, i32 0, i32 1
  store ptr @"$sSiN", ptr %6, align 8
  %7 = getelementptr inbounds %Any, ptr %4, i32 0, i32 0
  %8 = getelementptr inbounds %Any, ptr %4, i32 0, i32 0
  %._value = getelementptr inbounds %TSi, ptr %8, i32 0, i32 0
  store i64 %5, ptr %._value, align 8
  %9 = call swiftcc ptr @"$ss27_finalizeUninitializedArrayySayxGABnlF"(ptr %3, ptr getelementptr inbounds (%swift.full_existential_type, ptr @"$sypN", i32 0, i32 1))
  %10 = call swiftcc { i64, ptr } @"$ss5print_9separator10terminatoryypd_S2StFfA0_"()
  %11 = extractvalue { i64, ptr } %10, 0
  %12 = extractvalue { i64, ptr } %10, 1
  %13 = call swiftcc { i64, ptr } @"$ss5print_9separator10terminatoryypd_S2StFfA1_"()
  %14 = extractvalue { i64, ptr } %13, 0
  %15 = extractvalue { i64, ptr } %13, 1
  call swiftcc void @"$ss5print_9separator10terminatoryypd_S2StF"(ptr %9, i64 %11, ptr %12, i64 %14, ptr %15)
  call void @swift_bridgeObjectRelease(ptr %15) #1
  call void @swift_bridgeObjectRelease(ptr %12) #1
  call void @swift_release(ptr %9) #1
  ret i32 0
}

declare swiftcc { ptr, ptr } @"$ss27_allocateUninitializedArrayySayxG_BptBwlFyp_Tg5"(i64) #0

define hidden swiftcc i64 @"$s13test_ll_swift3sqr1nS2i_tF"(i64 %0) #0 {
entry:
  %n.debug = alloca i64, align 8
  call void @llvm.memset.p0.i64(ptr align 8 %n.debug, i8 0, i64 8, i1 false)
  store i64 %0, ptr %n.debug, align 8
  %1 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %0, i64 %0)
  %2 = extractvalue { i64, i1 } %1, 0
  %3 = extractvalue { i64, i1 } %1, 1
  %4 = call i1 @llvm.expect.i1(i1 %3, i1 false)
  br i1 %4, label %6, label %5

5:                                                ; preds = %entry
  ret i64 %2

6:                                                ; preds = %entry
  call void @llvm.trap()
  unreachable
}

define linkonce_odr hidden swiftcc ptr @"$ss27_finalizeUninitializedArrayySayxGABnlF"(ptr %0, ptr %Element) #0 {
entry:
  %Element1 = alloca ptr, align 8
  %1 = alloca %TSa, align 8
  store ptr %Element, ptr %Element1, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr %1)
  %._buffer = getelementptr inbounds %TSa, ptr %1, i32 0, i32 0
  %._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, ptr %._buffer, i32 0, i32 0
  store ptr %0, ptr %._buffer._storage, align 8
  %2 = call swiftcc %swift.metadata_response @"$sSaMa"(i64 0, ptr %Element) #7
  %3 = extractvalue %swift.metadata_response %2, 0
  call swiftcc void @"$sSa12_endMutationyyF"(ptr %3, ptr nocapture swiftself dereferenceable(8) %1)
  %._buffer2 = getelementptr inbounds %TSa, ptr %1, i32 0, i32 0
  %._buffer2._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, ptr %._buffer2, i32 0, i32 0
  %4 = load ptr, ptr %._buffer2._storage, align 8
  call void @llvm.lifetime.end.p0(i64 8, ptr %1)
  ret ptr %4
}

define linkonce_odr hidden swiftcc { i64, ptr } @"$ss5print_9separator10terminatoryypd_S2StFfA0_"() #0 {
entry:
  %0 = call swiftcc { i64, ptr } @"$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC"(ptr @".str.1. ", i64 1, i1 true)
  %1 = extractvalue { i64, ptr } %0, 0
  %2 = extractvalue { i64, ptr } %0, 1
  %3 = insertvalue { i64, ptr } undef, i64 %1, 0
  %4 = insertvalue { i64, ptr } %3, ptr %2, 1
  ret { i64, ptr } %4
}

define linkonce_odr hidden swiftcc { i64, ptr } @"$ss5print_9separator10terminatoryypd_S2StFfA1_"() #0 {
entry:
  %0 = call swiftcc { i64, ptr } @"$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC"(ptr @".str.1.\0A", i64 1, i1 true)
  %1 = extractvalue { i64, ptr } %0, 0
  %2 = extractvalue { i64, ptr } %0, 1
  %3 = insertvalue { i64, ptr } undef, i64 %1, 0
  %4 = insertvalue { i64, ptr } %3, ptr %2, 1
  ret { i64, ptr } %4
}

declare swiftcc void @"$ss5print_9separator10terminatoryypd_S2StF"(ptr, i64, ptr, i64, ptr) #0

; Function Attrs: nounwind
declare void @swift_bridgeObjectRelease(ptr) #1

; Function Attrs: nounwind
declare void @swift_release(ptr) #1

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i1 @llvm.expect.i1(i1, i1) #4

; Function Attrs: cold noreturn nounwind memory(inaccessiblemem: write)
declare void @llvm.trap() #5

declare swiftcc { i64, ptr } @"$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC"(ptr, i64, i1) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #6

define linkonce_odr hidden swiftcc void @"$sSa12_endMutationyyF"(ptr %"Array<Element>", ptr nocapture swiftself dereferenceable(8) %0) #0 {
entry:
  %._buffer = getelementptr inbounds %TSa, ptr %0, i32 0, i32 0
  %._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, ptr %._buffer, i32 0, i32 0
  %1 = load ptr, ptr %._buffer._storage, align 8
  %._buffer1 = getelementptr inbounds %TSa, ptr %0, i32 0, i32 0
  %._buffer1._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, ptr %._buffer1, i32 0, i32 0
  store ptr %1, ptr %._buffer1._storage, align 8
  ret void
}

declare swiftcc %swift.metadata_response @"$sSaMa"(i64, ptr) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #6

attributes #0 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #5 = { cold noreturn nounwind memory(inaccessiblemem: write) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { nounwind memory(none) }

!swift.module.flags = !{!0}
!llvm.linker.options = !{}
!llvm.module.flags = !{!1, !2, !3, !4, !5, !6}

!0 = !{!"standard-library", i1 false}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 4, !"Objective-C Garbage Collection", i32 100796160}
!6 = !{i32 1, !"Swift Version", i32 7}
