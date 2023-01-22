//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/12.
//

import Foundation

final class MainViewModel {
    private var updateDataProcess: Process?
    private var updateDataIndex: Int?
    
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
    
    private var todoHandler: (([Plan]) -> Void)?
    private var doingHandler: (([Plan]) -> Void)?
    private var doneHandler: (([Plan]) -> Void)?
}

// MARK: - Method
extension MainViewModel {
    func bindTodo(handler: @escaping ([Plan]) -> Void) {
        handler(todoData)
        self.todoHandler = handler
    }
    
    func bindDoing(handler: @escaping ([Plan]) -> Void) {
        handler(doingData)
        self.doingHandler = handler
    }
    
    func bindDone(handler: @escaping ([Plan]) -> Void) {
        handler(doneData)
        self.doneHandler = handler
    }
    
    func updateData(data: Plan) {
        guard let index = updateDataIndex else {
            todoData.append(data)
            return
        }
        
        guard let process = updateDataProcess else { return }
        
        switch process {
        case .todo:
            todoData[index] = data
        case .doing:
            doingData[index] = data
        case .done:
            doneData[index] = data
        }
        
        resetUpdateInfo()
    }
    
    func fetchSeletedData() -> Plan? {
        guard let process = updateDataProcess else { return nil }
        guard let index = updateDataIndex else { return nil }
        
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
    
    func deleteData(process: Process, index: Int) {
        switch process {
        case .todo:
            guard index < todoData.count else { return }
            todoData.remove(at: index)
        case .doing:
            guard index < doingData.count else { return }
            doingData.remove(at: index)
        case .done:
            guard index < doneData.count else { return }
            doneData.remove(at: index)
        }
        
        resetUpdateInfo()
    }
    
    func changeProcess(after: Process) {
        guard let index = updateDataIndex else { return }
        guard let process = updateDataProcess else { return }
        
        switch process {
        case .todo:
            if after == .doing {
                doingData.append(todoData.remove(at: index))
            } else {
                doneData.append(todoData.remove(at: index))
            }
        case .doing:
            if after == .todo {
                todoData.append(doingData.remove(at: index))
            } else {
                doneData.append(doingData.remove(at: index))
            }
        case .done:
            if after == .todo {
                todoData.append(doneData.remove(at: index))
            } else {
                doingData.append(doneData.remove(at: index))
            }
        }
        
        resetUpdateInfo()
    }
    
    func prepareForEvent(process: Process, index: Int?) {
        updateDataProcess = process
        updateDataIndex = index
    }
    
    func resetUpdateInfo() {
        updateDataIndex = nil
        updateDataProcess = nil
    }
    
    func configureButtonProcess() -> [Process] {
        return Process.allCases.filter {
            $0 != updateDataProcess
        }
    }
}
