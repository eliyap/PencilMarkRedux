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
        navigationItem.rightBarButtonItems = [
            closeBtn,
            tutorialBtn,
        ]
        
        tutorial.modalPresentationStyle = .popover
        
        NotificationCenter.default.addObserver(self, selector: #selector(documentStateChanged), name: UIDocument.stateChangedNotification, object: nil)
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
    
    // MARK: - State Restoration
    /// - Note: expect that this might be called multiple times, in order to restore the state ASAP.
    func restoreState() -> Void {
        /// Only restore state if document is not already open.
        guard document?.fileURL == nil else { return }
        
        /// Assert control over iCloud drive
        /// If we do not do this, `UIDocument` reports a permissions failure.
        guard let iCloudURL = FileBrowserViewController.iCloudURL else { return }
        _ = try? FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: .none)
        
        /// Open stored document
        present(fileURL: StateModel.shared.url)
    }
}

extension DrawableMarkdownViewController {
    
    /// Make sure we are not editing the temporary document or a `nil` document.
    func assertDocumentIsValid() {
        precondition(document?.fileURL != nil, "Edits made to nil document!")
    }
    
    // MARK: - Document Open / Close
    
    /// Close whatever document is currently open, and open the provided URL instead
    func present(fileURL: URL?) {
        /// If URL is already open, do nothing
        guard document?.fileURL != fileURL else { return }
        
        /// Stop interaction with the document
        keyboard.resignFirstResponder()
        canvas.resignFirstResponder()
        keyboard.textView.endEditing(true)
        
        /// close document, if any, then open new
        if let document = document {
            document.close { (success) in
                guard success else {
                    assert(false, "Failed to close document!")
                    return
                }
                self.open(fileURL: fileURL)
            }
        } else {
            self.open(fileURL: fileURL)
        }
    }
    
    /// Open new document, if any
    private func open(fileURL: URL?) {
        if let fileURL = fileURL {
            print("File URL is \(fileURL)")
            document = StyledMarkdownDocument(fileURL: fileURL)
            document?.open { (success) in
                guard success else {
                    assert(false, "Failed to open document!")
                    return
                }
                
                /// Hide placeholder view.
                self.view.sendSubviewToBack(self.noDocument.view)
                
                /// Determine `UIScrollView` preferred inset, which is different from the nav bar height
                /// Docs: https://developer.apple.com/documentation/uikit/uiscrollview/2902259-adjustedcontentinset
                let topInset: CGFloat = self.keyboard.textView.adjustedContentInset.top
                
                self.keyboard.present(topInset: topInset)
                self.canvas.present(topInset: topInset)
            }
        } else {
            document = nil
            
            /// Show placeholder view.
            view.bringSubviewToFront(noDocument.view)
        }
        
        /// Update Navigation Bar Title
        navigationItem.title = document?.localizedName ?? ""
    }
    
    @objc
    func close() {
        guard document != nil else { return }
        
        /// Show placeholder view.
        self.view.bringSubviewToFront(self.noDocument.view)
        
        /// Disable editing
        keyboard.close()
        
        /// Update Navigation Bar Title
        navigationItem.title = ""
        
        document?.close { (success) in
            guard success else {
                assert(false, "Failed to save document!")
                return
            }
            
            print("closed")
            self.document = nil
            self.onClose() /// invoke passed closure
            self.onClose = {} /// reset to do nothing
        }
    }
}
