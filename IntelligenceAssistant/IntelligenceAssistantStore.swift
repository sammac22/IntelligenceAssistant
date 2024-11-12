//
//  IntelligenceAssistantStore.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct IntelligenceAssistant {
    @ObservableState
    struct State: Equatable {
        var hasAPIKey: Bool = false
        
        var landingPageState: LandingPage.State? = nil
        var homePageState: HomePage.State? = nil
        
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case initialize
        case landingPage(LandingPage.Action)
        case homePage(HomePage.Action)
        case path(StackActionOf<Path>)
    }
    
    @Dependency(\.apiKeyManager) var apiKeyManager
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                state.hasAPIKey = apiKeyManager.checkKeys()
                if state.hasAPIKey {
                    state.homePageState = .init()
                } else {
                    state.landingPageState = .init()
                }
                return .none
            case .landingPage(let landingAction):
                switch landingAction {
                case .submitAPIKey:
                    state.hasAPIKey = apiKeyManager.checkKeys()
                    if state.hasAPIKey {
                        state.homePageState = .init()
                        state.landingPageState = nil
                    }
                    return .none
                }
            case .homePage(let homeAction):
                switch homeAction {
                case .accountTapped:
                    state.path.append(.accountPage(Account.State()))
                    return .none
                default:
                    return .none
                }
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.landingPageState,
                action: \.landingPage) {
            LandingPage()
        }
        .ifLet(\.homePageState,
                action: \.homePage) {
            HomePage()
        }
    }
}

// MARK: - Navigation
extension IntelligenceAssistant {
    @Reducer(state: .equatable)
    enum Path {
        case accountPage(Account)
        case chat(ChatStore)
    }
}
