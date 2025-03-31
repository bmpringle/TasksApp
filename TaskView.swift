import SwiftUI

struct TaskView : View {
	var task : Task
	@Binding var partial_hierarchy_root_task : Task?
	@Binding var display_mode : DisplayMode
	@State var post_task_content : (Task) -> AnyView = { (task : Task) -> AnyView in
		AnyView(EmptyView())
	}

	var body : some View {
		HStack {
			TextField("Title: ", text: Binding(get: { return task.title }, set: { new_title in task.title = new_title }))
			TextField("Description: ", text: Binding(get: { return task.description }, set: { new_description in task.description = new_description }))
			Picker("Urgency: ", selection: Binding(get: { return task.urgency }, set: { new_urgency in task.urgency = new_urgency })) {
				ForEach(Urgency.allCases) { urgency_option in
					Text(Urgency.to_string(urgency: urgency_option))
				}
			}
			post_task_content(task)
		}.contextMenu {
			if partial_hierarchy_root_task == task {
				Button {
					partial_hierarchy_root_task = nil
				} label: {
					HStack {
						Text("Deselect Partial Hierarchy Root")
					}
				}
			} else {
				Button {
					partial_hierarchy_root_task = task
				} label: {
					HStack {
						Text("Select Partial Hierarchy Root")
					}
				}
			}

			Button {
				partial_hierarchy_root_task = task
				display_mode = .PARTIAL_HIERARCHY
	        } label: {
				HStack {
					Text("Go To Partial Hierarchy Root")
				}
	        }
		}
	}
}
