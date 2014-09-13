# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/aokp/tools/getdate)
AOKP_BRANCH=kitkat

ifneq ($(AOKP_BUILD),)
	# AOKP_BUILD=<goo version int>/<build string>
	PRODUCT_PROPERTY_OVERRIDES += \
	    ro.goo.developerid=OurROM \
	    ro.goo.rom=OurROM \
	    ro.goo.version=$(shell echo $(AOKP_BUILD) | cut -d/ -f1) \
	    ro.aokp.version=$(TARGET_PRODUCT)_OurROM_4.4_$(DATE)
else
	PRODUCT_PROPERTY_OVERRIDES += \
	    ro.goo.developerid=OurROM \
	    ro.goo.rom=$(TARGET_PRODUCT) \
	    ro.goo.version=1 \
	    ro.aokp.version=$(TARGET_PRODUCT)_OurROM_4.4_$(DATE)
endif

ifeq ($(BUILD_NUMBER),)
  # BUILD_NUMBER should be set to the source control value that
  # represents the current state of the source code.  E.g., a
  # perforce changelist number or a git hash.  Can be an arbitrary string
  # (to allow for source control that uses something other than numbers),
  # but must be a single word and a valid file name.
  #
  # If no BUILD_NUMBER is set, create a useful "I am an engineering build
  # from this date/time" value.  Make it start with a non-digit so that
  # anyone trying to parse it as an integer will probably get "0".
  BUILD_NUMBER := OurROM_$(shell echo $(AOKP_BUILD) | cut -d/ -f2)
    # AOKP_BUILD=<goo version int>/<build string>
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.goo.developerid=aokp \
        ro.goo.rom=aokp \
        ro.goo.version=$(shell echo $(AOKP_BUILD) | cut -d/ -f1)

    AOKP_VERSION=$(TARGET_PRODUCT)_$(AOKP_BRANCH)_$(shell echo $(AOKP_BUILD) | cut -d/ -f2)
else
    ifneq ($(AOKP_NIGHTLY),)
        # AOKP_NIGHTLY=true
        AOKP_VERSION=$(TARGET_PRODUCT)_$(AOKP_BRANCH)_nightly_$(DATE)
    else
        AOKP_VERSION=$(TARGET_PRODUCT)_$(AOKP_BRANCH)_unofficial_$(DATE)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.aokp.version=$(AOKP_VERSION)

# needed for statistics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.aokp.branch=$(AOKP_BRANCH) \
    ro.aokp.device=$(AOKP_PRODUCT)

# Camera shutter sound property
PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.camera-sound=1
