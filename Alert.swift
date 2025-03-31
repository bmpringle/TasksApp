import SwiftUI

struct DebugAlertFakeError: LocalizedError {
	let message : String

	public var errorDescription: String? {
		return NSLocalizedString("\(self.message)", comment: "My error")
	}
}

func send_alert(message : String) {
	NSAlert(error: DebugAlertFakeError(message: message)).runModal()
}
