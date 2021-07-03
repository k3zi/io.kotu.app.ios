import Combine
import SwiftUI

protocol AsyncImageLoader {
    func data(for url: URL) async throws -> Data?
}

/// A view that asynchronously loads and displays an image.
///
/// Loading an image from a URL uses the shared URLSession.
struct AsyncImage<Content> : View where Content : View {

    private struct Loader: AsyncImageLoader {
        func data(for url: URL) async throws -> Data? {
            try await URLSession.shared.data(from: url).0
        }
    }

    private let url: URL?
    private let scale: CGFloat
    private let loader: AsyncImageLoader
    private let conditionalContent: ((Image?) -> Content)?

    @State private var imageData: Data?

    /// Loads and displays an image from the given URL.
    ///
    /// When no image is available, standard placeholder content is shown.
    ///
    /// In the example below, the image from the specified URL is loaded and shown.
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/screenshot.png"))
    ///
    /// - Parameters:
    ///   - url: The URL for the image to be shown.
    ///   - scale: The scale to use for the image.
    init(url: URL?, scale: CGFloat = 1, loader: AsyncImageLoader = Loader()) where Content == Image {
        self.url = url
        self.scale = scale
        self.loader = loader
        self.conditionalContent = nil
    }

    /// Loads and displays an image from the given URL.
    ///
    /// When an image is loaded, the `image` content is shown; when no image is
    /// available, the `placeholder` is shown.
    ///
    /// In the example below, the image from the specified URL is loaded and
    /// shown as a tiled resizable image. While it is loading, a green
    /// placeholder is shown.
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/tile.png")) { image in
    ///         image.resizable(resizingMode: .tile)
    ///     } placeholder: {
    ///         Color.green
    ///     }
    ///
    /// - Parameters:
    ///   - url: The URL for the image to be shown.
    ///   - scale: The scale to use for the image.
    ///   - content: The view to show when the image is loaded.
    ///   - placeholder: The view to show while the image is still loading.
    init<I, P>(url: URL?, scale: CGFloat = 1, loader: AsyncImageLoader = Loader(), @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I : View, P : View {
        self.url = url
        self.scale = scale
        self.loader = loader
        self.conditionalContent = { image in
            if let image = image {
                return ViewBuilder.buildEither(first: content(image))
            } else {
                return ViewBuilder.buildEither(second: placeholder())
            }
        }
    }

    private var image: Image? {
        imageData
            .flatMap {
                UIImage(data: $0, scale: scale)
            }
            .flatMap(Image.init)
    }

    var body: some View {
        Group {
            if let conditionalContent = conditionalContent {
                conditionalContent(image)
            } else if let image = image {
                image
            }
        }
        .task {
            guard let url = url else { return }
            imageData = try? await loader.data(for: url)
        }
    }

}
