//
//  HomePageView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/29/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HomePageView: View {
    @Bindable var store: StoreOf<HomePage>

    var body: some View {
        VStack {
            toolbarView()

            ChatView(store: store.scope(state: \.chat, action: \.chat))
        }
        .background(Color.background)
    }
    
    @ViewBuilder
    fileprivate func toolbarView() -> some View {
        HStack {
            Spacer()
            toolbarImage(for: "person.crop.circle")
                .onTapGesture {
                    store.send(.accountTapped)
                }
        }
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    fileprivate func toolbarImage(for imageName: String) -> some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundStyle(Color.buttonPrimary)
    }
}

#Preview {
    HomePageView(
        store: .init(
        initialState: HomePage.State(),
        reducer: { HomePage() })
    )
}
