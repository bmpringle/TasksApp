import SwiftUI

struct CustomNavigationView<Content> : View where Content : View {
	@Binding var current_display_mode : DisplayMode
	@Binding var index_stack : [Int]
	@Binding var partial_hierarchy_root_task : Task?

	let content : Content

	func should_display_back_button(_ current_display_mode : DisplayMode, _ index_stack : [Int]) -> Bool {
		if current_display_mode == .FULL_HIERARCHY {
			return false;
		}

		if current_display_mode == .PARTIAL_HIERARCHY {
			return true;
		}

		return index_stack.count > 0;
	}

	var body : some View {
		ZStack {
			content
		}.toolbar {
			HStack {
				ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
					if should_display_back_button($current_display_mode.wrappedValue, $index_stack.wrappedValue) {
						Button {
							if current_display_mode == .ALL_SUBTASKS {
								index_stack.popLast()!
							}
							if current_display_mode == .PARTIAL_HIERARCHY {
								current_display_mode = .FULL_HIERARCHY
							}
						} label: {
							Image(systemName: "lessthan.circle.fill")
						}
					}
				}

				ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
					Picker("", selection: $current_display_mode) {
						ForEach(DisplayMode.allCases) { display_mode in
							Button {
								// TODO
							} label : {
								DisplayMode.to_image(display_mode: display_mode)
							}.selectionDisabled(display_mode == .PARTIAL_HIERARCHY && partial_hierarchy_root_task == nil)
						}
					}
				}
			}
		}
	}
}
