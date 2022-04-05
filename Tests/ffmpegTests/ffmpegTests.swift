import XCTest
@testable import ffmpeg

final class ffmpegTests: XCTestCase {
    
    func testOneVideo() throws {
        let clip1Url = Bundle.module.bundleURL.appendingPathComponent("Assets/CLIP_1.MOV")
        let clip1: VideoClip = try! VideoClip(url: clip1Url)
        
        let expectation = XCTestExpectation(description: "Generate a video with 1 clip")
        
        let ffmpeg = FFmpeg(videoClips: [clip1], stickers: [])
        ffmpeg.export { result in
            switch result {
            case let .success(data):
                print(data)
                expectation.fulfill()
            case let .failure(error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 15) // Compression should not take more than 15s for 1 video
    }
    
    func testOneVideoAndOneGif() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let sticker1Url = Bundle.module.bundleURL.appendingPathComponent("Assets/GIF_1.GIF")
        let sticker1: Sticker = GifSticker(
            url: sticker1Url,
            position: .init(
                origin: .init(x: 0, y: 0),
                size: .init(width: FFmpeg.videoRenderSize.width, height: FFmpeg.videoRenderSize.width / 3),
                rotation: 0))
        
        let clip1Url = Bundle.module.bundleURL.appendingPathComponent("Assets/CLIP_1.MOV")
        let clip1: VideoClip = try! VideoClip(url: clip1Url)
        
        let expectation = XCTestExpectation(description: "Generate a video with 1 clip and 1 gif")
        
        let ffmpeg = FFmpeg(videoClips: [clip1], stickers: [sticker1])
        ffmpeg.export { result in
            switch result {
            case let .success(data):
                print(data)
                expectation.fulfill()
            case let .failure(error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 15) // Compression should not take more than 15s for 1 video
    }
}
