//
//  FavouriteCollectionViewCell.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    static let identifier = "cell"
    
    let favouriteImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(favouriteImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        favouriteImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteImageView.image = nil
    }
    
    func configure(with arrayString: [String]) {
        for link in arrayString {
            guard let url = URL(string: link) else {
                return
            }
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.favouriteImageView.image = image
                }
            }
            .resume()
            print("Image sucessfully uploaded")

        }
    }
    
    func configureImage(with image: UIImage) {
        self.favouriteImageView.image = image
    }
}
