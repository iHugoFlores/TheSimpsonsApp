//
//  DetailViewController.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = 20

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var charImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy private var nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy private var descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
        configureScrollView()
        setCharImage()
        setNameLabel()
        setDescriptionLabel()
        title = "Character"
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollViewContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollViewContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollViewContainer.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: 16.0),
            scrollViewContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0),

            scrollViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setCharImage() {
        scrollViewContainer.addArrangedSubview(charImage)

        NSLayoutConstraint.activate([
            charImage.widthAnchor.constraint(equalToConstant: 250),
            charImage.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setNameLabel() {
        scrollViewContainer.addArrangedSubview(nameLabel)
        
        let margins = charImage.layoutMargins
        let viewMargins = scrollView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: charImage.bottomAnchor, constant: margins.bottom * 6),
            nameLabel.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor)
        ])
    }

    func setDescriptionLabel() {
        scrollViewContainer.addArrangedSubview(descriptionLabel)
        
        let margins = nameLabel.layoutMargins
        let viewMargins = scrollView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: margins.bottom),
            descriptionLabel.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor, constant: scrollView.layoutMargins.left * 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor, constant: scrollView.layoutMargins.right * -3)
        ])
    }

}

