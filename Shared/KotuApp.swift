import SwiftUI

@main
struct KotuApp: App {

    private let service = AppService()

    var body: some Scene {
        WindowGroup {
            AppView(model: AppModel())
                .environmentObject(service)
                .environmentObject(AudioService(service: service))
        }
    }
    
}
