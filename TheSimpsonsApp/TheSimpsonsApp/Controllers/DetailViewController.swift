//
//  DetailViewController.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy private var charImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy private var nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy private var descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    var charInfo: Character? {
        didSet {
            nameLabel.text = charInfo?.charName
            descriptionLabel.text = charInfo?.charDescription
            charImage.image = UIImage(data: (charInfo?.imageData)!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        setCharImage()
        setNameLabel()
        setDescriptionLabel()
        title = "Character"
    }
    
    func setCharImage() {
        charImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(charImage)

        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            charImage.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: margins.topAnchor, multiplier: 2.0),
            charImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            charImage.widthAnchor.constraint(equalToConstant: 200),
            charImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameLabel)
        
        let margins = charImage.layoutMargins
        let viewMargins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: charImage.bottomAnchor, constant: margins.bottom),
            nameLabel.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor)
        ])
    }

    func setDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(descriptionLabel)
        
        let margins = nameLabel.layoutMargins
        let viewMargins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: margins.bottom),
            descriptionLabel.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor)
        ])
    }

}

