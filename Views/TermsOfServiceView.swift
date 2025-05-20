import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("使用条款")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Group {
                    Text("服务说明")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("技能之路是一款帮助用户规划和管理学习路径的应用。通过使用本应用，您同意遵守以下条款。")
                    
                    Text("用户责任")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("作为用户，您需要：\n• 提供准确的个人信息\n• 保护账户安全\n• 遵守相关法律法规\n• 尊重知识产权")
                    
                    Text("服务使用")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("您同意：\n• 仅用于个人学习目的\n• 不进行任何破坏系统安全的行为\n• 不传播违法或不当内容")
                }
                
                Group {
                    Text("知识产权")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("本应用的所有内容，包括但不限于：\n• 界面设计\n• 功能实现\n• 数据内容\n均受知识产权法保护。")
                    
                    Text("免责声明")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们不对以下情况负责：\n• 因不可抗力导致的服务中断\n• 用户自行操作导致的数据丢失\n• 第三方内容的质量和准确性")
                    
                    Text("条款修改")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("我们保留随时修改本条款的权利。修改后的条款将在应用内公布，继续使用即表示同意修改后的条款。")
                }
                
                Group {
                    Text("终止条款")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("在以下情况下，我们可能终止服务：\n• 违反使用条款\n• 长期未使用账户\n• 应法律要求")
                    
                    Text("联系我们")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("如有任何问题，请联系：\n• 邮箱：support@skillroad.app\n• 电话：+86-xxx-xxxx-xxxx")
                }
            }
            .padding()
        }
        .navigationTitle("使用条款")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TermsOfServiceView()
    }
} 