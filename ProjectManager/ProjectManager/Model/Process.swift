//
//  Process.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/11.
//

import Foundation

enum Process: CaseIterable {
    case todo
    case doing
    case done
    
    var state: Int {
        switch self {
        case .todo:
            return 0
        case .doing:
            return 1
        case .done:
            return 2
        }
    }
}

extension Process: CustomStringConvertible {
    var description: String {
        switch self {
        case .todo:
            return "TODO"
        case .doing:
            return "DOING"
        case .done:
            return "DONE"
        }
    }
}
