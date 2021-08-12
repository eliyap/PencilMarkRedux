//
//  TutorialView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import UIKit
import AVKit

class TutorialViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let label = UILabel()
        label.text = "Test"
        view = label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preferredContentSize = CGSize(width: 100.0, height: 100.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

class VideoViewController: UIViewController {
    
    let playerView = PlayerView()
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        let player = AVPlayer(url: url)
        playerView.player = player
        
        view = playerView
        playerView.player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        preferredContentSize = CGSize(width: 100.0, height: 100.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// A view that displays the visual contents of a player object.
final class PlayerView: UIView {

    /// Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    /// The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
