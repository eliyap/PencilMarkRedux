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
        
        init(configuration: UIContentConfiguration) {
            self.configuration = configuration
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
