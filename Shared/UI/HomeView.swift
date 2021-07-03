import SwiftUI

struct HomeView: View {

    @EnvironmentObject var state: AppState

    var body: some View {
        Text("Hello \(state.user.username)!")
    }

}
