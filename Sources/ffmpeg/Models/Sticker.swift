import Foundation

public struct Position {
    var origin: Point
    var size: Size
    var rotation: Int // In radian
}

extension Int {
    var ffmpegAngle: String { self.description }
}

public struct Size {
    var width: Int
    var height: Int
}

extension Size {
    var ffmpegScale: String { "w=\(width.description):h=\(height.description)" }
}

public struct Point {
    var x: Int
    var y: Int
}

extension Point {
    var ffmpegOverlay: String { "\(x.description):\(y.description)" }
}

protocol Sticker: AnyObject {
    var id: UUID { get }
    var url: URL { get }
    var position: Position { get }
}

public class GifSticker: Sticker {
    var id = UUID()
    var url: URL
    var position: Position
    
    public init(id: UUID = UUID(), url: URL, position: Position) {
        self.id = id
        self.url = url
        self.position = position
    }
}
