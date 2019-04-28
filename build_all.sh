#! /bin/sh

# Define our build types and android toolchains here
build_types=(Debug Release)
android_toolchains=(arm-linux-androideabi-4.9 aarch64-linux-android-4.9 x86-4.9 x86_64-4.9)

for build_type in ${build_types[*]}
do
	mkdir -p .cmake_build
	cd .cmake_build

	# Test GCC
	mkdir -p LinuxGcc$build_type
	cd LinuxGcc$build_type
	CC=/usr/bin/gcc CXX=/usr/bin/g++ cmake -DCMAKE_BUILD_TYPE=$build_type -G Ninja ../..
	cmake --build . -j 4
	cd ..

	# Test Clang
	mkdir -p LinuxClang$build_type
	cd LinuxClang$build_type
	CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_BUILD_TYPE=$build_type -G Ninja ../..
	cmake --build . -j 4
	cd ..

	for toolchain in ${android_toolchains[*]}
	do
		mkdir -p Android$build_type$toolchain
		cd Android$build_type$toolchain
		cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang -DCMAKE_SYSTEM_NAME="Android" \
		-DANDROID_TOOLCHAIN_NAME=$toolchain -DANDROID_PLATFORM=android-23 -DCMAKE_BUILD_TYPE=$build_type ../..
		cmake --build . -j 4
		cd ..
	done

	cd ..
done
