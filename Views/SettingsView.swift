import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                // 用户信息部分
                Section(header: Text("账户信息")) {
                    if let user = authManager.user {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(user.displayName ?? "未设置用户名")
                                    .font(.headline)
                                Text(user.email ?? "未设置邮箱")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // 应用设置部分
                Section(header: Text("应用设置")) {
                    Toggle("深色模式", isOn: $isDarkMode)
                    Toggle("通知提醒", isOn: $notificationsEnabled)
                }
                
                // 数据管理部分
                Section(header: Text("数据管理")) {
                    Button(action: {
                        // TODO: 实现数据导出功能
                    }) {
                        Label("导出数据", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        // TODO: 实现数据导入功能
                    }) {
                        Label("导入数据", systemImage: "square.and.arrow.down")
                    }
                }
                
                // 账户操作部分
                Section(header: Text("账户操作")) {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showingDeleteAccountAlert = true
                    }) {
                        Label("删除账户", systemImage: "person.crop.circle.badge.minus")
                            .foregroundColor(.red)
                    }
                }
                
                // 关于部分
                Section(header: Text("关于")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("隐私政策", systemImage: "hand.raised")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Label("使用条款", systemImage: "doc.text")
                    }
                    
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            .alert("确认退出", isPresented: $showingLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("确认", role: .destructive) {
                    do {
                        try authManager.signOut()
                    } catch {
                        alertMessage = "退出失败：\(error.localizedDescription)"
                        showingAlert = true
                    }
                }
            } message: {
                Text("确定要退出登录吗？")
            }
            .alert("确认删除", isPresented: $showingDeleteAccountAlert) {
                Button("取消", role: .cancel) { }
                Button("确认", role: .destructive) {
                    Task {
                        do {
                            try await authManager.deleteAccount()
                        } catch {
                            alertMessage = "删除账户失败：\(error.localizedDescription)"
                            showingAlert = true
                        }
                    }
                }
            } message: {
                Text("删除账户后，所有数据将无法恢复。确定要删除吗？")
            }
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    SettingsView()
}