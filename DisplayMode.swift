import SwiftUI

enum DisplayMode : CaseIterable, Identifiable {
	case ALL_SUBTASKS
	case FULL_HIERARCHY
	case PARTIAL_HIERARCHY

	var id : Self {self}

	static func to_image(display_mode : DisplayMode) -> some View {
		switch(display_mode) {
			case .ALL_SUBTASKS:
				return Image(systemName: "list.bullet.rectangle.fill").opacity(1.0)
			case .FULL_HIERARCHY:
				return Image(systemName: "list.bullet.indent").opacity(1.0)
			case .PARTIAL_HIERARCHY:
				return Image(systemName: "list.bullet.indent").opacity(0.2)
		}
	}
}
