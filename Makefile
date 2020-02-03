SWIFT_BUILD_FLAGS=--configuration release
TOOL_NAME = surfgen


SHARE_PATH = $(PREFIX)/share/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)

build:
	swift build $(SWIFT_BUILD_FLAGS)

get_executable: build
	cp $(BUILD_PATH) .
