import Foundation



extension Decodable {

    init(data: Data) throws {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch {
            if let responseError = try? decoder.decode(ResponseResult.self, from: data) {
                throw responseError
            }
            throw error
        }
    }

}
