import AVFoundation
import ffmpegkit

enum FFmpegError: Error {
case createOutputFile
case executeFfmpeg
case executionCancelled
case executionFailed
}

public struct FFmpeg {
    public static var videoRenderSize: Size = .init(width: 1080, height: 1920)
    public static var fps: Int = 30
    
    var videoClips: [VideoClip]
    var stickers: [Sticker]
    
    func export(_ completionHandler: @escaping (Result<(videoUrl: URL, fileSize: Int), Error>) -> Void) {
        guard let outputURL = try? URL.generate("mp4") else {
            completionHandler(.failure(FFmpegError.createOutputFile))
            return
        }
        
        // Add inputs: Videos & Stickers
        var commands: [String] = []
        
        let videoAssetUrls: [String] = videoClips
            .compactMap({ $0.url.absoluteString })
        commands.append(contentsOf: videoAssetUrls.compactMap({ "-i \($0)" }))
        
        let giphyAssetUrls: [String] = stickers.compactMap({ $0.url.absoluteString })
        commands.append(contentsOf: giphyAssetUrls.compactMap({ "-ignore_loop 0 -i \($0)" }))
        
        // TODO: Add Text
        
        // Concatanate videos and stickers
        commands.append("-filter_complex")
        commands.append("\"")
        commands.append(
            contentsOf: videoAssetUrls
                .indices
                .compactMap({
                    var command = "[\($0):v]setpts=PTS-STARTPTS" +
                    ",setsar=1:1,scale=\(FFmpeg.videoRenderSize.ffmpegScale)" +
                    ",fps=\(FFmpeg.fps),format=yuv420p[outv\($0)];" // Video
                    
                    command += "[\($0):a]asetpts=PTS-STARTPTS[outa\($0)];" // Audio
                    
                    return command
                })
        )
        
        commands.append(contentsOf: videoAssetUrls.indices.compactMap({ "[outv\($0)][outa\($0)]" }))
        commands.append("concat=n=\(videoAssetUrls.count):v=1:a=1[outv][outa];")
        
        // Stickers
        commands.append(
            contentsOf: giphyAssetUrls
                .indices
                .compactMap({
                    let sticker = stickers[$0]
                    
                    let scale = sticker.position.size.ffmpegScale
                    let angle = sticker.position.rotation.ffmpegAngle
                    let overlay = sticker.position.origin.ffmpegOverlay
                    
                    // c:none ~> No background color
                    let command = "[\(index):v]format=bgra,scale=\(scale),setsar=1,rotate='\(angle):ow=rotw(\(angle)):oh=roth(\(angle)):c=none'[sticker\($0)];[outv][sticker\($0)]overlay=\(overlay):shortest=1[outv];"
                    return command
                })
        )
        
        // Make sure it does not finish on `;`, otherwise the execution will fail
        if commands.last?.last == ";" {
            commands[commands.count - 1].popLast()
        }
        
        commands.append("\"")
        
        // Finalize the settings
        commands.append(contentsOf: [
            "-map",
            "[outv]",
            "-map",
            "[outa]",
            "-preset", // Presets can be ultrafast, superfast, veryfast, faster, fast, medium (default), slow and veryslow.
            "fast", // Using a slower preset gives you better compression, or quality per file size.
            "-crf", // Constant Rate Factor
            "28", // Value from 0 to 51, 23 is default, Large Value for highest quality
            "-c:v", // Output video codec
            "libx264", // Video codec
            "-c:a", // Output audio codec
            "aac", // Audio Codec
            "-b:a", // Bit rate
            "224k",
            "-tag:v", // Force video tag for the output -tag[:stream_specifier] codec_tag
            "avc1", // Advanced Video Coding (AVC), also referred to as H.264 or MPEG-4
            outputURL.absoluteString,
            "-y" //Overwrite output files without asking
        ])
        
        let command = commands.joined(separator: " ")
        
        // TODO: Remove this print
        print(command)
        
        FFmpegKit.executeAsync(command, withCompleteCallback: { session in
            guard let session = session, let code = session.getReturnCode() else {
                completionHandler(.failure(FFmpegError.executeFfmpeg))
                return
            }
            
            if code.isValueSuccess() {
                let fileSize = outputURL.fileSize! / 1024 / 1024
                print("Exported file size \(fileSize)Mb")

                completionHandler(.success((outputURL, fileSize)))
            } else if code.isValueCancel() {
                completionHandler(.failure(FFmpegError.executionCancelled))
            } else {
                completionHandler(.failure(FFmpegError.executionFailed))
            }
        })
    }
}
