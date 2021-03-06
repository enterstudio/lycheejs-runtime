#!/bin/bash

LYCHEEJS_ROOT=$(cd "$(dirname "$0")/../../../"; pwd);
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);
PROJECT_NAME="$2";
PROJECT_ROOT="$LYCHEEJS_ROOT$1";
BUILD_ID=`basename $PROJECT_ROOT`;


LINUX_AVAILABLE=0;
LINUX_STATUS=1;
OSX_AVAILABLE=0;
OSX_STATUS=1;
WINDOWS_AVAILABLE=0;
WINDOWS_STATUS=1;



_package_linux () {

	if [ -d "./$BUILD_ID-linux" ]; then
		rm -rf "./$BUILD_ID-linux";
	fi;

	mkdir "$BUILD_ID-linux";


	if [ -d "$RUNTIME_ROOT/linux/arm" ]; then

		LINUX_AVAILABLE=1;

		mkdir "$BUILD_ID-linux/arm";
		cp "$RUNTIME_ROOT/linux/arm/node" "$BUILD_ID-linux/arm/node";
		cp "$RUNTIME_ROOT/linux/arm/init.sh" "$BUILD_ID-linux/arm/$PROJECT_NAME.sh";
		cp "$BUILD_ID/core.js" "$BUILD_ID-linux/arm/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-linux/arm/index.js";
		chmod +x "$BUILD_ID-linux/arm/node";
		chmod +x "$BUILD_ID-linux/arm/$PROJECT_NAME.sh";

	fi;

	if [ -d "$RUNTIME_ROOT/linux/x86" ]; then

		LINUX_AVAILABLE=1;

		mkdir "$BUILD_ID-linux/x86";
		cp "$RUNTIME_ROOT/linux/x86/node" "$BUILD_ID-linux/x86/node";
		cp "$RUNTIME_ROOT/linux/x86/init.sh" "$BUILD_ID-linux/x86/$PROJECT_NAME.sh";
		cp "$BUILD_ID/core.js" "$BUILD_ID-linux/x86/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-linux/x86/index.js";
		chmod +x "$BUILD_ID-linux/x86/node";
		chmod +x "$BUILD_ID-linux/x86/$PROJECT_NAME.sh";

	fi;

	if [ -d "$RUNTIME_ROOT/linux/x86_64" ]; then

		LINUX_AVAILABLE=1;

		mkdir "$BUILD_ID-linux/x86_64";
		cp "$RUNTIME_ROOT/linux/x86_64/node" "$BUILD_ID-linux/x86_64/node";
		cp "$RUNTIME_ROOT/linux/x86_64/init.sh" "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh";
		cp "$BUILD_ID/core.js" "$BUILD_ID-linux/x86_64/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-linux/x86_64/index.js";
		chmod +x "$BUILD_ID-linux/x86_64/node";
		chmod +x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh";

	fi;


	if [ "$LINUX_AVAILABLE" == "0" ]; then
		LINUX_STATUS=0;
	elif [ -x "$BUILD_ID-linux/arm/$PROJECT_NAME.sh" ] || [ -x "$BUILD_ID-linux/x86/$PROJECT_NAME.sh" ] || [ -x "$BUILD_ID-linux/x86_64/$PROJECT_NAME.sh" ]; then
		LINUX_STATUS=0;
	fi;

}

_package_osx () {

	if [ -d "./$BUILD_ID-osx" ]; then
		rm -rf "./$BUILD_ID-osx";
	fi;

	mkdir "$BUILD_ID-osx";

	if [ -d "$RUNTIME_ROOT/osx/x86_64" ]; then

		OSX_AVAILABLE=1;

		mkdir "$BUILD_ID-osx/x86_64";
		cp "$RUNTIME_ROOT/osx/x86_64/node" "$BUILD_ID-osx/x86_64/node";
		cp "$RUNTIME_ROOT/osx/x86_64/init.sh" "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh";
		cp "$BUILD_ID/core.js" "$BUILD_ID-osx/x86_64/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-osx/x86_64/index.js";
		chmod +x "$BUILD_ID-osx/x86_64/node";
		chmod +x "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh";

	fi;


	if [ "$OSX_AVAILABLE" == "0" ]; then
		OSX_STATUS=0;
	elif [ -x "$BUILD_ID-osx/x86_64/$PROJECT_NAME.sh" ]; then
		OSX_STATUS=0;
	fi;

}

_package_windows () {

	if [ -d "./$BUILD_ID-windows" ]; then
		rm -rf "./$BUILD_ID-windows";
	fi;

	mkdir "$BUILD_ID-windows";


	if [ -d "$RUNTIME_ROOT/windows/x86" ]; then

		WINDOWS_AVAILABLE=1;

		mkdir "$BUILD_ID-windows/x86";
		cp "$RUNTIME_ROOT/windows/x86/node.exe" "$BUILD_ID-windows/x86/node.exe";
		cp "$RUNTIME_ROOT/windows/x86/init.cmd" "$BUILD_ID-windows/x86/$PROJECT_NAME.cmd";
		cp "$BUILD_ID/core.js" "$BUILD_ID-windows/x86/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-windows/x86/index.js";
		chmod +x "$BUILD_ID-windows/x86/node.exe";
		chmod +x "$BUILD_ID-windows/x86/$PROJECT_NAME.cmd";

	fi;

	if [ -d "$RUNTIME_ROOT/windows/x86_64" ]; then

		WINDOWS_AVAILABLE=1;

		mkdir "$BUILD_ID-windows/x86_64";
		cp "$RUNTIME_ROOT/windows/x86_64/node.exe" "$BUILD_ID-windows/x86_64/node.exe";
		cp "$RUNTIME_ROOT/windows/x86_64/init.cmd" "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd";
		cp "$BUILD_ID/core.js" "$BUILD_ID-windows/x86_64/core.js";
		cp "$BUILD_ID/index.js" "$BUILD_ID-windows/x86_64/index.js";
		chmod +x "$BUILD_ID-windows/x86_64/node.exe";
		chmod +x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd";

	fi;


	if [ "$WINDOWS_AVAILABLE" == "0" ]; then
		WINDOWS_STATUS=0;
	elif [ -x "$BUILD_ID-windows/x86/$PROJECT_NAME.cmd" ] || [ -x "$BUILD_ID-windows/x86_64/$PROJECT_NAME.cmd" ]; then
		WINDOWS_STATUS=0;
	fi;

}



if [ -f "$PROJECT_ROOT/index.js" ]; then

	# Package process

	cd "$PROJECT_ROOT/../";
	_package_linux;

	if [ "$LINUX_STATUS" != "0" ]; then
		echo "FAILURE (Linux build)";
	fi;


	cd "$PROJECT_ROOT/../";
	_package_osx;

	if [ "$OSX_STATUS" != "0" ]; then
		echo "FAILURE (OSX build)";
	fi;


	cd "$PROJECT_ROOT/../";
	_package_windows;

	if [ "$WINDOWS_STATUS" != "0" ]; then
		echo "FAILURE (Windows build)";
	fi;


	if [ "$LINUX_STATUS" != "0" ] || [ "$OSX_STATUS" != "0" ] || [ "$WINDOWS_STATUS" != "0" ]; then
		exit 1;
	fi;



	echo "SUCCESS";
	exit 0;

else

	echo "FAILURE";
	exit 1;

fi;

