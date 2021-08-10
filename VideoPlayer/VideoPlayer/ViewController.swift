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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

final class AVPVC: AVPlayerViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let url: URL = Bundle.main.url(forResource: "Example", withExtension: "mp4")!
        player = AVPlayer(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
