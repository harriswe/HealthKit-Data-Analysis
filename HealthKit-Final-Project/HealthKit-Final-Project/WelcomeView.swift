import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Hero Section
                    VStack(spacing: 15) {
                        Text("Welcome to Health Tracker")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(radius: 5)

                        Text("Track your health, stay fit, and achieve your goals effortlessly.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 100)

                    // Image Section
                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    Spacer()

                    // Start Button
                    NavigationLink(destination: ContentView()) {
                        Text("Get Started")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 50)

                    Spacer()
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
