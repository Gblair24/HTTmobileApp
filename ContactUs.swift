
import SwiftUI
//Go in and fix settings. Need to add password change capabilities. Integrate live chat after getting apple dev account
struct ContactUsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Here's our info:")
                                .font(.custom("Gordita-Bold", size: 18))
                            Text(AttributedString(stringLiteral:"support.example@htt.com"))
                                .foregroundColor(Color("HTeal"))
                                .font(.custom("Gordita-Regular", size: 18))
                            Text("123-456-7890")
                                .font(.custom("Gordita-Regular", size: 16))
                        }
                    }
                    .frame(width: 300, height: 100, alignment: .leading)
                    
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Have questions? Check out our FAQ and our guide for understanding alerts:")
                                .font(.custom("Gordita-Bold", size: 18))
                            Text("FAQ / Alerts Guide")
                                .font(.custom("Gordita-Regular", size: 18))
                                .foregroundColor(Color("HTeal"))
                                .underline()
                        }
                    }
                    
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Or Chat with someone now:")
                                .font(.custom("Gordita-Bold", size: 18))
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(height: 300)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        HStack {
                                            TextField("Type your message...", text: .constant(""))
                                                .padding(10)
                                                .background(Color.gray.opacity(0.3))
                                                .cornerRadius(10)
                                            Button(action: {
                                                // Add action for the button
                                            }) {
                                                Circle()
                                                    .fill(Color("HOrange"))
                                                    .frame(width: 30, height: 30)
                                                    .overlay(
                                                        Image(systemName: "paperplane.fill")
                                                            .foregroundColor(.white)
                                                    )
                                            }
                                        }
                                        .padding()
                                    }
                                )
                        }
                        .cornerRadius(10)
                        .frame(width: 300, height: 350, alignment: .leading)
                    }
                }
                .padding()
            }
            .background(Color.black)
            .foregroundColor(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Contact Us")
                        .font(.custom("Gordita-Bold", size: 26))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
