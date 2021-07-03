import Foundation

protocol MediaService {

    func mediaReaderSession(forURL url: URL) async -> MediaReaderSession?

}
