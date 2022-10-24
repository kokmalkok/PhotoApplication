//
//  FavouriteCollectionViewController.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
// Добавить крестик для скрывания представлнеия
// Добавить функцию удаления
// Разобраться с навигацией
// понять почему после сохранения не обновляется вью у другого представления

import UIKit
import CoreData

class FavoritesViewController: UICollectionViewController {
   
    private let identifier = FavoriteCollectionViewCell.identifier
    
    var favoriteLinks: [String] = [] //array for collecting photo in url format
    var favoriteImages: [UIImage] = [] // array for collecting photo in image format
    private let coreData = ImageLinkStack.instance //inherit coredata stack
    private var cellSetup = [FavoriteCollectionViewCell]() // inherit cell for refreshing cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup()
        collectionViewSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
   
    //MARK: - Objc methods
    //func for refresh page
    @objc private func didPullToRefresh(){
        cellSetup.removeAll()
        if collectionView.refreshControl?.isRefreshing == true {
            print("Refreshing")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            self.coreData.loadImage()
        }
    }
    
    //MARK: - Settings
    private func navigationSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.title = "Saved Photos"
    }
    
    private func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: 125,height: 130)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        coreData.loadImage()
    }
    //MARK: - Collection view delegates
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FavoriteCollectionViewCell
        let imageData = coreData.vaultData[indexPath.row].image
        if let image = UIImage(data: imageData!) {
            cell.configureImage(with: image)
            cell.backgroundColor = randomColor()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let link = coreData.vaultData[indexPath.row].url else {
            return
        }
        let item = coreData.vaultData[indexPath.row]
        let popUpAlert = UIAlertController(title: "What do you want", message: nil , preferredStyle: .actionSheet)
        popUpAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        popUpAlert.addAction(UIAlertAction(title: "Open", style: .default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let secVC = storyboard.instantiateViewController(withIdentifier: "ShowFavouriteImageViewController") as? ShowFavouriteImageViewController else {
                return
            }
            secVC.resultFromLastView = link
            self.present(secVC, animated: true)
        }))
        popUpAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.coreData.deleteImage(image: item)
            self.collectionView.reloadData()
        }))
        present(popUpAlert, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coreData.vaultData.count
    }

    func random () -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor () -> UIColor {
        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }
}
