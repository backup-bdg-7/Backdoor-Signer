import SwiftUI
import UIKit
import CoreData

// MARK: - Notification Names

extension Notification.Name {
    static let showAIAssistant = Notification.Name("showAIAssistant")
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
    
    // Button management
    private var activeButton: FloatingTerminalButton?
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Lifecycle
    
    private init() {
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
    
    @objc func showAIAssistant(notification: Notification) {
        guard let viewController = notification.object as? UIViewController else {
            return
        }
        presentAIAssistant(from: viewController)
    }
    
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
    
    func hide() {
        removeButton()
    }
    
    func toggleButton(in viewController: UIViewController) {
        if activeButton != nil {
            removeButton()
        } else {
            addButton(to: viewController)
        }
    }
    
    func removeButton() {
        guard let button = activeButton else { return }
        
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
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
        guard !isPresentingChat else { return }
        isPresentingChat = true
        
        guard let context = try? CoreDataManager.shared.context else {
            print("Failed to get context")
            isPresentingChat = false
            return
        }
        
        let session: ChatSession
        
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
            
            let chatVC = ChatViewController(session: session)
            chatVC.dismissHandler = { [weak self] in
                self?.isPresentingChat = false
            }
            
            let navController = UINavigationController(rootViewController: chatVC)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
                navController.preferredContentSize = CGSize(width: 540, height: 620)
            } else {
                if #available(iOS 15.0, *) {
                    if let sheet = navController.sheetPresentationController {
                        sheet.detents = [UISheetPresentationController.Detent.medium(), UISheetPresentationController.Detent.large()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 24
                        sheet.delegate = chatVC
                    }
                } else {
                    navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                }
            }
            
            presentViewControllerSafely(navController, from: presenter)
            
        } catch {
            showErrorAlert(message: "Failed to create or fetch chat session: \(error.localizedDescription)", on: presenter)
            isPresentingChat = false
        }
    }
    
    private func presentViewControllerSafely(_ viewController: UIViewController, from presenter: UIViewController) {
        if let topController = UIApplication.shared.topMostViewController() {
            if topController.presentedViewController != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.presentViewControllerSafely(viewController, from: presenter)
                }
     # Let's create a much simpler file that just focuses on fixing the build errors
cat << 'EOF' > FloatingButtonManager.swift
import SwiftUI
import UIKit
import CoreData

// MARK: - Notification Names

extension Notification.Name {
    static let showAIAssistant = Notification.Name("showAIAssistant")
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
    
    // Button management
    private var activeButton: FloatingTerminalButton?
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Lifecycle
    
    private init() {
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
    
    @objc func showAIAssistant(notification: Notification) {
        guard let viewController = notification.object as? UIViewController else {
            return
        }
        presentAIAssistant(from: viewController)
    }
    
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
    
    func hide() {
        removeButton()
    }
    
    func toggleButton(in viewController: UIViewController) {
        if activeButton != nil {
            removeButton()
        } else {
            addButton(to: viewController)
        }
    }
    
    private func removeButton() {
        guard let button = activeButton else { return }
        
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
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
        guard !isPresentingChat else { return }
        isPresentingChat = true
        
        guard let context = try? CoreDataManager.shared.context else {
            print("Failed to get context")
            isPresentingChat = false
            return
        }
        
        let session: ChatSession
        
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
            
            let chatVC = ChatViewController(session: session)
            chatVC.dismissHandler = { [weak self] in
                self?.isPresentingChat = false
            }
            
            let navController = UINavigationController(rootViewController: chatVC)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
                navController.preferredContentSize = CGSize(width: 540, height: 620)
            } else {
                if #available(iOS 15.0, *) {
                    if let sheet = navController.sheetPresentationController {
                        sheet.detents = [UISheetPresentationController.Detent.medium(), UISheetPresentationController.Detent.large()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 24
                        sheet.delegate = chatVC
                    }
                } else {
                    navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                }
            }
            
            presentViewControllerSafely(navController, from: presenter)
            
        } catch {
            showErrorAlert(message: "Failed to create or fetch chat session: \(error.localizedDescription)", on: presenter)
            isPresentingChat = false
        }
    }
    
    private func presentViewControllerSafely(_ viewController: UIViewController, from presenter: UIViewController) {
        if let topController = UIApplication.shared.topMostViewController() {
            if topController.presentedViewController != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.presentViewControllerSafely(viewController, from: presenter)
                }
                return
            }
            
            topController.present(viewController, animated: true)
        } else {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if viewController.presentedViewController == nil, !viewController.isBeingDismissed {
                viewController.present(alert, animated: true)
            } else {
                print("Could not present error alert: \(message)")
                self.isPresentingChat = false
            }
        }
    }
}
