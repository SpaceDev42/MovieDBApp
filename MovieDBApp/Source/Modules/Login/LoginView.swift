//
//  LoginView.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @StateObject private var viewModel = LoginViewModel(dependencies: LoginViewModelDependencies())

    var body: some View {
        ZStack{
            Color(backgroundColor: .almostBlack)
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 82) {
                Image(ImageSet.MovieDBIcon.movieDbIcon.rawValue)
                    .frame(width: 144, height: 128)

                userCredentialsView
            }
        }
        .onDisappear {
            viewModel.username = ""
            viewModel.password = ""
        }
        .alert("Invalid Login", isPresented: $viewModel.showingAlert, actions: {
            Button("Ok") {
                viewModel.username = ""
                viewModel.password = ""
            }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
        .onReceive(viewModel.loginSubject) { _ in
            coordinator.presentTVshows()
        }
    }

    private var userCredentialsView: some View {
        VStack(alignment: .center, spacing: 19) {

            Section {
                TextField(text: $viewModel.username) {
                    Text("Username")
                        .keyboardType(.emailAddress)
                        .foregroundStyle(.gray)
                }

                SecureField(text: $viewModel.password) {
                    Text("Password")
                        .foregroundStyle(.gray)
                }
            }
            .foregroundStyle(.black)
            .padding()
            .frame(width: 208, height: 52)
            .background(Color.white)
            .cornerRadius(5)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

            loginButton
        }
        .font(.custom("SFProText-Bold", size: 14))
    }

    private var loginButton: some View {
        Button {
            viewModel.validateUserCredentials()
        } label: {
            if viewModel.isLogging {
                ProgressView()
            } else {
                Text("Log in")
            }
        }
        .tint(Color.white)
        .padding()
        .frame(width: 208, height: 52)
        .background(Color(mainColor: .algaeGreen))
        .cornerRadius(5)
        .disabled(viewModel.loginDisabled)
        .buttonStyle(.borderless)
    }
}
