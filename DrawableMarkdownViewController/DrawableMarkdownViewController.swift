//
//  DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit
import Combine

final class DrawableMarkdownViewController: PMViewController {

    /// Model object
    public var document: StyledMarkdownDocument?
    
    /// Child View Controllers
    let keyboard: KeyboardViewController
    let canvas: CanvasViewController
    let noDocument: NoDocumentHost
    let tutorial: TutorialMenuViewController
    
    /// Combine Conduits
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
    let cmdC = CommandConduit()
    let typingC = PassthroughSubject<Void, Never>()
    
    /// Controls which view gets to set the scroll position
    enum ScrollLead { case keyboard, canvas }
    var scrollLead = ScrollLead.canvas
    
    /// Action to perform when document is closed
    var onClose: () -> () = {} /// does nothing by default
    
    /// Menu Buttons
    /// Must be stored so that they can be accessed in methods.
    var closeBtn: UIBarButtonItem!
    var tutorialBtn: UIBarButtonItem!
    
    init(fileURL: URL?) {
        if let fileURL = fileURL {
            document = StyledMarkdownDocument(fileURL: fileURL)
        }
        self.keyboard = KeyboardViewController()
        self.canvas = CanvasViewController()
        self.noDocument = NoDocumentHost()
        self.tutorial = TutorialMenuViewController()
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        keyboard.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(canvas)
        canvas.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(noDocument)
        
        canvas.view.translatesAutoresizingMaskIntoConstraints = false
        keyboard.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.bringSubviewToFront(canvas.view)
        
        /// Set up bar buttons
        closeBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        tutorialBtn = UIBarButtonItem(image: UIImage(systemName: "pencil.and.outline"), style: .plain, target: self, action: #selector(showTutorial))
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(undo))
        let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward"), style: .plain, target: self, action: #selector(redo))
        let buttons: [UIBarButtonItem] = [
            undoButton,
            redoButton,
            tutorialBtn,
            closeBtn,
        ]
        
        /// Arranged from the right edge inwards.
        navigationItem.rightBarButtonItems = buttons.reversed()
        
        /// Disable buttons initially.
        undoButton.isEnabled = false
        redoButton.isEnabled = false
        
        /// Observe for undo updates.
        store(cmdC.undoStatus.sink { undoButton.isEnabled = $0 })
        store(cmdC.redoStatus.sink { redoButton.isEnabled = $0 })
        
        tutorial.modalPresentationStyle = .popover
        
        NotificationCenter.default.addObserver(self, selector: #selector(documentStateChanged), name: UIDocument.stateChangedNotification, object: nil)
    }
    
    @objc
    func undo() {
        cmdC.undo.send()
    }
    
    @objc
    func redo() {
        cmdC.redo.send()
    }
    
    @objc
    func showTutorial() -> Void {
        /// Anchor popover on tutorial button.
        /// - Note: Mandatory! App will crash if not anchored properly.
        /// - Note: Set every time, otherwise bubble will be anchored in the wrong place!
        tutorial.popoverPresentationController?.barButtonItem = tutorialBtn
        tutorial.popoverPresentationController?.sourceView = self.view
        
        present(tutorial, animated: true)
    }
    
    @objc
    func documentStateChanged() -> Void {
        guard let state = document?.documentState else { return }
        if state == .normal { }
        if state.contains(.closed) { print("Document Closed") }
        if state.contains(.inConflict) { print("Document Conflicted") }
        if state.contains(.editingDisabled) { print("Document Cannot Edit") }
        if state.contains(.savingError) { print("Document Encountered Error whilst Saving") }
//        if state.contains(.progressAvailable) { print("Document Progress Available") }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTyping()
        observeBackgrounding()
        restoreState()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /// Perform an extra layout pass **once** when requested.
        if SplitConduit.shared.needLayoutKeyboard {
            keyboard.view.setNeedsLayout()
            SplitConduit.shared.needLayoutKeyboard = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboard.view.frame = view.frame
        canvas.view.frame = view.frame
        noDocument.view.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restoreState()
    }
}
