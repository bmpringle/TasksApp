default:
	rm -f bin/Tasks
	swiftc -g *.swift -parse-as-library -framework AppKit -framework SwiftUI -o bin/Tasks
	rm -rf Tasks.app
	./bin/create_app_bundle bin/Tasks Tasks.app
