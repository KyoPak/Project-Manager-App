//
//  ProjectManager - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private enum Constant {
        static let navigationTitle = "Project Manager"
        static let tableSpacing = 10.0
        static let bottomValue = -50.0
    }
    
    private let todoView = ProcessStackView(process: .todo)
    private let doingView = ProcessStackView(process: .doing)
    private let doneView = ProcessStackView(process: .done)
        
    private lazy var mainStackView = UIStackView(
        views: [todoView, doingView, doneView],
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Constant.tableSpacing
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupConstraint()
    }
    
    @objc private func addButtonTapped() {
        // 추후 구현
    }
}

// MARK: - UI Configuration
extension MainViewController {
    private func setupNavigationBar() {
        title = Constant.navigationTitle
        let appearence = UINavigationBarAppearance()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .systemGray6
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: Constant.bottomValue
            )
        ])
    }
}