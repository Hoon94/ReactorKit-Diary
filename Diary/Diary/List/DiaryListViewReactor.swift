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
        case refresh
        case touchMode
        case query(String)
        case selectItem(id: String)
        case delete
    }
    
    enum Mutation {
        case setCellDataList([DiaryListCellData])
        case setList([DiaryItem])
        case setMode(Mode)
        case setSelectedItems(Set<String>)
        case deleteSuccess(Bool)
        case setError(CoreDataError?)
        case setQuery(String)
    }
    
    struct State {
        var query: String = ""
        var mode: Mode = .normal
        var cellDataList: [DiaryListCellData] = []
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
        case .refresh:
            return getList(query: currentState.query)
        case .touchMode:
            return .empty()
        case .query(let query):
            return .concat(
                getList(query: query),
                .just(Mutation.setQuery(query))
            )
        case .selectItem(let id):
            return .empty()
        case .delete:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCellDataList(let cellDataList):
            state.cellDataList = cellDataList
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
        case .setQuery(let query):
            state.query = query
        }
        
        return state
    }
    
    private func getList(query: String) -> Observable<Mutation> {
        let result = coreData.getDiaryList(query: query)
        
        switch result {
        case .success(let list):
            return Observable.concat(
                .just(Mutation.setList(list)),
                createCellData(list: list, mode: currentState.mode, selectedItems: currentState.selectedItems)
                    .map { Mutation.setCellDataList($0) }
            )
        case .failure(let error):
            return Observable.just(Mutation.setError(error))
        }
    }
    
    private func createCellData(list: [DiaryItem], mode: Mode, selectedItems: Set<String>) -> Observable<[DiaryListCellData]> {
        let cellDataList = list.map { item in
            switch mode {
            case .normal:
                return DiaryListCellData(isSelected: nil, diary: item)
            case .delete:
                let isSelected = selectedItems.contains(item.id)
                return DiaryListCellData(isSelected: isSelected, diary: item)
            }
        }
        
        return .just(cellDataList)
    }
}

struct DiaryListCellData: Equatable {
    let isSelected: Bool?
    let diary: DiaryItem
    let cellId = DiaryListTableViewCell.id
}
