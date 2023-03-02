//
//  ViewController.swift
//  ConcurrencyStudyImageDownload
//
//  Created by Hyorim Nam on 2023/03/02.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Property
    
    // TODO: json 읽기로 바꾸기
    let imageURLStrings = [
        "https://raw.githubusercontent.com/EuniceNam/ConcurrencyStudyImageDownload/main/ImagesToDownload/beach1.jpeg",
        "https://raw.githubusercontent.com/EuniceNam/ConcurrencyStudyImageDownload/main/ImagesToDownload/cablecar1.jpeg",
        "https://raw.githubusercontent.com/EuniceNam/ConcurrencyStudyImageDownload/main/ImagesToDownload/cat1.jpeg",
        "https://raw.githubusercontent.com/EuniceNam/ConcurrencyStudyImageDownload/main/ImagesToDownload/lighthouse1.jpeg",
        "https://raw.githubusercontent.com/EuniceNam/ConcurrencyStudyImageDownload/main/ImagesToDownload/sea1.jpeg"
    ]

    // MARK: - View

    let tableView: UITableView = {
        $0.rowHeight = 80
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
        tableView.separatorColor = .clear
    }
    
    private func setupButton() {
        let loadImagesAction = UIAction { _ in
            self.loadAllImages()
        }
        loadAllImagesButton.addAction(loadImagesAction, for: .touchUpInside)
    }

    private func loadAllImages() {
        let session = URLSession.shared
        for i in 0...self.imageURLStrings.count-1 {
            // set to default image
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TableViewCell else {
                print("err") // TODO: throw Error로 고치거나 하기
                return
            }
            cell.image = UIImage(systemName: "photo")

            guard let imageURL = URL(string: self.imageURLStrings[i]) else {
                print("err") // TODO: throw Error로 고치거나 하기
                return
            }
            Task {
                let (imageData, response) = try! await session.data(from: imageURL) // TODO: try! 해결
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return
                }
                // Give time to see default image
                try? await Task.sleep(for: .seconds(0.3))
                cell.image = UIImage(data: imageData)
            }
        }
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
        return imageURLStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellName) as! TableViewCell
        // TODO: guard let throw error로 변경
        cell.imageURLString = imageURLStrings[indexPath.row]
        return cell
    }
}
