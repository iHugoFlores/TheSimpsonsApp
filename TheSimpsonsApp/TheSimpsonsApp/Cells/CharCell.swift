//
//  CharCell.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/27/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import UIKit

class CharCell: UITableViewCell {
    
    var charInfo: RelatedTopic? {
        didSet {
            nameLabel.text = charInfo?.charName
            if (charInfo?.Icon.URL.isEmpty)! {
                charImage.backgroundColor = .clear
                charImage.image = UIImage(imageLiteralResourceName: "user")
            } else {
                charImage.backgroundColor = .blue
                charImage.image = nil
            }
        }
    }
    
    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let charImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUICell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    */
    
    override func awakeFromNib() {
        setUICell()
    }
    
    func setUICell() {
        setCharImage()
        setNameLabel()
    }
    
    func setCharImage() {
        charImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(charImage)

        let margins = self.layoutMarginsGuide
        NSLayoutConstraint.activate([
            charImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            charImage.topAnchor.constraint(equalTo: margins.topAnchor),
            charImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            charImage.widthAnchor.constraint(equalToConstant: 100),
            charImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(nameLabel)
        
        let margins = charImage.layoutMargins
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: charImage.trailingAnchor, constant: margins.right),
            nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
}
