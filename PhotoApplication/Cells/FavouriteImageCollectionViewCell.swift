//
//  FavouriteImageCollectionViewCell.swift
//  PhotoApplication
//
//  Created by Константин Малков on 21.10.2022.
//

import UIKit

protocol PushUpCellDelegate {
    func dismissFromCell()
}

class FavouriteImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavouriteImageCollectionViewCell"
    var delegate: PushUpCellDelegate?
        
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
    
    public let closeButton: UIButton = {
       let button = UIButton()
        button.sizeThatFits(CGSize(width: 150, height: 150))
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        contentView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        setupImageView()
        setupSafariCheckmarkView()
        setupCloseButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    @objc private func didTapDismiss(){
        self.delegate?.dismissFromCell()
    }
    
    private func setupCloseButton(){
        addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor,constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor,constant: -10).isActive = true
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
