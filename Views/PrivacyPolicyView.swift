import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("隐私政策")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Group {
                    Text("信息收集")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们收集的信息包括：\n• 账户信息（邮箱、用户名）\n• 学习数据（技能、资源、进度）\n• 设备信息（设备类型、操作系统版本）")
                    
                    Text("信息使用")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们使用收集的信息来：\n• 提供个性化学习体验\n• 改进应用功能\n• 发送重要通知")
                    
                    Text("信息保护")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们采取以下措施保护您的信息：\n• 数据加密存储\n• 定期安全审计\n• 访问权限控制")
                    
                    Text("信息共享")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们不会出售或出租您的个人信息。仅在以下情况下可能共享信息：\n• 获得您的明确同意\n• 遵守法律法规要求")
                }
                
                Group {
                    Text("您的权利")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("您有权：\n• 访问您的个人信息\n• 更正不准确的信息\n• 删除您的账户和数据")
                    
                    Text("联系我们")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("如果您对隐私政策有任何疑问，请通过以下方式联系我们：\n• 邮箱：support@skillroad.app\n• 电话：+86-xxx-xxxx-xxxx")
                }
            }
            .padding()
        }
        .navigationTitle("隐私政策")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
} 