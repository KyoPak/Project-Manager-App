//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/12.
//

import Foundation

final class MainViewModel {
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
}

// MARK: - Method
extension MainViewModel {
    func bindTodo(handler: @escaping ([Plan]) -> Void) {
        self.todoHandler = handler
    }
    
    func bindDoing(handler: @escaping ([Plan]) -> Void) {
        self.doingHandler = handler
    }
    
    func bindDone(handler: @escaping ([Plan]) -> Void) {
        self.doneHandler = handler
    }
    
    func bindProcessList(handler: @escaping ([Process]) -> Void) {
        self.processListHandler = handler
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
    func updateData(data: Plan, process: Process, index: Int?) {
        guard let index = index else {
            todoData.append(data)
            return
        }
        
        switch process {
        case .todo:
            todoData[index] = data
        case .doing:
            doingData[index] = data
        case .done:
            doneData[index] = data
        }
    }

    @discardableResult
    func deleteData(process: Process, index: Int) -> Plan? {
        switch process {
        case .todo:
            guard index < todoData.count else { return nil }
            return todoData.remove(at: index)
        case .doing:
            guard index < doingData.count else { return nil }
            return doingData.remove(at: index)
        case .done:
            guard index < doneData.count else { return nil }
            return doneData.remove(at: index)
        }
    }
    
    func changeProcess(_ after: Process) {
        guard let before = movePlan?.beforeProcess else { return }
        guard let index = movePlan?.index else { return }
        guard var data = deleteData(process: before, index: index) else { return }
        
        switch after {
        case .todo:
            data.process = .todo
            todoData.append(data)
        case .doing:
            data.process = .doing
            doingData.append(data)
        case .done:
            data.process = .done
            doneData.append(data)
        }
        
        movePlan = nil
    }
}
