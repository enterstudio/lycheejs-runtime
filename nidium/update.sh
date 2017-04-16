#!/bin/bash

NIDIUM_DOWNLOAD="https://nidium.com/downloads/";
NIDIUM_FILEHOST="https://nidium.com";
RUNTIME_ROOT=$(cd "$(dirname "$0")/"; pwd);

ALWAYS_YES="false";


if [ "$1" == "--yes" ] || [ "$1" == "-y" ]; then
	ALWAYS_YES="true";
fi;



_download_dmg () {

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NIDIUM_FILEHOST$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$(dirname $3)";
	target="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$ALWAYS_YES" == "true" ] || [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$target'";

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.dmg;

		7z x ./download.dmg 1> /dev/null 2> /dev/null;

		mv $RUNTIME_ROOT/.tmp/Nidium/nidium.app/Contents/MacOS/nidium $target;
		echo "$new_hash" > $folder/.download_hash;

	fi;

}

_download_run () {

	rm -rf $RUNTIME_ROOT/.tmp;
	mkdir $RUNTIME_ROOT/.tmp;

	download="$NIDIUM_FILEHOST$1";
	old_hash="";
	new_hash="$2";
	folder="$RUNTIME_ROOT/$(dirname $3)";
	target="$RUNTIME_ROOT/$3";

	if [ -f "$folder/.download_hash" ]; then
		old_hash="$(cat $folder/.download_hash)";
	fi;


	if [ "$ALWAYS_YES" == "true" ] || [ "$old_hash" != "$new_hash" ]; then

		echo "> Downloading $download into '$target'";

		cd $RUNTIME_ROOT/.tmp;
		curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -s $download > download.run;

		chmod +x ./download.run;
		./download.run --nox11 --quiet --nochown --tar xvf 1> /dev/null 2> /dev/null;

		mv $RUNTIME_ROOT/.tmp/dist/nidium $target;
		echo "$new_hash" > $folder/.download_hash;

	fi;

}


echo "UPDATE nidium ...";
cd $RUNTIME_ROOT;

if [ ! -d ./.tmp ]; then
	mkdir .tmp;
fi;


if [ -f ./downloads.html ]; then
	rm ./downloads.html;
fi;


cd $RUNTIME_ROOT;
curl -s "$NIDIUM_DOWNLOAD" > ./downloads.html;

FILE_LINUX_X64=$(cat ./downloads.html | grep Nidium_frontend | grep Linux_x86-64  | head -n 1 | grep run | cut -d'"' -f2);
HASH_LINUX_X64=$(cat ./downloads.html | grep Nidium_frontend | grep Linux_x86-64  | head -n 1 | grep run | cut -d'"' -f2 | cut -d"_" -f5);

FILE_OSX_X64=$(  cat ./downloads.html | grep Nidium_frontend | grep Darwin_x86-64 | head -n 1 | grep dmg | cut -d'"' -f2);
HASH_OSX_X64=$(  cat ./downloads.html | grep Nidium_frontend | grep Darwin_x86-64 | head -n 1 | grep dmg | cut -d'"' -f2 | cut -d"_" -f5);


cd $RUNTIME_ROOT;

_download_run "$FILE_LINUX_X64" "$HASH_LINUX_X64" "linux/x86_64/nidium";

_download_dmg "$FILE_OSX_X64" "$HASH_OSX_X64" "osx/x86_64/nidium";


rm -rf $RUNTIME_ROOT/.tmp;



echo "SUCCESS";
exit 0;

