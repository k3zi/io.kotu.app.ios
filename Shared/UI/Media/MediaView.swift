import SwiftUI

struct MediaView: View {

    @EnvironmentObject var service: AppService

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                card("Plex") {

                }
                card("Reader") {
                    ReaderView(model: .init(service: service))
                }
                card("YouTube") {

                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    func card<D>(_ name: String, @ViewBuilder _ destination: () -> D) -> some View where D: View {
        NavigationLink {
            destination()
        } label: {
            Text(name)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.forward")
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                .foregroundStyle(.secondary)
                .background(.regularMaterial)
                .cornerRadius(8)
                .padding(8)
        }
        .buttonStyle(.plain)
    }

}
