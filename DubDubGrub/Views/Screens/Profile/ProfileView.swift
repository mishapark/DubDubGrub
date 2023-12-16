//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Mikhail Pak on 2023-12-05.
//

import AVKit
import PhotosUI
import SwiftUI

enum ProfileTextField {
  case firstName, lastName, companyName, bio
}

@MainActor
struct ProfileView: View {
  @State private var viewModel = ProfileViewModel()
  @FocusState private var focusedTextField: ProfileTextField?

  var body: some View {
    ZStack {
      VStack {
        ProfileAboutView(viewModel: viewModel)

        HStack(alignment: .bottom) {
          CharactersRemainView(currentCount: viewModel.bio.count)
            .padding(.top, 25)
            .accessibilityAddTraits(.isHeader)
          Spacer()

          if viewModel.isCheckedIn {
            Button {
              Task {
                await viewModel.checkOut()
              }
            } label: {
              CheckoutButtonView()
            }
            .disabled(viewModel.isLoading)
          }
        }
        .padding(.horizontal, 20)

        BioTextEditor(text: $viewModel.bio)
          .focused($focusedTextField, equals: .bio)

        Spacer()

        Button {
          Task {
            await viewModel.determineButtonAction()
          }
        } label: {
          DDGButton(title: viewModel.buttonTitle)
        }
        .padding(.bottom, 20)
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Button {
            focusedTextField = nil
          } label: {
            Text("Dismiss")
          }
        }
      }

      if viewModel.isLoading {
        LoadingView()
      }
    }
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
    .alert(item: $viewModel.alertItem) { $0.alert }
    .task {
      await viewModel.getCheckedInStatus()
      await viewModel.getProfile()
    }
    .ignoresSafeArea(.keyboard)
  }
}

#Preview {
  NavigationStack {
    ProfileView()
  }
}

private struct EditImage: View {
  var body: some View {
    Image(systemName: "square.and.pencil")
      .resizable()
      .scaledToFit()
      .frame(width: 15, height: 15)
      .foregroundStyle(.white)
      .offset(y: 30)
  }
}

private struct CharactersRemainView: View {
  var currentCount: Int

  var body: some View {
    Text("Bio: ")
      .font(.callout)
      .foregroundStyle(.secondary)
      +
      Text("\(100 - currentCount)")
      .font(.callout)
      .foregroundStyle(currentCount <= 100 ? Color(.brandPrimary) : Color.pink)
      +
      Text(" characters remain")
      .font(.callout)
      .foregroundStyle(.secondary)
  }
}

private struct CheckoutButtonView: View {
  var body: some View {
    Label("Check Out", systemImage: "mappin.and.ellipse")
      .bold()
      .padding(10)
      .foregroundStyle(.white)
      .background(Color(.systemPink))
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .accessibilityLabel("Checkout of current location")
  }
}

private struct BioTextEditor: View {
  var text: Binding<String>

  var body: some View {
    TextField("Enter your bio", text: text, axis: .vertical)
      .textFieldStyle(.roundedBorder)
      .lineLimit(4 ... 6)
      .padding(.horizontal, 20)
      .accessibilityHint("This textfield is for your bio and has a 100 character maximum")
  }
}

private struct ProfileAboutView: View {
  @Bindable var viewModel: ProfileView.ProfileViewModel
  @FocusState private var focusedTextField: ProfileTextField?

  var body: some View {
    HStack(spacing: 16) {
      PhotosPicker(selection: $viewModel.selectedImage, matching: .any(of: [.images])) {
        ZStack {
          AvatarView(size: 85, image: viewModel.avatar)
          EditImage()
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityAddTraits(.isButton)
      .accessibilityLabel("Profile photo")

      VStack(alignment: .leading, spacing: 1) {
        TextField("First Name", text: $viewModel.firstName).profileNameStyle()
          .focused($focusedTextField, equals: .firstName)
          .onSubmit {
            focusedTextField = .lastName
          }
          .submitLabel(.next)
        TextField("Last Name", text: $viewModel.lastName).profileNameStyle()
          .focused($focusedTextField, equals: .lastName)
          .onSubmit {
            focusedTextField = .companyName
          }
          .submitLabel(.next)
        TextField("Company Name", text: $viewModel.companyName)
          .focused($focusedTextField, equals: .companyName)
          .onSubmit {
            focusedTextField = .bio
          }
          .submitLabel(.next)
      }
      .padding(.trailing, 16)
      Spacer()
    }
    .padding()
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .padding(.horizontal)
  }
}
