//
//  CoreDataError.swift
//  Diary
//
//  Created by Daehoon Lee on 8/11/25.
//

import Foundation

enum CoreDataError: Error {
    case entityNotFound(String)
    case saveError(String)
    case readError(String)
    case deleteError(String)
    case editError(String)
    
    var description: String {
        switch self {
        case .entityNotFound(let entity):
            return "Core Data 객체 \(entity) Not Found"
        case .saveError(let message):
            return "Core Data 저장 에러 \(message)"
        case .readError(let message):
            return "Core Data 조회 에러 \(message)"
        case .deleteError(let message):
            return "Core Data 삭제 에러 \(message)"
        case .editError(let message):
            return "Core Data 수정 에러 \(message)"
        }
    }
}
