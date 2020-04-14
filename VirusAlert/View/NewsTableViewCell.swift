//
//  NewsTableViewCell.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/12/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Stevia
import Nuke

final class NewsTableViewCell: UITableViewCell {
    
    let title = UILabel()
    let articleDescription = UILabel()
    let dateLabel = UILabel()
    let coverImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subviews {
            title
            articleDescription
            coverImage
            dateLabel
        }
        
        backgroundColor = .clear
        selectionStyle = .none
        
        coverImage.clipsToBounds = true
        coverImage.contentMode = .scaleAspectFill
        coverImage.layer.masksToBounds = true
        coverImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        coverImage.layer.cornerRadius = 12
        
        title.font = R.font.latoRegular(size: 16)
        title.textColor = R.color.slateBlack()
        articleDescription.font = R.font.latoRegular(size: 12)
        articleDescription.textColor = UIColor(hexString: "#3c3c43", transparency: 0.6)
        articleDescription.numberOfLines = 3
        dateLabel.font = R.font.latoItalic(size: 10)
        dateLabel.textColor = UIColor(hexString: "#d52941")
        
        layout {
            0
            |-0-coverImage.height(130).width(343)-0-|
            8
            |-8-title.height(19)-8-|
            8
            |-8-articleDescription.height(48)-8-|
            8
            dateLabel.height(12)-8-|
            8
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: .init(top: 12, left: 16, bottom: 12, right: 16))
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.dropShadow()
    }
}

extension NewsTableViewCell {
    
    func render(with n: NewsArticles) {
        title.text = n.title
        articleDescription.text = n.description
        dateLabel.text = n.date
        if let urlToImage = URL(string: n.imageUrl) {
            Nuke.loadImage(with: urlToImage, into: coverImage)            
        }
    }
}
