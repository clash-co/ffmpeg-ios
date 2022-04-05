import AVFoundation
import UIKit

enum VideoClipError: Error {
    case noVideoTrack
}

public class VideoClip {
    let id: UUID = UUID()
    var url: URL
    
    init(url: URL) throws {
        let asset = AVMovie(url: url)

        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            throw VideoClipError.noVideoTrack
        }
        self.url = url
    }
}
