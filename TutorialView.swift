//
//  TutorialView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import UIKit

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
