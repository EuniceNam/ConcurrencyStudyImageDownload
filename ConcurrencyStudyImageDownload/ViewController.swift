//
//  ViewController.swift
//  ConcurrencyStudyImageDownload
//
//  Created by Hyorim Nam on 2023/03/02.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Property
    
    // MARK: - View

    let tableView: UITableView = {
        $0.rowHeight = 80
        $0.separatorColor = .clear
        $0.separatorInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        $0.allowsSelection = false
        return $0
    }(UITableView())

    let loadAllImagesButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .medium
        configuration.title = "Load All Images"
        $0.configuration = configuration
        return $0
    }(UIButton())

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLayout()
        setupButton()
    }

    // MARK: - Method

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellName)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
    
    private func setupButton() {
        let loadImagesAction = UIAction { _ in
            self.loadAllImages()
        }
        loadAllImagesButton.addAction(loadImagesAction, for: .touchUpInside)
    }

    private func loadAllImages() {
        print("Load all images clicked")
    }
}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {
    // Custom footer view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int = 0) -> UIView? {
        let footerView: UIView = {
            $0.backgroundColor = .systemBackground
            $0.addSubview(loadAllImagesButton)
            return $0
        }(UIView())
        // layout
        loadAllImagesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadAllImagesButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            loadAllImagesButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8),
            loadAllImagesButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            loadAllImagesButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16)
        ])
        return footerView
    }
}

// MARK: - Table View Datasource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellName) as! TableViewCell
        return cell
    }
}
