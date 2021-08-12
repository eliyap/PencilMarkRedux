//
//  VideoViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {
    
    let url: URL
    let playerController = AVPlayerViewController()
    
    let navHeight: CGFloat
    
    init(url: URL, navHeight: CGFloat?) {
        self.url = url
        self.navHeight = navHeight ?? 50
        
        /// Attach video asset.
        let player = AVPlayer(url: url)
        playerController.player = player
        
        /// Auto play video.
        player.play()
        
        /// Remove playback chrome.
        playerController.showsPlaybackControls = false
        
        super.init(nibName: nil, bundle: nil)
        
        adopt(playerController)
                
        /// adjust image downwards to clear nav bar
        playerController.view.frame.origin.y += self.navHeight
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(replay))
        ]
    }
    
    @objc
    func replay() {
        playerController.player?.seek(to: CMTime.zero)
        playerController.player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let resolution = resolutionForLocalVideo(url: url) else { return }
        let aspectRatio = resolution.height / resolution.width
        
        /// Scale container to match video size.
        preferredContentSize = CGSize(
            width: popoverWidth,
            height: popoverWidth * aspectRatio
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// Get video resolution.
/// Source: https://stackoverflow.com/a/44879602/12395667
func resolutionForLocalVideo(url: URL) -> CGSize? {
    guard let track = AVURLAsset(url: url)
            .tracks(withMediaType: AVMediaType.video)
            .first else { return nil }
    let size = track.naturalSize.applying(track.preferredTransform)
    return CGSize(width: abs(size.width), height: abs(size.height))
}
