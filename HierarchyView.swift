import SwiftUI
import CoreGraphics

struct HierarchyView : View {
	var root_task : Task
	@Binding var partial_hierarchy_root_task : Task?
	@Binding var display_mode : DisplayMode

	var body : some View {
		VStack {
			List(Task.construct_flattened_task_tree(root_task: root_task)) { subtask in
				TaskView(task: subtask, partial_hierarchy_root_task: $partial_hierarchy_root_task, display_mode: $display_mode, post_task_content: { (subtask_parameter : Task) -> AnyView in
					return AnyView(HStack {
						Button {
							subtask_parameter.add_subtask(Task())
						} label: {
							Image(systemName: "plus")
						}
						Button {
							let parent = subtask_parameter.parent!
							parent.remove_subtask(id: subtask_parameter.id)
						} label: {
							Image(systemName: "trash")
						}
					})
				}).offset(x: 10.0 * CGFloat(subtask.get_task_tree_depth(root_task_id: root_task.id) - 1)).padding(.trailing, 10.0 * CGFloat(subtask.get_task_tree_depth(root_task_id: root_task.id) - 1))
			}
			Button {
				root_task.add_subtask(Task())
			} label: {
				Image(systemName: "plus")
			}
		}
	}
}
