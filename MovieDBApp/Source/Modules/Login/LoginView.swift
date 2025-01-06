//
//  LoginView.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject  var viewModel: LoginViewModel

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
            .background(Color.white)
            .cornerRadius(5)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

            loginButton
        }
        .font(.custom("SFProText-Bold", size: 14))
        .padding(.horizontal, 80)
    }

    private var loginButton: some View {
        Button {
            viewModel.login()
        } label: {
            ZStack {
                if viewModel.isLogging {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Log in")
                        .frame(maxWidth: .infinity) // Ensures the text expands to fill the button width
                }
            }
            .padding()
            .background(Color(mainColor: .algaeGreen))
            .cornerRadius(5)
            .tint(Color.white) // Applies the tint to the text or ProgressView
        }
        .buttonStyle(.borderless)
        .disabled(viewModel.loginDisabled)
    }
}
