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

        // Make sure the video contains a video track
        guard let _ = asset.tracks(withMediaType: .video).first else {
            throw VideoClipError.noVideoTrack
        }
        self.url = url
    }
}
