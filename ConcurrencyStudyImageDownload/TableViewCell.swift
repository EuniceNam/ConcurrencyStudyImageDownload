//
//  TableViewCell.swift
//  ConcurrencyStudyImageDownload
//
//  Created by Hyorim Nam on 2023/03/02.
//

import UIKit

class TableViewCell: UITableViewCell {

    // MARK: - Property

    // MARK: - View

    let stackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 4
        return $0
    }(UIStackView())

    let pictureView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView(image: UIImage(systemName: "photo")))
    
    let progressBar: UIProgressView = {
        $0.progress = 0.5 // TODO: 프로그레스 바가 진행도 반영하도록 수정하기
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(UIProgressView())
    
    let loadButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .medium
        configuration.title = "Load"
        $0.configuration = configuration
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return $0
    }(UIButton())
    
    let leadingSpacingView = UIView(frame: CGRect())
    let trailingSpacingView = UIView(frame: CGRect())

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func attribute() {
        // TODO: - addAction
//        button.addAction(<#T##action: UIAction##UIAction#>, for: <#T##UIControl.Event#>)
    }
    
    private func setupLayout() {
        // add subviews
        addSubview(stackView)
        contentView.addSubview(stackView)
        [leadingSpacingView, pictureView, progressBar, loadButton, trailingSpacingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        // layout for stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            // leading and trailing anchor supports RTL(Right-to-Left writing) languages
        ])
        // layout for subviews of stackView
        NSLayoutConstraint.activate([
            pictureView.topAnchor.constraint(equalTo: stackView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            pictureView.widthAnchor.constraint(equalTo: pictureView.heightAnchor, multiplier: 1.5),
            progressBar.widthAnchor.constraint(greaterThanOrEqualTo: stackView.widthAnchor, multiplier: 0.3)
        ])
    }
}

// MARK: - Uitility

extension UITableViewCell {
    static var cellName: String {
        return String(describing: self)
    }
}
