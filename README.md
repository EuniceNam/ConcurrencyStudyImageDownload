# # ConcurrencyStudyImageDownload

Temporary public for study

[원티드 프리온보딩](https://www.wanted.co.kr/events/pre_challenge_ios_2) [사전과제](https://yagomacademy.notion.site/iOS-2-3f670cc9788f4384b000bfe940447d59) 시도용

![Simulator Screen Recording - iPhone 14 Pro - 2023-03-02 at 23 29 48](https://user-images.githubusercontent.com/18394923/222457217-a52ef64c-2b45-4999-b607-74bba1f14526.gif)

Concurrency 공부 많이 필요합니다

Concurrency 관련 부분: 
<details>
<summary>
`TableViewCell.swift`의 73-97줄
</summary>
<div>

```TableViewCell.swift
private func attribute() {
    let loadAction = UIAction { _ in
        self.image = nil
        Task {
            await self.loadImage()
        }
    }
    loadButton.addAction(loadAction, for: .touchUpInside)
}

private func loadImage() async {
    let session = URLSession.shared
    guard let imageURL = URL(string: imageURLString) else {
        print("err") // TODO: throw Error로 고치거나 하기
        return
    }
    let (imageData, response) = try! await session.data(from: imageURL) // TODO: try! 해결
    guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
        return
    }
    // Give time to check default image
    try? await Task.sleep(for: .seconds(0.3))
    self.image = UIImage(data: imageData)
}
```
</div>
</details>
<details>
<summary>
`ViewController.swift`의 76-101줄
</summary>
<div>

```ViewController.swift
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
```
</div>
</details>
