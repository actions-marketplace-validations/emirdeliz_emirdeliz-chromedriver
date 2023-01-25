#!/bin/sh

setDownloadDir() {
	DOWNLOAD_PATH=$1
	if [ "$DOWNLOAD_PATH" != "" ]; then
		mkdir -p "$DOWNLOAD_PATH" && cd "$DOWNLOAD_PATH" || exit
	fi
}

removeObsoleteFiles() {
	rm -rf chromedriver LICENSE.chromedriver
}

getDriverVersion() {
	VERSION=$1
	CHROMEDRIVER_RELEASE="$VERSION"
	if [ "$VERSION" = "latest" ]; then
		VERSION="LATEST_RELEASE"
		CHROMEDRIVER_RELEASE="$(curl --show-error --retry 10 "http://chromedriver.storage.googleapis.com/$VERSION")"
	fi
	echo "$CHROMEDRIVER_RELEASE"
}

downloadDriver() {
	CHROMEDRIVER_RELEASE=$1
	CHROMEDRIVER_FILENAME=$2
	DONWLOAD_URL="https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_RELEASE/$CHROMEDRIVER_FILENAME"
	curl --show-error --retry 10 --output "$CHROMEDRIVER_FILENAME".zip "$DONWLOAD_URL"
}

unzipFiles() {
	CHROMEDRIVER_FILENAME=$1
	OS="$(uname)"

	echo "CHEGOU AQUI..."

	if [ "$OS" = "WindowsNT" ]; then
		echo "ENTROU AQUI..."
		pkunzip "$CHROMEDRIVER_FILENAME"
	else
		unzip "$CHROMEDRIVER_FILENAME".zip
	fi
}

main() {
	CHROMEDRIVER_FILENAME="chromedriver_$2"
	CHROMEDRIVER_RELEASE="$(getDriverVersion "$1")"

	setDownloadDir "$3" &&
		removeObsoleteFiles &&
		downloadDriver "$CHROMEDRIVER_RELEASE" "$CHROMEDRIVER_FILENAME".zip &&
		unzipFiles "$CHROMEDRIVER_FILENAME" &&
		./chromedriver --version
}

main "$1" "$2" "$3"
