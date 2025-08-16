//
//  DiaryListViewReactor.swift
//  Diary
//
//  Created by Daehoon Lee on 8/15/25.
//

import Foundation
import ReactorKit

final class DiaryListViewReactor: ReactorKit.Reactor {
    
    enum Mode {
        case normal
        case delete
    }
    
    enum Action {
        case touchMode
        case query(String)
        case selectItem(id: String)
        case delete
    }
    
    enum Mutation {
        case setList([DiaryItem])
        case setMode(Mode)
        case setSelectedItems(Set<String>)
        case deleteSuccess(Bool)
        case setError(CoreDataError?)
    }
    
    struct State {
        var mode: Mode = .normal
        var list: [DiaryItem] = []
        var selectedItems: Set<String> = []
        var deleteSuccess: Bool = false
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
        case .touchMode:
            return .empty()
        case .query(let string):
            return .empty()
        case .selectItem(let id):
            return .empty()
        case .delete:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setList(let list):
            state.list = list
        case .setMode(let mode):
            state.mode = mode
        case .setSelectedItems(let selectedItems):
            state.selectedItems = selectedItems
        case .deleteSuccess(let isSuccess):
            state.deleteSuccess = isSuccess
        case .setError(let coreDataError):
            state.error = coreDataError
        }
        
        return state
    }
}

struct DiaryListCellData: Equatable {
    let isSelected: Bool?
    let diary: DiaryItem
}
