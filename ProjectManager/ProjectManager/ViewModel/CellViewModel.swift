//
//  CellViewModel.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/15.
//

import Foundation

final class CellViewModel {
    private enum Constant {
        static let defaultData = Plan(
            id: UUID(), title: "", content: "", deadLine: Date(), processState: Process.todo.state
        )
    }
    
    private var data: Plan = Constant.defaultData {
        didSet {
            dataHandler?(data)
        }
    }
    
    private var dataHandler: ((Plan) -> Void)?
}

// MARK: - Method
extension CellViewModel {
    func bindData(handler: @escaping (Plan) -> Void) {
        dataHandler = handler
    }
    
    func setupData(_ data: Plan) {
        self.data = data
    }
    
    func checkOverDeadLine() -> Bool {
        return data.isOverDeadLine
    }
}
