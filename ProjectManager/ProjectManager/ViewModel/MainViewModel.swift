//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/12.
//

import Foundation

final class MainViewModel {
    private let fireStoreManager: CRUDManageable
    
    private var todoData: [Plan] = [] {
        didSet {
            todoHandler?(todoData)
        }
    }
    
    private var doingData: [Plan] = [] {
        didSet {
            doingHandler?(doingData)
        }
    }
    
    private var doneData: [Plan] = [] {
        didSet {
            doneHandler?(doneData)
        }
    }
    
    private var popOverProcessList: [Process] = [] {
        didSet {
            processListHandler?(popOverProcessList)
        }
    }
    
    private(set) var movePlan: MovePlan?
    
    private var todoHandler: (([Plan]) -> Void)?
    private var doingHandler: (([Plan]) -> Void)?
    private var doneHandler: (([Plan]) -> Void)?
    private var processListHandler: (([Process]) -> Void)?
    
    init(crudManager: CRUDManageable) {
        fireStoreManager = crudManager
    }
}

// MARK: - Method
extension MainViewModel {
    func bindTodo(handler: @escaping ([Plan]) -> Void) {
        todoHandler = handler
    }
    
    func bindDoing(handler: @escaping ([Plan]) -> Void) {
        doingHandler = handler
    }
    
    func bindDone(handler: @escaping ([Plan]) -> Void) {
        doneHandler = handler
    }
    
    func bindProcessList(handler: @escaping ([Process]) -> Void) {
        processListHandler = handler
    }
    
    func fetchSeletedData(process: Process, index: Int?) -> Plan? {
        guard let index = index else { return nil }
        
        switch process {
        case .todo:
            guard index < todoData.count else { return nil }
            return todoData[index]
        case .doing:
            guard index < doingData.count else { return nil }
            return doingData[index]
        case .done:
            guard index < doneData.count else { return nil }
            return doneData[index]
        }
    }
    
    func configureMovePlan(_ movePlan: MovePlan) {
        self.movePlan = movePlan
        popOverProcessList = configureButton(process: movePlan.beforeProcess)
    }

    private func configureButton(process: Process) -> [Process] {
        return Process.allCases.filter {
            $0 != process
        }
    }
}

// MARK: - Update, Delete Data, Change Process
extension MainViewModel {
    func loadData() {
        fireStoreManager.load(.todo) { datas in
            self.todoData = datas
        }
        
        fireStoreManager.load(.doing) { datas in
            self.doingData = datas
        }
        
        fireStoreManager.load(.done) { datas in
            self.doneData = datas
        }
    }
    
    func updateData(data: Plan, index: Int?) {
        guard let index = index else {
            todoData.append(data)
            fireStoreManager.add(data: data)
            return
        }
        
        switch data.processState {
        case Process.todo.state:
            todoData[index] = data
        case Process.doing.state:
            doingData[index] = data
        case Process.done.state:
            doneData[index] = data
        default:
            return
        }
        
        fireStoreManager.add(data: data)
    }

    @discardableResult
    func deleteData(process: Process, index: Int) -> Plan? {
        let data: Plan
        switch process {
        case .todo:
            guard index < todoData.count else { return nil }
            data = todoData.remove(at: index)
        case .doing:
            guard index < doingData.count else { return nil }
            data = doingData.remove(at: index)
        case .done:
            guard index < doneData.count else { return nil }
            data = doneData.remove(at: index)
        }
        
        fireStoreManager.delete(data: data)
        return data
        
    }
    
    func changeProcess(_ after: Process) {
        guard let before = movePlan?.beforeProcess else { return }
        guard let index = movePlan?.index else { return }
        guard var data = deleteData(process: before, index: index) else { return }
        
        switch after {
        case .todo:
            data.processState = Process.todo.state
            todoData.append(data)
        case .doing:
            data.processState = Process.doing.state
            doingData.append(data)
        case .done:
            data.processState = Process.done.state
            doneData.append(data)
        }
        
        fireStoreManager.add(data: data)
        movePlan = nil
    }
}
