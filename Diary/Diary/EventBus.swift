//
//  EventBus.swift
//  Diary
//
//  Created by Daehoon Lee on 8/17/25.
//

import Foundation
import RxSwift

enum DiaryEvent {
    case refreshList
}

final class EventBus {
    
    static let shared = EventBus()
    
    private init() {}
    
    private let subject = PublishSubject<DiaryEvent>()
    
    func asObservable() -> Observable<DiaryEvent> {
        subject.asObservable()
    }
    
    func publish(event: DiaryEvent) {
        subject.onNext(event)
    }
}
