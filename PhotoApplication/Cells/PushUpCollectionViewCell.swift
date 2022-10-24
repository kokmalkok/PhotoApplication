//
//  PushUpCollectionViewCell.swift
//  PhotoApplication
//
//  Created by Константин Малков on 04.10.2022.
//

import UIKit

class PushUpCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PushCustomCell"
        
    public let photoImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let safariCheckmark: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "safari"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.alpha = 1
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        setupImageView()
        setupSafariCheckmarkView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func setupImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupSafariCheckmarkView(){
        addSubview(safariCheckmark)
        safariCheckmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        safariCheckmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONFIGURE CELL
    func configure(with string: String) {
        guard let url = URL(string: string) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.photoImageView.image = image
            }
        }
        .resume()
        print("Ссылка перенеслась успешно!!!!")
    }
    
    func configureImage(with image: UIImage) {
        self.photoImageView.image = image
        print("Изображение перенеслось успешно")
        
    }
}
