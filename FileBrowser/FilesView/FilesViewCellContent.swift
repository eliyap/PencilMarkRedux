//
//  FilesViewCellContent.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 20/9/21.
//

import UIKit

extension FilesViewCell {
    final class ContentConfiguration: UIContentConfiguration {
        func makeContentView() -> UIView & UIContentView {
            let view = ContentView(configuration: self)
            return view
        }
        
        func updated(for state: UIConfigurationState) -> Self {
            /// Nothing...
            self
        }
    }
    
    final class ContentView: UIView, UIContentView {
        var configuration: UIContentConfiguration
        
        var imageView = UIImageView(image: UIImage(named: "pencil.square"))
        var labelView = UILabel()
        
        init(configuration: UIContentConfiguration) {
            self.configuration = configuration
            super.init(frame: .zero)
                        
            labelView.text = "HELLO"
            let stackView = UIStackView(arrangedSubviews: [
                imageView,
                labelView,
                UIView() /// spacer view
            ])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            addSubview(stackView)
            
            let constraints = [
                stackView.widthAnchor.constraint(equalTo: widthAnchor),
                stackView.heightAnchor.constraint(equalTo: heightAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
