//
//  DiaryCoreData.swift
//  Diary
//
//  Created by Daehoon Lee on 8/11/25.
//

import Foundation

protocol DiaryCoreDataProtocol { // 기능 명세
    func saveDiary(diary: DiaryItem) -> Result<Bool, CoreDataError>                             // 다이어리 생성
    func deleteDiary(id: String) -> Result<Bool, CoreDataError>                                 // 다이어리 제거
    func getDiary(id: String) -> Result<DiaryItem, CoreDataError>                               // 다이어리 상세 조회
    func getDiaryList(query: String?) -> Result<[DiaryItem], CoreDataError>                     // 다이어리 목록 조회
    func editDiary(id: String, title: String, content: String) -> Result<Bool, CoreDataError>   // 다이어리 수정
}
