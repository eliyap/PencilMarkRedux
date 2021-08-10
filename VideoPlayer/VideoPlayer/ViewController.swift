//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Secret Asian Man Dev on 10/8/21.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    let av = AVPVC()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addChild(av)
        view.addSubview(av.view)
        av.didMove(toParent: self)
        av.view.frame = view.frame
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
        let playerView = PlayerView()
        let url: URL = Bundle.main.url(forResource: "Example", withExtension: "MP4")!
        let player = AVPlayer(url: url)
        playerView.player = player
        
        view = playerView
        playerView.player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

final class AVPVC: AVPlayerViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let url: URL = Bundle.main.url(forResource: "Example", withExtension: "MP4")!
        player = AVPlayer(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
