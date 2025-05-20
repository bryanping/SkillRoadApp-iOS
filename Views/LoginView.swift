// 完整 LoginView.swift 內容（包含 Apple + Google 登入）

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo和标题
                VStack(spacing: 10) {
                    Image(systemName: "map.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text("技能之路")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("规划你的学习路径")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // 登录按钮
                VStack(spacing: 16) {
                    AppleSignInButtonView()
                        .frame(height: 50)
                        .cornerRadius(8)
                    
                    GoogleSignInButtonView()
                        .frame(height: 50)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // 底部文字
                Text("登录即表示您同意我们的服务条款和隐私政策")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
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
    LoginView()
}
