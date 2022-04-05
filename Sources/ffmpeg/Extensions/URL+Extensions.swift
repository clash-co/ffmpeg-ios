import Foundation

extension URL {
    static func generate(_ fileExtension: String) throws -> URL {
        let url = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("\(UUID().uuidString).\(fileExtension)")

        return url
    }
    
    var fileSize: Int? {
        let value = try? resourceValues(forKeys: [.fileSizeKey])
        return value?.fileSize
    }
}
