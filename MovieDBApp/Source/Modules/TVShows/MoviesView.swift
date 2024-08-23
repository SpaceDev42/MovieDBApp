//
//  MoviesView.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 15/3/24.
//

import Foundation
import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    // MARK: - Initialization
    init() {
        UISegmentedControl.appearance().tintColor = UIColor(named: ColorPalette.Neutral.dark2.rawValue)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: ColorPalette.Neutral.slateGrey.rawValue)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        VStack {
            categoriesPicker
                .padding(.bottom, 15)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
        .background(Color(backgroundColor: .almostBlack))
    }
    
    // MARK: - Categories
    private var categoriesPicker: some View {
        Picker("", selection: $viewModel.selectedCategory) {
            ForEach(MoviesCategory.allCases, id: \.label) {
                Text($0.label)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var movies: some View {
        ScrollView {
            VStack {
                /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
            }
        }
    }
}
