import SwiftData
import SwiftUI

struct UpdateTodo: View {
    @Bindable var todo: Todo
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: AnyKeyPath?
    @State private var completed: Bool
    @State private var title: String

    init(todo: Todo) {
        self.todo = todo
        _title = State(initialValue: todo.title)
        _completed = State(initialValue: todo.completed)
        focus = \Self.title
    }

    private func updateTodo() {
        todo.title = title
        todo.completed = completed
        dismiss()
    }

    var body: some View {
        List {
            TextField("Title", text: $title)
                .focused($focus, equals: \Self.title) // TODO: not working
                .textFieldStyle(.roundedBorder)
                .onSubmit { updateTodo() }
            Toggle("Completed", isOn: $completed)
            HStack {
                Button("Save", action: updateTodo)
                    .buttonStyle(.borderedProminent)
                Button("Cancel") {
                    dismiss()
                }
            }
            .padding(.top)
            Spacer()
        }
        .navigationTitle("Update Todo")
    }
}
