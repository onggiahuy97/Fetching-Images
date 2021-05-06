//
//  ViewController.swift
//  TechBaseVN
//
//  Created by Huy Ong on 4/29/21.
//

import UIKit

class HomeView: UICollectionViewController {
    
    var photos = [Photo]()
    var limit = 20
    var pages = 1
    var currentCount = 0
    
    var indexPaths: [IndexPath] {
        (0 ..< photos.count).map { IndexPath(row: $0, section: 0) }
    }
    
    var layout: Layout = Layout.getLayout() {
        didSet {
            UserDefaults.standard.setValue(layout.rawValue, forKey: Layout.key)
        }
    }
    
    @IBOutlet weak var segmentModelList: UISegmentedControl!
    @IBAction func segmentList(_ sender: Any) {
        updateSegmentController(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchPhotos()
        segmentModelList.selectedSegmentIndex = layout == .regular ? 0 : 1
    }
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setLayout()
    }
    
    private func setLayout() {
        let bounds = UIScreen.main.bounds
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let fractor: CGFloat = width > height ? 5 : 3
        collectionView.setCollectionViewLayout(layout.createLayout(bounds, fractor: fractor), animated: true)
    }
    
    private func updateSegmentController(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else { return }
        layout = segment.selectedSegmentIndex == 0 ? .regular : .compact
        collectionView.reloadItems(at: indexPaths)
        setLayout()
    }
    
    private func configureView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        setLayout()
    }
    
    private func fetchPhotos() {
        APIService.shared.fetchPhotos(pages: pages,limit: limit) { result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    if self.currentCount < photos.count {
                        self.photos.append(contentsOf: photos[self.currentCount...])
                        self.currentCount += 20
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                fatalError("Failed to fetch photos in VC \(error.localizedDescription)")
            }
        }
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        cell.photo = photos[indexPath.row]
        cell.layout = layout
        cell.index = indexPath.row + 1
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
        if endScrolling >= scrollView.contentSize.height {
            limit += 20
            if limit > 100 { pages += 1; limit = 20; currentCount = 0 }
            fetchPhotos()
        }
    }
}


