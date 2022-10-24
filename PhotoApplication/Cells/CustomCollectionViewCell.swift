//
//  CustomCollectionViewCell.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
//

import UIKit


class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCell"
    
    private let checkmark: UIImageView = {
       let image = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.alpha = 0
        return image
    }()
    
    public let photoImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemFill
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override var isSelected: Bool {
        didSet{
            updateSelectedState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        setupImageView()
        setupCheckmarkView()
        updateSelectedState()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    private func setupImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupCheckmarkView() {
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
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
    }
}
