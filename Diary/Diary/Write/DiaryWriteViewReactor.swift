//
//  DiaryWriteViewReactor.swift
//  Diary
//
//  Created by Daehoon Lee on 8/13/25.
//

import Foundation
import ReactorKit

final class DiaryWriteViewReactor: ReactorKit.Reactor {
    
    enum Action {
        case inputTitle(String)
        case inputContent(String)
        case save
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
    }
    
    struct State {
        var title: String = ""
        var content: String = ""
        
        var isRequestEnable: Bool {
            !title.isEmpty && !content.isEmpty
        }
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputTitle(let title):
            return Observable.just(Mutation.setTitle(title))
        case .inputContent(let content):
            return Observable.just(Mutation.setContent(content))
        case .save:
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setTitle(let title):
            state.title = title
        case .setContent(let content):
            state.content = content
        }
        
        return state
    }
}
