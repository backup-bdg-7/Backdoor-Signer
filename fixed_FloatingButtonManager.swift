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
        // Get the root view controller with iOS 15+ compatibility
        let rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        } else {
            rootVC = UIApplication.shared.windows.first?.rootViewController
        }
        
        guard let viewController = rootVC else { return }
        addButton(to: viewController)
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
        guard let context = try? CoreDataManager.shared.context else {
            print("Failed to get context")
            isPresentingChat = false
            return
        }
        
        let session: ChatSession
        
        // Get active session or create a new one
        let fetchRequest: NSFetchRequest<ChatSession> = ChatSession.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingSession = results.first {
                session = existingSession
            } else {
                session = ChatSession(context: context)
                session.title = "New Chat"
                session.creationDate = Date()
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
        if let topController = UIApplication.shared.topViewController {
            // Check if we're already presenting something
            if topController.presentedViewController != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.presentViewControllerSafely(viewController, from: presenter)
                }
                return
            }
            
            // Present on the top controller
            topController.present(viewController, animat# Let's check the rest of the UIApplication+TopViewController.swift file
cat iOS/Extensions/UIKit/UIApplication+TopViewController.swift

# Let's try again with the fixed file
cat << 'EOF' > fixed_FloatingButtonManager.swift
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
        // Get the root view controller with iOS 15+ compatibility
        let rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        } else {
            rootVC = UIApplication.shared.windows.first?.rootViewController
        }
        
        guard let viewController = rootVC else { return }
        addButton(to: viewController)
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
        guard let context = try? CoreDataManager.shared.context else {
            print("Failed to get context")
            isPresentingChat = false
            return
        }
        
        let session: ChatSession
        
        // Get active session or create a new one
        let fetchRequest: NSFetchRequest<ChatSession> = ChatSession.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingSession = results.first {
                session = existingSession
            } else {
                session = ChatSession(context: context)
                session.title = "New Chat"
                session.creationDate = Date()
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
        if let topController = UIApplication.shared.topMostViewController() {
            // Check if we're already presenting something
            if topController.presentedViewController != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.presentViewControllerSafely(viewController, from: presenter)
                }
                return
            }
            
            // Present on the top controller
            topController.present(viewController, animated: true)
        } else {
            // Fallback to the original presenter
            presenter.present(viewController, animated: true)
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
            if viewControl# Let's check one more time how to get the top view controller
cat iOS/Extensions/UIKit/UIApplication+TopViewController.swift

# Let's try a focused fix that only addresses the build errors
cat << 'EOF' > focused_fix.sh
#!/bin/bash
set -e

# Create a backup
cp iOS/Operations/App/FloatingButtonManager.swift iOS/Operations/App/FloatingButtonManager.swift.bak

# Fix 1: Replace persistentContainer with context
sed -i 's/persistentContainer.viewContext/context/g' iOS/Operations/App/FloatingButtonManager.swift

# Fix 2: Replace ChatSession properties
sed -i 's/session.id = UUID()/session.title = "New Chat"; session.creationDate = Date()/g' iOS/Operations/App/FloatingButtonManager.swift
sed -i 's/session.createdAt = Date()//g' iOS/Operations/App/FloatingButtonManager.swift
sed -i 's/session.name = "New Chat"//g' iOS/Operations/App/FloatingButtonManager.swift

# Fix 3: Fix the top view controller reference
sed -i 's/getTopViewController/topMostViewController/g' iOS/Operations/App/FloatingButtonManager.swift

# Fix 4: Fix UIApplication.shared.windows usage
cat << 'EOL' > temp.txt
    /// Shows the AI button. This is called from AppDelegate.
    func show() {
        // Get the root view controller with iOS 15+ compatibility
        let rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        } else {
            rootVC = UIApplication.shared.windows.first?.rootViewController
        }
        
        guard let viewController = rootVC else { return }
        addButton(to: viewController)
    }
EOL

sed -i '/func show() {/,/}/c\' iOS/Operations/App/FloatingButtonManager.swift
sed -i '/func hide() {/i\'"$(cat temp.txt)"'' iOS/Operations/App/FloatingButtonManager.swift
rm temp.txt

# Fix 5: Remove explicit 'nil' value in completion handler
sed -i 's/animated: true, completion: nil)/animated: true)/g' iOS/Operations/App/FloatingButtonManager.swift

echo "Applied focused fixes"
