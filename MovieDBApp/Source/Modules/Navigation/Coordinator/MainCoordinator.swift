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
    func presentTVshows()
    func presentShowDetail()
}

// MARK: - App Main Coordinator
class MainCoordinator: ObservableObject, MainCoordinatorType {
    var navigationController: UINavigationController?
    
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
