import Foundation

struct ResponseResult: Decodable, Error, LocalizedError {

    let error: Bool
    let message: String

    var errorDescription: String? { message }

}
