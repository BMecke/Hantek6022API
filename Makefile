all: fw_DSO6022BE fw_DSO6022BL fw_DDS120 fx2upload

BE=PyHT6022/Firmware/DSO6022BE
BL=PyHT6022/Firmware/DSO6022BL
DDS=PyHT6022/Firmware/DDS120


.PHONY: fw_DSO6022BE
fw_DSO6022BE:
	cd $(BE) && make


.PHONY: fw_DSO6022BL
fw_DSO6022BL:
	cd $(BL) && make


.PHONY: fw_DDS120
fw_DDS120:
	cd $(DDS) && make


.PHONY: fx2upload
fx2upload:
	cd fx2upload && make


.PHONY: install
install: all
	-rm -rf build/*
	-rm -rf dist/*
	python3 setup.py install
	if [ -d /etc/udev/rules.d/ ]; then cp 60-hantek6022api.rules /etc/udev/rules.d/; fi
	install examples/*_6022*.py /usr/local/bin
	install fx2upload/fx2upload /usr/local/bin


.PHONY: deb
deb:
	fakeroot checkinstall --default --requires python3-libusb1 --install=no --backup=no --deldoc=yes


.PHONY: debinstall
debinstall: deb
	sudo dpkg -i `ls hantek6022api_*.deb | tail -1`


.PHONY: clean
clean:
	-rm *~ .*~
	-rm -rf build/*
	-rm -rf dist/*
	( cd $(BE) && make clean )
	( cd $(BL) && make clean )
	( cd $(DDS) && make clean )
	( cd fx2upload && make clean )


.PHONY: xfer
xfer:
	cp $(BE)/dso6022be-firmware.hex \
	../OpenHantek/OpenHantek6022/openhantek/res/firmware
	cp $(BL)/dso6022bl-firmware.hex \
	../OpenHantek/OpenHantek6022/openhantek/res/firmware
