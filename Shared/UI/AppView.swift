import SwiftUI

struct AppView: View {

    @ObservedObject var model: AppModel

    @EnvironmentObject var service: AppService

    var body: some View {
        ZStack {
            if let user = model.user {
                tabView
                    .environmentObject(AppState(user: user))
            }

            LoginView(model: LoginModel(service: service, user: $model.user))
                .opacity(model.user == nil ? 1 : 0)
                .animation(.linear, value: model.user)
        }
    }

    var tabView: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MediaView()
                .tabItem {
                    Label("Media", systemImage: "books.vertical")
                }
            SearchView(model: SearchModel(service: service))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle")
                }
        }
    }

}
