// RUN: mlir-opt -allow-unregistered-dialect -convert-scf-to-emitc %s | FileCheck %s
// RUN: mlir-opt -allow-unregistered-dialect -convert-to-emitc="filter-dialects=scf" %s | FileCheck %s

func.func @test_if(%arg0: i1, %arg1: f32) {
  scf.if %arg0 {
     %0 = emitc.call_opaque "func_const"(%arg1) : (f32) -> i32
  }
  return
}
// CHECK-LABEL: func.func @test_if(
// CHECK-SAME:                     %[[VAL_0:.*]]: i1,
// CHECK-SAME:                     %[[VAL_1:.*]]: f32) {
// CHECK-NEXT:    emitc.if %[[VAL_0]] {
// CHECK-NEXT:      %[[VAL_2:.*]] = call_opaque "func_const"(%[[VAL_1]]) : (f32) -> i32
// CHECK-NEXT:    }
// CHECK-NEXT:    return
// CHECK-NEXT:  }


func.func @test_if_else(%arg0: i1, %arg1: f32) {
  scf.if %arg0 {
    %0 = emitc.call_opaque "func_true"(%arg1) : (f32) -> i32
  } else {
    %0 = emitc.call_opaque "func_false"(%arg1) : (f32) -> i32
  }
  return
}
// CHECK-LABEL: func.func @test_if_else(
// CHECK-SAME:                          %[[VAL_0:.*]]: i1,
// CHECK-SAME:                          %[[VAL_1:.*]]: f32) {
// CHECK-NEXT:    emitc.if %[[VAL_0]] {
// CHECK-NEXT:      %[[VAL_2:.*]] = call_opaque "func_true"(%[[VAL_1]]) : (f32) -> i32
// CHECK-NEXT:    } else {
// CHECK-NEXT:      %[[VAL_3:.*]] = call_opaque "func_false"(%[[VAL_1]]) : (f32) -> i32
// CHECK-NEXT:    }
// CHECK-NEXT:    return
// CHECK-NEXT:  }


func.func @test_if_yield(%arg0: i1, %arg1: f32) -> (i32, f64) {
  %0 = arith.constant 0 : i8
  %x, %y = scf.if %arg0 -> (i32, f64) {
    %1 = emitc.call_opaque "func_true_1"(%arg1) : (f32) -> i32
    %2 = emitc.call_opaque "func_true_2"(%arg1) : (f32) -> f64
    scf.yield %1, %2 : i32, f64
  } else {
    %1 = emitc.call_opaque "func_false_1"(%arg1) : (f32) -> i32
    %2 = emitc.call_opaque "func_false_2"(%arg1) : (f32) -> f64
    scf.yield %1, %2 : i32, f64
  }
  return %x, %y : i32, f64
}
// CHECK-LABEL: func.func @test_if_yield(
// CHECK-SAME:                           %[[VAL_0:.*]]: i1,
// CHECK-SAME:                           %[[VAL_1:.*]]: f32) -> (i32, f64) {
// CHECK-NEXT:    %[[VAL_2:.*]] = arith.constant 0 : i8
// CHECK-NEXT:    %[[VAL_3:.*]] = "emitc.variable"() <{value = #emitc.opaque<"">}> : () -> !emitc.lvalue<i32>
// CHECK-NEXT:    %[[VAL_4:.*]] = "emitc.variable"() <{value = #emitc.opaque<"">}> : () -> !emitc.lvalue<f64>
// CHECK-NEXT:    emitc.if %[[VAL_0]] {
// CHECK-NEXT:      %[[VAL_5:.*]] = call_opaque "func_true_1"(%[[VAL_1]]) : (f32) -> i32
// CHECK-NEXT:      %[[VAL_6:.*]] = call_opaque "func_true_2"(%[[VAL_1]]) : (f32) -> f64
// CHECK-NEXT:      assign %[[VAL_5]] : i32 to %[[VAL_3]] : <i32>
// CHECK-NEXT:      assign %[[VAL_6]] : f64 to %[[VAL_4]] : <f64>
// CHECK-NEXT:    } else {
// CHECK-NEXT:      %[[VAL_7:.*]] = call_opaque "func_false_1"(%[[VAL_1]]) : (f32) -> i32
// CHECK-NEXT:      %[[VAL_8:.*]] = call_opaque "func_false_2"(%[[VAL_1]]) : (f32) -> f64
// CHECK-NEXT:      assign %[[VAL_7]] : i32 to %[[VAL_3]] : <i32>
// CHECK-NEXT:      assign %[[VAL_8]] : f64 to %[[VAL_4]] : <f64>
// CHECK-NEXT:    }
// CHECK-NEXT:    %[[VAL_9:.*]] = emitc.load %[[VAL_3]] : <i32>
// CHECK-NEXT:    %[[VAL_10:.*]] = emitc.load %[[VAL_4]] : <f64>
// CHECK-NEXT:    return %[[VAL_9]], %[[VAL_10]] : i32, f64
// CHECK-NEXT:  }
