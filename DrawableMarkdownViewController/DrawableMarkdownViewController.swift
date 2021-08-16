//
//  DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit
import Combine

final class DrawableMarkdownViewController: PMViewController {

    /// Model object
    public var document: StyledMarkdownDocument?
    
    /// Child View Controllers
    let keyboard = KeyboardViewController()
    let canvas = CanvasViewController()
    let noDocument = NoDocumentHost()
    let tutorial = TutorialMenuViewController()
    let toolbar = ToolbarViewController()
    
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
    var undoButton: UIBarButtonItem!
    var redoButton: UIBarButtonItem!
    
    /// Active tool
    var tool: Tool = .pencil {
        didSet {
            toolbar.highlight(tool: tool)
        }
    }
    
    init(fileURL: URL?) {
        if let fileURL = fileURL {
            document = StyledMarkdownDocument(fileURL: fileURL)
        }
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        keyboard.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(canvas)
        canvas.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(noDocument)
        
        adopt(toolbar)
        toolbar.coordinate(with: self) /// call after `init` and `adopt` are complete
        setToolbarInsets()
        
        canvas.view.translatesAutoresizingMaskIntoConstraints = false
        keyboard.view.translatesAutoresizingMaskIntoConstraints = false
        
        /// Set view layer hierarchy.
        view.sendSubviewToBack(keyboard.view)
        view.bringSubviewToFront(canvas.view)
        view.bringSubviewToFront(toolbar.view)
        
        /// Add `UINavigationController` toolbar items.
        makeButtons()
        
        tutorial.modalPresentationStyle = .popover
        
        NotificationCenter.default.addObserver(self, selector: #selector(documentStateChanged), name: UIDocument.stateChangedNotification, object: nil)
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
        
        /// If the user compresses from `.regular` to `.horizontal`, we want to avoid a "snap" button transition,
        /// so adjust the buttons pre-emptively!
        setButtons(for: traitCollection.horizontalSizeClass)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restoreState()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setButtons(for: traitCollection.horizontalSizeClass)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setButtons(for: traitCollection.horizontalSizeClass)
    }
}
