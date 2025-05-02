import SwiftUI
import UIKit
import CoreData

// MARK: - Notification Names

extension Notification.Name {
    static let showAIAssistant = Notification.Name("showAIAssistant")
    // Tab change notifications are defined in TabbarView.swift
}

/// Manages AI assistant functionality across the app
final class FloatingButtonManager {
    // Singleton instance
    static let shared = FloatingButtonManager()

    // Thread-safe state tracking with a dedicated queue
    private let stateQueue = DispatchQueue(label: "com.backdoor.floatingButtonState", qos: .userInteractive)
    private var _isPresentingChat = false
    private var isPresentingChat: Bool {
        get { stateQueue.sync { _isPresentingChat } }
        set { stateQueue.sync { _isPresentingChat = newValue } }
    }

    // Processing queue for handling asynchronous tasks
    private let processingQueue = DispatchQueue(label: "com.backdoor.aiProcessing", qos: .userInitiated)

    // Button management
    private var activeButton: FloatingTerminalButton?
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Lifecycle

    private init() {
        // Subscribe to notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showAIAssistant),
            name: .showAIAssistant,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - API

    /// Called from notification
    @objc func showAIAssistant(notification: Notification) {
        guard let viewController = notification.object as? UIViewController else {
            print("showAIAssistant notification received without a valid view controller")
            return
        }
        
        presentAIAssistant(from: viewController)
    }

    /// Shows the AI button. This is called from AppDelegate.
    func show() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        addButton(to: rootVC)
    }

    /// Hides the AI button. This is called from AppDelegate.
    func hide() {
        removeButton()
    }

    /// Shows or hides the floating button in the specified view controller
    func toggleButton(in viewController: UIViewController) {
        if activeButton != nil {
            removeButton()
        } else {
            addButton(to: viewController)
        }
    }

    /// Removes the button if it exists
    func removeButton() {
        guard let button = activeButton else { return }
        
        // Apply dismissal animation
        UIView.animate(withDuration: 0.3, animations: {
            button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            button.alpha = 0
        }) { _ in
            button.removeFromSuperview()
            self.activeButton = nil
        }
    }

    // MARK: - Private Methods

    private func addButton(to viewController: UIViewController) {
        guard activeButton == nil else { return }
        
        // Create button
        let button = FloatingTerminalButton(type: .custom)
        button.setImage(UIImage(systemName: "message.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Add to view with constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        // Apply appearance animation
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        button.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            button.transform = .identity
            button.alpha = 1
        }
        
        activeButton = button
    }

    @objc private func buttonTapped() {
        generator.impactOccurred()
        
        guard let button = activeButton, let viewController = button.parentViewController else {
            return
        }
        
        presentAIAssistant(from: viewController)
    }

    private func presentAIAssistant(from presenter: UIViewController) {
        // Prevent multiple presentations
        guard !isPresentingChat else { return }
        isPresentingChat = true
        
        // Use CoreDataManager to fetch or create a session
        guard let context = try? CoreDataManager.shared.persistentContainer.viewContext else {
            print("Failed to get context")
            isPresentingChat = false
            return
        }
        
        let session: ChatSession
        
        // Get active session or create a new one
        let fetchRequest: NSFetchRequest<ChatSession> = ChatSession.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingSession = results.first {
                session = existingSession
            } else {
                session = ChatSession(context: context)
                session.id = UUID()
                session.createdAt = Date()
                session.name = "New Chat"
                try context.save()
            }
            
            // Create and present chat view controller
            let chatVC = ChatViewController(session: session)
            chatVC.dismissHandler = { [weak self] in
                self?.isPresentingChat = false
                print("Chat assistant dismissed")
            }
            
            let navController = UINavigationController(rootViewController: chatVC)
            
            // Style based on device
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad presentation
                navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
                navController.preferredContentSize = CGSize(width: 540, height: 620)
            } else {
                // iPhone presentation
                if #available(iOS 15.0, *) {
                    if let sheet = navController.sheetPresentationController {
                        sheet.detents = [UISheetPresentationController.Detent.medium(), UISheetPresentationController.Detent.large()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 24

                        // Add delegate to handle dismissal properly
                        sheet.delegate = chatVC
                    }
                } else {
                    navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                }
            }

            // Ensure safe presentation
            presentViewControllerSafely(navController, from: presenter)
            
        } catch {
            showErrorAlert(message: "Failed to create or fetch chat session: \(error.localizedDescription)", on: presenter)
            isPresentingChat = false
        }
    }

    private func presentViewControllerSafely(_ viewController: UIViewController, from presenter: UIViewController) {
        // Find the top-most view controller
        if let topController = UIApplication.shared.getTopViewController() {
            // Check if we're already presenting something
            if topController.presentedViewController != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.presentViewControllerSafely(viewController, from: presenter)
                }
                return
            }
            
            // Present on the top controller
            topController.present(viewController, animated: true, completion: nil)
        } else {
            // Fallback to the original presenter
            presenter.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func showErrorAlert(message: String, on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Chat Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // Present alert with a slight delay to ensure any pending transitions complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if viewController.presentedViewController == nil, !viewController.isBeingDismissed {
                viewController.present(alert, animated: true)
            } else {
                // If we can't present, at least log the error
                print("Could not present error alert: \(message)")
                self.isPresentingChat = false
            }
        }
    }
}
