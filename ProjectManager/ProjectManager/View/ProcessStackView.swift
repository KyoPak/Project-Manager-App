//
//  ProcessStackView.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/11.
//

import UIKit

final class ProcessStackView: UIStackView {
    private enum UIConstraint {
        static let headerViewHeight = 80.0
        static let stackViewSpacing = 5.0
    }
    
    let headerView: HeaderView
    let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var stackView = UIStackView(
        views: [headerView, tableView],
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: UIConstraint.stackViewSpacing
    )
    
    init(process: Process) {
        headerView = HeaderView(process: process)
        super.init(frame: .zero)
        setupView()
        setupCosntraint()
        layoutIfNeeded()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration
extension ProcessStackView {
    private func setupView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    private func setupCosntraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            headerView.widthAnchor.constraint(equalTo: widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: UIConstraint.headerViewHeight)
        ])
    }
}
