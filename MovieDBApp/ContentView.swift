//
//  ContentView.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainCoordinator: MainCoordinator = .init()
    
    var body: some View {
        NavigationView {
            MoviesView()
                .environmentObject(mainCoordinator)
                .navigationTitle("Movies")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(neutralColor: .dark), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
