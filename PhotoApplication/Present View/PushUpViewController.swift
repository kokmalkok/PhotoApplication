//
//  PushUpViewController.swift
//  PhotoApplication
//
//  Created by Константин Малков on 27.09.2022.
//

import UIKit
import SafariServices

class PushUpViewController: UICollectionViewController {

    private let identifier = PushUpCollectionViewCell.identifier
    
    var resultFromLastView = String() //url from last view
    var selectedImage = UIImage() //uploaded image from last view
    private let data = ImageLinkStack() //inherit core data stack
    
    
    //size layouts
    private let itemRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    //nav button to save in core data image
    lazy var addToFavouriteButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "heart"),
                           style: .plain,
                           target: self,
                            action: #selector(didTapFavourite))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        collectionViewSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK: - Objc methods
    @objc private func didTapFavourite(){
        if let imagePng = selectedImage.pngData() {
            data.saveImage(image: imagePng, link: resultFromLastView)
        }
    }
    //MARK: - setups
    private func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(didTapFavourite))
    }

    private func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 400, height: 700)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(PushUpCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    //MARK: - Collection view delegates
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PushUpCollectionViewCell
        cell.configureImage(with: selectedImage)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let url = URL(string: resultFromLastView ) else {
            return
        }
        let alert = UIAlertController(title: "Actions", message: "What exactly do you want to do with photo?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default,handler: {  _ in
            guard let image = self.selectedImage.pngData() else {
                return
            }
            self.data.saveImage(image: image, link: self.resultFromLastView)
            
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
            var array: [UIImage] = []
            array.append(self.selectedImage)
            let share = UIActivityViewController(activityItems: array, applicationActivities: nil)
            share.popoverPresentationController?.permittedArrowDirections = .right
            self.present(share, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Open photo in browser", style: .default, handler: { _ in
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }))
        present(alert, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension PushUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
