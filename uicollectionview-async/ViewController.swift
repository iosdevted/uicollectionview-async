//
//  ViewController.swift
//  uicollectionview-async
//
//  Created by Ted on 2021/02/06.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    
    private let reuseIdentifer = "PhotoCell"
    
    private let cellSpacing: CGFloat = 1
    private let columns: CGFloat = 3
    
    private var urls: [URL] = []

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Extract Photos.plist and save into urls.
        guard let url = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let contents = try? Data(contentsOf: url),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String]
        else { return print("Something went wrong") }
        
        urls = serialUrls.compactMap { URL(string: $0) }
            
        setupCollectionView()
        setupLayouts()
    }

    //MARK: - Helpers
    private func setupCollectionView() {
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        let width = (UIScreen.main.bounds.width - cellSpacing * 2) / columns
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! PhotoCell
        
        cell.url = urls[indexPath.item]
        return cell
    }
}
