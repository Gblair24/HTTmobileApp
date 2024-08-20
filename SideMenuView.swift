
import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        self.isShowing = false
                    }
                }

            VStack(alignment: .leading) {
                HStack {
                    Image("jbird")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        .padding(.leading, -10)
                    Text("William Jewell College")
                        .font(.custom("Gordita-Regular", size: 20))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                }
                .padding(.bottom, 20)

                NavigationLink(destination: MembersView()) {
                    HStack {
                        Image(systemName: "person.3")
                            .foregroundColor(.white)
                            .padding(.leading, -10)
                        Text("Members")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: ActivityView(activities: sampleActivities)) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        Text("Activity")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: NewsView()) {
                    HStack {
                        Image(systemName: "newspaper")
                            .foregroundColor(.white)
                        Text("News")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: ContactUsView()) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                        Text("Contact Us")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                        Text("Settings")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: LoginView()) {
                    HStack {
                        Image(systemName: "arrow.right.square")
                            .foregroundColor(.white)
                        Text("Log out")
                            .font(.custom("Gordita-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 90)
                    .navigationBarBackButtonHidden()
                }

                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 100)
            .frame(width: 255)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

