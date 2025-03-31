import SwiftUI

struct AllSubtasksView : View {
	var task : Task
	@Binding var index_stack : [Int]
	@Binding var partial_hierarchy_root_task : Task?
	@Binding var display_mode : DisplayMode

	var body : some View {
		VStack {
			List(task.subtasks) { subtask in
				TaskView(task: subtask, partial_hierarchy_root_task: $partial_hierarchy_root_task, display_mode: $display_mode, post_task_content: { (subtask_parameter : Task) -> AnyView in
					return AnyView(HStack {
						if subtask_parameter.subtasks.count == 0 {
							Button {
								subtask_parameter.add_subtask(Task())
							} label: {
								Image(systemName: "plus")
							}
						} else {
							Button {
								index_stack.append(task.subtasks.firstIndex(of: subtask_parameter)!)
							} label: {
								Image(systemName: "greaterthan.circle.fill")
							}
						}

						Button {
							let parent = subtask_parameter.parent!
							parent.remove_subtask(id: subtask_parameter.id)
						} label: {
							Image(systemName: "trash")
						}
					})
				})
			}
			Button {
				task.add_subtask(Task())
			} label: {
				Image(systemName: "plus")
			}
		}
	}
}
