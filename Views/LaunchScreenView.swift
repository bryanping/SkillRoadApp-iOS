import SwiftUI
import FirebaseAuth

// 导入自定义视图

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if isActive {
            if authManager.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        } else {
            ZStack {
                Color("AccentColor")
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "map.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("SkillRoad")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("规划你的学习之路")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 1)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
        .environmentObject(AuthManager.shared)
} 
