#Makefile for RuYiCai

include ip.def

BASE_NAME = RuYiCai
MAIN_VERSION = 2.4.0.0
DATE = $(shell date +%m%d)
REVISION = $(shell svnversion)
VERSION = $(MAIN_VERSION)-$(DATE)-$(REVISION)
PACKAGE = $(BASE_NAME)-$(VERSION)
PACKAGE_VERSION = $(MAIN_VERSION)-$(REVISION)

.PHONY: all build install uninstall clean svn_clean deb deb_clean deb_install deb_uninstall ipa

#iphone ip address

.PHONY: all build install uninstall clean svn_clean

all: build

build:
	xcodebuild -sdk iphoneos5.0 -configuration Release

#clean:
#	xcodebuild -sdk iphoneos5.0 -configuration Release clean

clean:
	rm -rf build

svn_clean: clean
	find -d . -name .DS_Store -exec rm -f {} \;
	find -d . -name *.mode1v3 -exec rm -f {} \;
	find -d . -name *.pbxuser -exec rm -f {} \;
	
i: install

install:
	scp -r build/Release-iphoneos/RuYiCai.app root@$(IP):/Applications/
	ssh root@$(IP) 'reboot'
	
u: uninstall
uninstall:
	ssh root@$(IP) 'rm -rf /Applications/RuYiCai.app'
	ssh root@$(IP) 'reboot'

deb:
	rm -rf deb/$(BASE_NAME)-*
	cp -rf deb/RuYiCai deb/$(PACKAGE)
	mkdir -p deb/
	sed s/PACKAGE_VERSION_PLACEHOLDER/$(PACKAGE_VERSION)/ deb/$(PACKAGE)/DEBIAN/control > control.mod; mv control.mod deb/$(PACKAGE)/DEBIAN/control;
	cp -rf ./build/Release-iphoneos/*.app deb/$(PACKAGE)/Applications/
	find -d ./deb/$(PACKAGE) -name .svn -exec rm -rf {} \;
	dpkg -b deb/$(PACKAGE)
	dpkg --info deb/$(PACKAGE).deb

deb_clean:
	rm -rf deb/$(BASE_NAME)-*
	rm -rf deb/$(PACKAGE)
	rm -f deb/$(PACKAGE).deb
	
deb_install:
	scp deb/$(PACKAGE).deb root@$(IP):~/
	ssh root@$(IP) 'dpkg -i $(PACKAGE).deb; reboot'
	
deb_uninstall:
	ssh root@$(IP) 'dpkg -r com.ruyicai.ruyicaiiphone4; reboot'
	
ipa:
	rm -rf ipa/Payload/*.app
	cp -rf ./build/Release-iphoneos/*.app ipa/Payload/
	find -d ./ipa/ -name .svn -exec rm -rf {} \;
	cp -rf ipa/Payload/*.app/Icon.png ipa/iTunesArtwork
	cd ipa;zip -r 91caipiao.ipa Payload/ iTunesArtwork;cd -
	
ipa_clean:
	rm -rf ipa/iTunesArtwork
	rm -rf ipa/Payload/*.app
	rm -rf ipa/*.ipa

#-------------------- device management --------------------#
respring:
	ssh root@$(IP) 'respring'

reboot:
	ssh root@$(IP) 'reboot'

login:
	ssh root@$(IP)