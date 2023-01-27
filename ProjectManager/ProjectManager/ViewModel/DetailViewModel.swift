//
//  DetailViewModel.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/14.
//

import Foundation

final class DetailViewModel {
    private enum Constant {
        static let defaultText = ""
    }

    private let dataId: UUID
    private(set) var index: Int?
    private(set) var processStatus: Int
    
    private var title: String = Constant.defaultText {
        didSet {
            titleHandler?(title)
        }
    }
    
    private var date: Date = Date() {
        didSet {
            dateHandler?(date)
        }
    }
    
    private var content: String = Constant.defaultText {
        didSet {
            contentHandler?(content)
        }
    }
    
    private var isfinishEdit = false {
        didSet {
            finishHandler?()
        }
    }
    
    private(set) var isEditable = false {
        didSet {
            editableHandler?(isEditable)
        }
    }
    
    private var titleHandler: ((String) -> Void)?
    private var dateHandler: ((Date) -> Void)?
    private var contentHandler: ((String) -> Void)?
    private var editableHandler: ((Bool) -> Void)?
    private var finishHandler: (() -> Void)?
    
    init(data: Plan?, index: Int?) {
        guard let data = data else {
            dataId = UUID()
            processStatus = Process.todo.state
            isEditable = true
            return
        }
        
        self.index = index
        dataId = data.id
        title = data.title
        date = data.deadLine
        content = data.content
        processStatus = data.processState
        isEditable = false
    }
}

// MARK: - Method
extension DetailViewModel {
    func isNewMode() -> Bool {
        return index == nil
    }
    
    func bindTitle(handler: @escaping (String) -> Void) {
        handler(title)
        titleHandler = handler
    }
    
    func bindDate(handler: @escaping (Date) -> Void) {
        handler(date)
        dateHandler = handler
    }
    
    func bindContent(handler: @escaping (String) -> Void) {
        handler(content)
        contentHandler = handler
    }
    
    func bindEditable(handler: @escaping (Bool) -> Void) {
        handler(isEditable)
        editableHandler = handler
    }
    
    func bindFinishEvent(handler: @escaping () -> Void) {
        finishHandler = handler
    }
    
    func editToggle() {
        isEditable.toggle()
    }
    
    func finishEdit() {
        isfinishEdit.toggle()
    }
    
    func createData(title: String?, content: String?, date: Date?) -> Plan {
        
        return Plan(
            id: dataId,
            title: title ?? "",
            content: content ?? "",
            deadLine: date ?? Date(),
            processState: processStatus
        )
    }
}
