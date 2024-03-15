//
//  CoordinatorType.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

import UIKit
import SwiftUI

// MARK: - CoordinatorType Protocol
protocol CoordinatorType: AnyObject {
    /// The controller's navigation controller
    var navigationController: UINavigationController? { get set }
    
    /// Function that starts a coordinator in a given entry point
    func start()
    func routeToview(_ route: NavigationRoute, animated: Bool)
    func routeToCoordinator(_ route: NavigationRoute)
    func present(viewController: UIViewController, transition: NavigationTranisitionStyle, animated: Bool)
    func show(route: NavigationRoute, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func dismiss(animated: Bool)
    func popToNavigationController(_ stepsBack: Int, animated: Bool)
}

// MARK: - MainCoordinatorType Protocol
//protocol MainCoordinatorType {
    /// The main coordinator's window.  This is used internally to set the app's navigation root.
//    var window: UIWindow? { get set }
    /// Starts the coordinator.
//    func start()
    /// Sets the app's navigation root
//    func setNavigationRoot(to route: NavigationRoot)
    
//    func presentGlobalPopup(_ view: any View)
//    func presentGlobalCoordinator(_ coordinator: CoordinatorType)
//    func dismissGlobalPopup()
//}

extension CoordinatorType {
    // MARK: - Private Methods
    func routeToview(_ route: NavigationRoute, animated: Bool) {
        guard let view = route.getView(coordinator: self) else { return }
        let viewController = UIHostingController(rootView: AnyView(view))
        self.navigationController?.overrideUserInterfaceStyle = route.mode
        present(viewController: viewController, transition: route.transition, animated: animated)
    }
    
    func routeToCoordinator(_ route: NavigationRoute) {
        guard let coordinator = route.coordinator else { return }
        coordinator.navigationController = navigationController
        coordinator.start()
    }
    
    func present(viewController: UIViewController, transition: NavigationTranisitionStyle, animated: Bool) {
        switch transition {
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
            navigationController?.isNavigationBarHidden = true
        case .presentModal:
            viewController.modalPresentationStyle = .formSheet
            navigationController?.present(viewController, animated: animated)
        case .fullScreen:
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.present(viewController, animated: animated)
        }
    }
    
    func show(route: NavigationRoute, animated: Bool = true) {
        switch route.type {
        case .coordinator:
            routeToCoordinator(route)
        case .view:
            routeToview(route, animated: animated)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        navigationController?.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.navigationController?.viewControllers = []
        }
    }
    
    func popToNavigationController(_ stepsBack: Int, animated: Bool = true) {
        guard var controllers = navigationController?.viewControllers else { return }
        if controllers.count < stepsBack {return}
        for _ in 1...stepsBack - 1 {
            controllers.removeLast()
        }
        navigationController?.viewControllers = controllers
        navigationController?.popViewController(animated: animated)
    }
}
