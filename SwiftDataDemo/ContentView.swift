import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @FocusState private var focus: AnyKeyPath?

    @Query(sort: \Todo.title, order: .forward, animation: .spring)
    private var todos: [Todo]

    @State private var completed = false
    @State private var selectedTodo: Todo?
    @State private var showSheet = false
    @State private var title = ""

    let dateFormat = Date.FormatStyle(date: .numeric, time: .standard)

    private func addTodo() {
        showSheet = true
    }

    private var addTodoView: some View {
        VStack {
            Text("New Todo")
                .font(.title)
                .fontWeight(.bold)
            TextField("Title", text: $title)
                .focused($focus, equals: \Self.title) // TODO: not working
                .textFieldStyle(.roundedBorder)
                .onSubmit { createTodo() }
            HStack {
                Button("Save", action: createTodo)
                    .buttonStyle(.borderedProminent)
                Button("Cancel") {
                    showSheet = false
                }
                .buttonStyle(.bordered)
            }
            .padding(.top)
            Spacer()
        }
        .onAppear { focus = \Self.title }
        .padding()
        .presentationDetents([.height(200)])
    }

    private func createTodo() {
        let todo = Todo(title: title)
        context.insert(todo)
        showSheet = false
        title = ""
    }

    private func deleteTodos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(todos[index])
            }
        }
    }

    private func updateTodo() {
        guard let todo = selectedTodo else { return }
        todo.title = title
        todo.completed = completed
        try? context.save()
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(todos) { todo in
                    let completed = todo.completed
                    let systemName = completed ? "checkmark" : "circle"
                    let variant: SymbolVariants =
                        completed ? .circle.fill : .none
                    HStack {
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.title)
                                .foregroundStyle(completed ? .gray : .black)
                                .strikethrough(completed, color: .gray)
                            Text("\(todo.created, format: dateFormat)")
                                .font(.footnote)
                        }
                        Spacer()
                        Button {
                            // TODO: Why does this trigger when
                            // TODO: clicking ANYWHERE in the HStack?
                            print("got button click")
                            todo.completed.toggle()
                        } label: {
                            Image(systemName: systemName)
                                .symbolVariant(variant)
                                .foregroundStyle(completed ? .green : .gray)
                                .font(.largeTitle)
                        }
                        // When a Button is inside a List row,
                        // its tap target extends to the entire row.
                        // To prevent this, set its buttonStyle to
                        // .borderless or .plain.
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            context.delete(todo)
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }

                        Button {
                            selectedTodo = todo
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
                // Can use this instead of the Delete button above
                // when no other swipe action buttons are needed.
                // .onDelete(perform: deleteTodos)
            }
            .navigationTitle("Todos")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheet) {
                addTodoView
            }
            .sheet(item: $selectedTodo) { // parameter name is "item"!
                // This is run when the sheet is dismissed.
                selectedTodo = nil
            } content: { todo in
                UpdateTodo(todo: todo)
                // Text(todo.title)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addTodo) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Todo.self, inMemory: true)
}
