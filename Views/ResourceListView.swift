import SwiftUI

struct ResourceListView: View {
    @StateObject private var viewModel = ResourceViewModel()
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @State private var selectedResource: Resource?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.resources) { resource in
                    ResourceRowView(resource: resource)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedResource = resource
                            showingEditSheet = true
                        }
                }
                .onDelete { indexSet in
                    Task {
                        for index in indexSet {
                            do {
                                try await viewModel.deleteResource(viewModel.resources[index])
                            } catch {
                                alertMessage = "删除失败：\(error.localizedDescription)"
                                showingAlert = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("学习资源")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                ResourceEditView()
            }
            .sheet(isPresented: $showingEditSheet) {
                if let resource = selectedResource {
                    ResourceEditView(resource: resource)
                }
            }
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .task {
                do {
                    try await viewModel.fetchResources()
                } catch {
                    alertMessage = "加载失败：\(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
}

struct ResourceRowView: View {
    let resource: Resource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(resource.title)
                .font(.headline)
            
            Text(resource.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text(resource.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(resource.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ResourceListView()
} 