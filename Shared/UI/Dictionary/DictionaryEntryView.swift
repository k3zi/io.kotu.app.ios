import SwiftUI
import WebKit

struct DictionaryEntryView: View {

    @ObservedObject var model: DictionaryEntryModel

    var body: some View {
        WebView(url: model.url)
            .padding()
    }

}


struct WebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        for cookie in URLSession.shared.configuration.httpCookieStorage?.cookies ?? [] {
            config.websiteDataStore.httpCookieStore.setCookie(cookie)
        }

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.load(.init(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

}
