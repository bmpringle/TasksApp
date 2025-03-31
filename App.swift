import SwiftUI
import Combine

func go_to_current_subtask(_ indices : [Int], _ root_task : Task) -> Task {
	var current_subtask = root_task
	for index in indices {
		current_subtask = current_subtask.subtasks[index]
	}
	return current_subtask
}

@main
struct Tasks : App {
	var root_task : Task
	@State var partial_hierarchy_root_task : Task? = nil
	@State var index_stack : [Int] = []
	@State var current_display_mode : DisplayMode = DisplayMode.ALL_SUBTASKS

	static let data_folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first.unsafelyUnwrapped.appendingPathComponent("Tasks", isDirectory: true)
	static let data_filename = "data.json"

	static func get_data_filepath() -> URL {
		return data_folder.appendingPathComponent(data_filename, isDirectory: false)
	}

	@MainActor
	private func recursive_write_observation() {
	    withObservationTracking {
     		for task in Task.construct_flattened_task_tree(root_task: root_task) {
				print(task.title)
				print(task.description)
				print(Urgency.to_string(urgency: task.urgency))
			}
	    } onChange: {
	        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         		self.recursive_write_observation()
         		try! FileManager.default.createDirectory(atPath: Tasks.data_folder.path(), withIntermediateDirectories: true)
             	try! JSONEncoder().encode(root_task).write(to: Tasks.get_data_filepath())
	        }
	    }
	}

	init() {
		if FileManager.default.fileExists(atPath: Tasks.get_data_filepath().path(), isDirectory: nil) {
			root_task = (try? JSONDecoder().decode(Task.self, from: Data(contentsOf: Tasks.get_data_filepath()))) ?? Task()
		} else {
			root_task = Task()
		}
		recursive_write_observation()
	}

	var main_content : (Binding<DisplayMode>, Task, Binding<[Int]>, Binding<Task?>) -> AnyView = { $current_display_mode, root_task, $index_stack, $partial_hierarchy_root_task in
		switch current_display_mode {
			case .ALL_SUBTASKS:
				return AnyView(AllSubtasksView(task: go_to_current_subtask(index_stack, root_task), index_stack: $index_stack, partial_hierarchy_root_task: $partial_hierarchy_root_task, display_mode : $current_display_mode))
			case .FULL_HIERARCHY:
				return AnyView(HierarchyView(root_task: root_task, partial_hierarchy_root_task: $partial_hierarchy_root_task, display_mode : $current_display_mode))
			case .PARTIAL_HIERARCHY:
				return AnyView(HierarchyView(root_task: partial_hierarchy_root_task!, partial_hierarchy_root_task: $partial_hierarchy_root_task, display_mode : $current_display_mode))
		}
	}

	var body : some Scene {
		WindowGroup {
			CustomNavigationView(
				current_display_mode: $current_display_mode,
				index_stack: $index_stack,
				partial_hierarchy_root_task: $partial_hierarchy_root_task,
				content: main_content($current_display_mode, root_task, $index_stack, $partial_hierarchy_root_task)
			)
		}
	}
}
