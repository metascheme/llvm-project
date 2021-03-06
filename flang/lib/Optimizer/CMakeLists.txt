if (LLVM_COMPILER_IS_GCC_COMPATIBLE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-parameter -Wno-error")
endif ()
get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)

add_flang_library(FIROptimizer
  Dialect/FIRAttr.cpp
  Dialect/FIRDialect.cpp
  Dialect/FIROps.cpp
  Dialect/FIRType.cpp

  Support/InternalNames.cpp
  Support/KindMapping.cpp

  Transforms/Inliner.cpp

  DEPENDS
  FIROpsIncGen
  FIROptTransformsPassIncGen
  ${dialect_libs}

  LINK_LIBS
  ${dialect_libs}
  MLIRTargetLLVMIR
  MLIRTargetLLVMIRModuleTranslation

  LINK_COMPONENTS
  AsmParser
  AsmPrinter
  Remarks
)
