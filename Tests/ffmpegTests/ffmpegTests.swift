import XCTest
@testable import ffmpeg

final class ffmpegTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let sticker1Url = Bundle.module.bundleURL.appendingPathComponent("Assets/CLIP_1.MOV")
        let sticker1: Sticker = GiphySticker(url: sticker1Url, position: .init(origin: .init(x: 0, y: 0), size: .init(width: 100, height: 100), rotation: 0))
        
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
        
        wait(for: [expectation], timeout: 10)
        
//        XCTAssertEqual(, "Hello, World!")
    }
}
