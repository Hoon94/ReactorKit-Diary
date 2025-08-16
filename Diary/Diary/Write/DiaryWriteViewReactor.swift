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
        case saveResult(Result<Bool, CoreDataError>)
    }
    
    struct State {
        var title: String = ""
        var content: String = ""
        
        var isRequestEnable: Bool {
            !title.isEmpty && !content.isEmpty
        }
        
        var saveSuccess: Bool = false
        var error: CoreDataError?
    }
    
    var initialState: State
    
    private let coreData: DiaryCoreDataProtocol
    
    init(initialState: State, coreData: DiaryCoreDataProtocol) {
        self.initialState = initialState
        self.coreData = coreData
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputTitle(let title):
            return Observable.just(Mutation.setTitle(title))
        case .inputContent(let content):
            return Observable.just(Mutation.setContent(content))
        case .save:
            let entity = DiaryItem(id: NSUUID().uuidString, title: currentState.title, content: currentState.content, createdDate: .now, editedDate: .now)
            let result = coreData.saveDiary(diary: entity)
            
            return Observable.just(Mutation.saveResult(result))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setTitle(let title):
            state.title = title
        case .setContent(let content):
            state.content = content
        case .saveResult(let result):
            switch result {
            case .success:
                EventBus.shared.publish(event: .refreshList)
                state.saveSuccess = true
            case .failure(let error):
                state.error = error
            }
        }
        
        return state
    }
}
