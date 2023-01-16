//
//  ProcessStackView.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/11.
//

import UIKit

final class ProcessStackView: UIStackView {
    private enum UIConstant {
        static let headerViewHeight = 70.0
        static let stackViewSpacing = 1.0
        static let headerStackViewSpacing = 20.0
        static let topBottomValue = 10.0
        static let leadingValue = 20.0
        static let countLabelWidth = 30.0
    }
    
    private let titleLabel = UILabel(fontStyle: .largeTitle)
    private let countLabel = UILabel(fontStyle: .title3)
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
    private lazy var headerStackView = UIStackView(
        views: [titleLabel, countLabel],
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: UIConstant.headerStackViewSpacing
    )
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(headerStackView)
        return view
    }()
    
    init(process: Process) {
        titleLabel.text = process.titleValue
        super.init(frame: .zero)
        setupView()
        setupLabel()
        setupTableView()
        setupCosntraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCountLabel(_ count: String) {
        countLabel.text = count
    }
}

// MARK: - UI Configuration
extension ProcessStackView {
    private func setupView() {
        [headerView, tableView].forEach(addArrangedSubview(_:))
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = UIConstant.stackViewSpacing
        headerView.backgroundColor = .systemGray5
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabel() {
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .black
        countLabel.layer.masksToBounds = true
        countLabel.layer.cornerRadius = UIConstant.countLabelWidth * 0.5
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .systemGray5
        tableView.register(
            ProcessTableViewCell.self,
            forCellReuseIdentifier: ProcessTableViewCell.identifier
        )
    }
    
    private func setupCosntraint() {
        let headerSafeArea = headerView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: UIConstant.headerViewHeight),
            
            headerStackView.topAnchor.constraint(
                equalTo: headerSafeArea.topAnchor,
                constant: UIConstant.topBottomValue
            ),
            headerStackView.leadingAnchor.constraint(
                equalTo: headerSafeArea.leadingAnchor,
                constant: UIConstant.leadingValue
            ),
            headerStackView.bottomAnchor.constraint(
                equalTo: headerSafeArea.bottomAnchor,
                constant: -UIConstant.topBottomValue
            ),
            
            countLabel.widthAnchor.constraint(equalToConstant: UIConstant.countLabelWidth),
            countLabel.heightAnchor.constraint(equalTo: countLabel.widthAnchor)
        ])
    }
}
