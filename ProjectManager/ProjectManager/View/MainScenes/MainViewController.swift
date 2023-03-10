//
//  ProjectManager - MainViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol DataManageable: AnyObject {
    func shareData(_ data: Plan, index: Int?)
}

protocol EventManageable: AnyObject {
    func shareUpdateEvent(process: Process, index: Int?)
    func shareDeleteEvent(process: Process, index: Int)
}

protocol GestureManageable: AnyObject {
    func shareLongPress(process: Process, view: UIView, index: Int)
}

final class MainViewController: UIViewController {
    private enum UIConstant {
        static let navigationTitle = "Project Manager"
        static let tableSpacing = 10.0
        static let bottomValue = -50.0
    }
    
    private let viewModel = MainViewModel(crudManager: FireStoreManager())
    
    private let todoView = ProcessView(viewModel: ProcessViewModel(process: .todo))
    private let doingView = ProcessView(viewModel: ProcessViewModel(process: .doing))
    private let doneView = ProcessView(viewModel: ProcessViewModel(process: .done))

    private lazy var mainStackView = UIStackView(
        views: [todoView, doingView, doneView],
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: UIConstant.tableSpacing
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavigationBar()
        setupView()
        setupConstraint()
    }
    
    private func setupBinding() {
        viewModel.bindTodo { [weak self] data in
            self?.todoView.updateView(data)
        }
        
        viewModel.bindDoing { [weak self] data in
            self?.doingView.updateView(data)
        }
        
        viewModel.bindDone { [weak self] data in
            self?.doneView.updateView(data)
        }
        
        viewModel.bindProcessList { [weak self] processList in
            self?.showPopOver(processList: processList)
        }
        
        viewModel.loadData()
    }
}

// MARK: - present DetailView, PopOver
extension MainViewController {
    private func presentDetailView(process: Process, index: Int?) {
        let selectedData = viewModel.fetchSeletedData(process: process, index: index)
        let detailViewModel = DetailViewModel(data: selectedData, index: index)
        
        let detailViewController = DetailViewController(
            viewModel: detailViewModel
        )
        
        detailViewController.delegate = self
        detailViewController.modalPresentationStyle = .formSheet
        
        let detailNavigationController = UINavigationController(
            rootViewController: detailViewController
        )
        present(detailNavigationController, animated: true)
    }
    
    private func showPopOver(processList: [Process]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        processList.forEach { afterProcess in
            let action = UIAlertAction(
                title: "Move To " + "\(afterProcess)",
                style: .default
            ) { [weak self] _ in
                self?.viewModel.changeProcess(afterProcess)
            }
            
            alert.addAction(action)
        }
        
        guard let popover = alert.popoverPresentationController else { return }
        popover.permittedArrowDirections = .up
        popover.sourceView = viewModel.movePlan?.view
        
        present(alert, animated: true)
    }
}

// MARK: - Action
extension MainViewController {
    @objc private func addButtonTapped() {
        shareUpdateEvent(process: .todo, index: nil)
    }
    
    @objc private func historyButtonTapped() {
        // TODO: - Action Implementation
    }
}

// MARK: - DataManageable, EventManageable Delegate Protocol
extension MainViewController: DataManageable, EventManageable {
    func shareUpdateEvent(process: Process, index: Int?) {
        presentDetailView(process: process, index: index)
    }
    
    func shareDeleteEvent(process: Process, index: Int) {
        viewModel.deleteData(process: process, index: index)
    }
    
    func shareData(_ data: Plan, index: Int?) {
        viewModel.updateData(data: data, index: index)
    }
}

// MARK: - GestureManageable Protocol
extension MainViewController: GestureManageable {
    func shareLongPress(process: Process, view: UIView, index: Int) {
        viewModel.configureMovePlan(MovePlan(process: process, view: view, index: index))
    }
}

// MARK: - UI Configuration
extension MainViewController {
    private func setupNavigationBar() {
        title = UIConstant.navigationTitle
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let historyBarButton = UIBarButtonItem(
            title: "History",
            style: .plain,
            target: self,
            action: #selector(historyButtonTapped)
        )
        
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = historyBarButton
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
        view.addSubview(mainStackView)
        [todoView, doingView, doneView].forEach {
            $0.selectDataDelegate = self
            $0.gestureDelegate = self
        }
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: UIConstant.bottomValue
            )
        ])
    }
}
