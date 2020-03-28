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
                setPlaceholderImage()
            } else {
                downloadImage()
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
    
    var vSpinner : UIView?
    
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
    
    func setPlaceholderImage() {
        charImage.backgroundColor = .clear
        charImage.image = UIImage(imageLiteralResourceName: "user")
    }
    
    func downloadImage() {
        setImageSpinner()
        SimpsonResponse.downloadImage(fromURL: URL(string: (charInfo?.Icon.URL)!)!, onDone: self.setDownloadedImage)
    }
    
    func setDownloadedImage(image img: UIImage?) {
        removeSpinner()
        if (img?.size.height)! <= 1.0 {
            setPlaceholderImage()
            return
        }
        charImage.image = img
    }
    
    func setImageSpinner() {
        charImage.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        charImage.image = nil
        showSpinner(onView: charImage)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
        
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ai.centerXAnchor.constraint(equalTo: onView.centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: onView.centerYAnchor),
        ])
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        self.vSpinner?.removeFromSuperview()
        self.vSpinner = nil
    }
    
}
