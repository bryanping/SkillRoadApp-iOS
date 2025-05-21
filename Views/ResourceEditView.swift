import SwiftUI
import Foundation
// 只要文件在同一 target 下，Xcode 会自动识别，无需 import Models

// 确保 Resource/ResourceType/ResourceViewModel 已在 Models 目录下并已添加到 target

struct ResourceEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ResourceViewModel()
    @State private var title: String
    @State private var description: String
    @State private var resourceType: ResourceType
    @State private var url: String
    @State private var showingImagePicker = false
    @State private var showingFilePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    init(resource: Resource? = nil) {
        _title = State(initialValue: resource?.title ?? "")
        _description = State(initialValue: resource?.description ?? "")
        _resourceType = State(initialValue: resource?.type ?? .link)
        _url = State(initialValue: resource?.url ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("标题", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }

                Section(header: Text("资源类型")) {
                    Picker("类型", selection: $resourceType) {
                        ForEach(ResourceType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section(header: Text("资源内容")) {
                    switch resourceType {
                    case .link:
                        TextField("URL链接", text: $url)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    case .image:
                        Button("选择图片") {
                            showingImagePicker = true
                        }
                    case .file:
                        Button("选择文件") {
                            showingFilePicker = true
                        }
                    }
                }
            }
            .navigationTitle("编辑资源")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveResource()
                }
            )
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func saveResource() {
        guard !title.isEmpty else {
            alertMessage = "请输入资源标题"
            showingAlert = true
            return
        }

        let resource = Resource(
            id: UUID().uuidString,
            title: title,
            description: description,
            type: resourceType,
            url: url,
            createdAt: Date()
        )

        Task {
            do {
                try await viewModel.saveResource(resource)
                dismiss()
            } catch {
                alertMessage = "保存失败：\(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

#Preview {
    ResourceEditView()
}