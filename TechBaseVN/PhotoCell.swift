//
//  PhotoCell.swift
//  TechBaseVN
//
//  Created by Huy Ong on 4/29/21.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    static let id = "photoCell"
    
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            
            /// Either using Kingfisher or CustomImage Cacher
            /// image.loadImage(urlString: photo.download_url)
            guard let url = URL(string: photo.download_url) else { return }
            let processor = DownsamplingImageProcessor(size: self.bounds.size)
            image.kf.setImage(with: url, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
            
            setupAttributedCaption()
        }
    }
    
    var layout: Layout? {
        didSet {
            if layout == .compact {
                setCompactConstraint()
            } else {
                setRegularConstraint()
            }
        }
    }
    
    var index: Int? {
        didSet {
            indexLabel.text = String(index ?? 0)
        }
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIImageView = {
        let image =  UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608381391, blue: 0.9606701732, alpha: 1)
        return image
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        addSubview(captionLabel)
        addSubview(indexLabel)
        setRegularConstraint()
    }
    
    func setRegularConstraint() {
        constraints.forEach { removeConstraint($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: centerXAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            captionLabel.topAnchor.constraint(equalTo: topAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            indexLabel.topAnchor.constraint(equalTo: image.topAnchor),
            indexLabel.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5)
        ])
        
    }
    
    func setCompactConstraint() {
        constraints.forEach { removeConstraint($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            captionLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            indexLabel.topAnchor.constraint(equalTo: image.topAnchor),
            indexLabel.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5)
        ])
    }
    
    private func setupAttributedCaption() {
        guard let photo = self.photo else { return }
        
        let attributedText = NSMutableAttributedString(string: photo.author, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
       
        let sizeText = "size: \(photo.width)x\(photo.height)"
        attributedText.append(NSAttributedString(string: "\n\(sizeText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        captionLabel.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

