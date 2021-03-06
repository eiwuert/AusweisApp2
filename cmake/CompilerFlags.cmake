ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-DQT_MESSAGELOGCONTEXT)
ADD_DEFINITIONS(-DQT_NO_CAST_FROM_BYTEARRAY)
ADD_DEFINITIONS(-DQT_NO_CAST_TO_ASCII)
ADD_DEFINITIONS(-DQT_RESTRICTED_CAST_FROM_ASCII)
ADD_DEFINITIONS(-DQT_NO_FOREACH)
ADD_DEFINITIONS(-DQT_NO_KEYWORDS)
ADD_DEFINITIONS(-DQT_NO_EXCEPTIONS)

IF(QT_VENDOR STREQUAL "Governikus")
	ADD_DEFINITIONS(-DGOVERNIKUS_QT)
ENDIF()

IF(CMAKE_VERSION VERSION_LESS 3.2)
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
ELSE()
	SET(CMAKE_CXX_STANDARD 11)
	SET(CMAKE_CXX_STANDARD_REQUIRED ON)
ENDIF()

IF(NOT DEFINED WARNINGS_ARE_ERRORS AND VENDOR_GOVERNIKUS)
	SET(WARNINGS_ARE_ERRORS ON)
ENDIF()


IF(MSVC)
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3")
	IF(WARNINGS_ARE_ERRORS)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /WX")
	ENDIF()
ELSE()
	ADD_DEFINITIONS(-DQT_STRICT_ITERATORS)

	STRING(REPLACE "-fexceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic -Wcast-qual -Wshadow -Wvla")

	ADD_FLAG(-fno-exceptions)
	ADD_FLAG(-fstack-protector-strong -fstack-protector)
	ADD_FLAG(-fuse-ld=gold VAR CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS LINK -fuse-ld=gold)
	ADD_FLAG(-Wconversion)
	ADD_FLAG(-Wloop-analysis)
	ADD_FLAG(-Wlogical-op)
	ADD_FLAG(-Wmisleading-indentation)
	ADD_FLAG(-Wduplicated-cond)
	ADD_FLAG(-Wweak-vtables)
	ADD_FLAG(-Wcovered-switch-default)
	ADD_FLAG(-Wno-gnu-zero-variadic-macro-arguments) # Qt (qDebug) is not compatible

	IF(ANDROID)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -finline-limit=64")
		SET(CMAKE_CXX_VISIBILITY_PRESET hidden)
	ENDIF()

	IF("${CMAKE_BUILD_TYPE}" STREQUAL "RELEASE")
		ADD_FLAG(-flto VAR CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS LINK -flto)
	ENDIF()


	IF(WARNINGS_ARE_ERRORS AND NOT CMAKE_GENERATOR STREQUAL Xcode)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
	ENDIF()

	IF(CMAKE_COMPILER_IS_GNUCXX)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=shadow")
	ENDIF()

	IF(APPLE AND NOT CMAKE_SYSTEM_VERSION VERSION_LESS 14)
		# Allow warning for LSSharedFileListItemResolve since we support OSX 10.9, too!
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=deprecated-declarations")
	ENDIF()

	SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")

	IF(SANITIZER)
		IF(CMAKE_COMPILER_IS_GNUCXX)
			ADD_FLAG("-fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -fno-optimize-sibling-calls" LINK -fsanitize=address -fsanitize=undefined)
		ELSE()
			ADD_FLAG("-fsanitize=address -fsanitize=undefined -fsanitize=unsigned-integer-overflow -fsanitize-address-use-after-scope -fno-omit-frame-pointer -fno-optimize-sibling-calls" LINK -fsanitize=address -fsanitize=undefined)
		ENDIF()
	ENDIF()
ENDIF()

# enable Objective-C support on MacOS X
IF(APPLE)
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ObjC++")
ENDIF()


INCLUDE(CompilerFlagsPersoSim)


# http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
# http://llvm.org/docs/CommandGuide/llvm-cov.html
OPTION(COVERAGE "Enable code coverage")
IF(COVERAGE)
	MESSAGE(STATUS "Enable code coverage instrumentation")
	ADD_FLAG(--coverage LINK --coverage VAR CMAKE_CXX_FLAGS_DEBUG)
ENDIF()
