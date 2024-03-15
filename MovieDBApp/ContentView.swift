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
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .environmentObject(mainCoordinator)
        }
    }
}

#Preview {
    ContentView()
}
