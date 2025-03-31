enum Urgency : Codable, CaseIterable, Identifiable {
	case LOW
	case MEDIUM
	case HIGH
	case CRITICAL

	var id : Self {self}

	static func to_string(urgency : Urgency) -> String {
		switch(urgency) {
			case .LOW:
				return "LOW"
			case .MEDIUM:
				return "MEDIUM"
			case .HIGH:
				return "HIGH"
			case .CRITICAL:
				return "CRITICAL"
		}
	}
}
