import SwiftData
import SwiftUI

struct UpdateTodo: View {
    @Bindable var todo: Todo
    @Environment(\.dismiss) var dismiss

    // @State private var completed: Bool
    // @State private var title: String

    /*
     private var todo: Todo
     init(todo: Todo) {
         self.todo = todo
         _title = State(initialValue: todo.title)
         _completed = State(initialValue: todo.completed)
     }
     */

    private func updateTodo() {
        // todo.title = title
        // todo.completed = completed
        dismiss()
    }

    var body: some View {
        List {
            // TextField("Title", text: $title)
            TextField("Title", text: $todo.title)
                // .focused($focus, equals: \Self.title) // TODO: not working
                .textFieldStyle(.roundedBorder)
                .onSubmit { updateTodo() }
            // Toggle("Completed", isOn: $completed)
            Toggle("Completed", isOn: $todo.completed)
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
        /*
         .onAppear {
             self.title = todo.title
             self.completed = todo.completed
         }
         */
    }
}
