#!/bin/bash

dependencies=(
	"binutils"
	"git"
	"libc6-dev"
	"libedit2"
	"libpython2.7"
	"libsqlite3-0"
	"libxml2"
	"pkg-config"
	"tzdata"
    "wget"
	"zlib1g-dev")

sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y lsb-core

version=$(lsb_release -rs | cut -c1-2)

case "$version" in
	16) dependencies+=("libcurl3" "libgcc-5-dev" "libstdc++-5-dev")
		;;
	18)	dependencies+=("libcurl4" "libgcc-5-dev" "libstdc++-5-dev")
		;;
	20) dependencies+=("gnupg2" "libcurl4" "libgcc-9-dev" "libstdc++-9-dev" "libz3-dev")
		;;
	*)  echo "Supported OS versions are Ubuntu 16.x, 18.x and 20.x"
		exit
		;;
esac

echo "Installing dependencies:"
sudo apt-get update
for dep in ${dependencies[*]}; do
	sudo apt-get install $dep
done

echo "Downloading Swift:"
swift_link="https://swift.org/builds/swift-5.3.3-release/ubuntu"$version"04/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu"$version".04.tar.gz"
wget -c -O "swift.tar.gz" "$swift_link"

mkdir "swift"
tar -C "swift" -xvf "swift.tar.gz" --strip-components 1
rm -f swift.tar.gz
sudo mv ./swift /usr/share/swift

printf "\nexport PATH=\"/usr/share/swift/usr/bin:\$PATH\"\n" >> ~/.bashrc

echo "Swift is installed at /usr/share/swift!"
echo "Run 'swift --version' to check if Swift is installed correctly"
echo "Close and reopen terminal to continue..."