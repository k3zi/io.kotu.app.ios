import SwiftUI

struct LoginView: View {

    @ObservedObject var model: LoginModel

    var body: some View {
        VStack {
            Spacer()
            Text("コツ")
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(.white)
                .cornerRadius(9)
                .padding(.bottom, 16)

            Divider()
                .background(.white)
                .padding(.bottom, 16)

            TextField("Username", text: $model.username)
            #if os(iOS)
                .autocapitalization(.none)
            #endif
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 8)
            SecureField("Password", text: $model.password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 16)

            Button {
                async {
                    await model.submit()
                }
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .opacity(model.isInitialLoad ? 0 : 1)
        .padding()
        .background(Color(white: 17 / 255))
        .preferredColorScheme(.dark)
        .alert(isPresented: $model.showError, error: model.error) {
            Button("OK") { }
        }
        .overlay {
            ZStack {
                Color(white: model.isInitialLoad ? 17 / 255 : 0.5, opacity: model.isInitialLoad ? 1 : 0.5)

                ProgressView()
                    .padding()
                    .background(.regularMaterial)
            }
            .opacity(model.isLoading ? 1 : 0)
            .animation(.linear, value: model.isLoading)
        }
        .task {
            await model.checkIfLoggedIn()
        }
    }

}
