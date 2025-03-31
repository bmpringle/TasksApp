import SwiftUI

@Observable
class Task: Identifiable, Codable, Equatable {
	var id = UUID()
	var title : String = "New Task"
	var description : String = ""
	var urgency : Urgency = .LOW
	var subtasks : [Task] = []
	var parent : Task?

	enum TaskCodingKey : CodingKey {
		case title
		case description
		case urgency
		case subtasks
	}

	var debugDescription : String {
		return "Title: \(title), Description: \(description), Urgency: \(Urgency.to_string(urgency: urgency)), Subtasks: \(subtasks.count), ID: \(id)"
	}

	required init() {

	}

	required init(from decoder: Decoder) throws {
		do {
			let container = try decoder.container(keyedBy: TaskCodingKey.self)
			title = try container.decode(String.self, forKey: .title)
			description = try container.decode(String.self, forKey: .description)
			urgency = try container.decode(Urgency.self, forKey: .urgency)
			subtasks = try container.decode(Array.self, forKey: .subtasks)
			for task in subtasks {
				task.parent = self
			}
		} catch {
			throw error
		}
	}

	public func encode(to encoder: Encoder) throws {
		do {
			var container = encoder.container(keyedBy: TaskCodingKey.self)
			try container.encode(title, forKey: .title)
			try container.encode(description, forKey: .description)
			try container.encode(urgency, forKey: .urgency)
			try container.encode(subtasks, forKey: .subtasks)
		} catch {
			throw error
		}
    }

	func get_root() -> Task {
		return parent?.get_root() ?? self
	}

	static func == (lhs: Task, rhs: Task) -> Bool {
		return lhs.id == rhs.id
	}

	func add_subtask(_ subtask : Task) {
		subtask.parent = self
		subtasks.append(subtask)
	}

	func remove_subtask(id : UUID) {
		var index = 0
		for task in subtasks {
			if task.id == id {
				break
			}
			index += 1
		}
		subtasks.remove(at: index)
	}

	func get_task_tree_depth(_ depth : Int = 0, root_task_id : UUID? = nil) -> Int {
		guard root_task_id != id && parent != nil else {
			return depth
		}
		return parent!.get_task_tree_depth(depth + 1)
	}

	static func construct_flattened_task_tree(root_task : Task) -> [Task] {
		var flattened_task_tree : [Task] = []
		for task in root_task.subtasks {
			flattened_task_tree.append(task)
			flattened_task_tree += Task.construct_flattened_task_tree(root_task: task)
		}
		return flattened_task_tree
	}
}
