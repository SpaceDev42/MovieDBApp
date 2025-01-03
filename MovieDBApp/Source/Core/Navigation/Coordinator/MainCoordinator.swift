//
//  MainCoordinator.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import SwiftUI

// MARK: Main Coordinator Type
protocol MainCoordinatorType: CoordinatorType {
    func presentLogin()
    func presentTVshows()
    func presentShowDetail()
}

// MARK: - App Main Coordinator
class MainCoordinator: ObservableObject, MainCoordinatorType {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func presentLogin() {
        show(route: )
    }

    func start() {
        presentTVshows()
    }
    
    func presentTVshows() {
        show(route: .tvShows)
    }
    
    func presentShowDetail() {
        show(route: .showDetail)
    }
    
    // MARK: - Convenience Show Method
    private func show(route: MainNavigationRoute) {
        show(route: route, animated: true)
    }
}
