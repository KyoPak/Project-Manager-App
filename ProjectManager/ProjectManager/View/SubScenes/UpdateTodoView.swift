//
//  UpdateTodoView.swift
//  ProjectManager
//
//  Created by Kyo on 2023/01/14.
//

import UIKit

final class UpdateTodoView: UIView {
    private enum UIConstant {
        static let topValue = 10.0
        static let leadingValue = 10.0
        static let trailingValue = -10.0
        static let bottomValue = -10.0
    }
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = .preferredFont(forTextStyle: .title2)
        textView.layer.borderWidth = 2
        return textView
    }()
    
    let datePicker = UIDatePicker()
    
    private lazy var textFieldView: UIView = {
        let view = UIView()
        view.addSubview(titleTextField)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private lazy var addStackView = UIStackView(
        views: [textFieldView, datePicker, descriptionTextView],
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 10
    )
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UIConfiguration
extension UpdateTodoView {
    private func setupView() {
        backgroundColor = .white
        addSubview(addStackView)
    }
    
    private func setupConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: textFieldView.topAnchor,
                constant: UIConstant.topValue
            ),
            titleTextField.leadingAnchor.constraint(
                equalTo: textFieldView.leadingAnchor,
                constant: UIConstant.leadingValue
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: textFieldView.trailingAnchor,
                constant: UIConstant.trailingValue
            ),
            titleTextField.bottomAnchor.constraint(
                equalTo: textFieldView.bottomAnchor,
                constant: UIConstant.bottomValue
            ),
            
            addStackView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: UIConstant.topValue
            ),
            addStackView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: UIConstant.leadingValue
            ),
            addStackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: UIConstant.trailingValue
            ),
            addStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: UIConstant.bottomValue
            )
        ])
    }
}