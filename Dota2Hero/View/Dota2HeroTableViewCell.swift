//
//  Dota2HeroTableViewCell.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import UIKit

protocol Dota2HeroTableViewCellProtocol {
    var dispalyHeroName: UILabel { get set }
    var imageHeroView: UIImageView { get set }
    var rolesLabel: UILabel { get set }
}


class Dota2HeroTableViewCell: UITableViewCell, Dota2HeroTableViewCellProtocol {
    
    static let identifier = "Dota2HeroTableViewCell"
    
    var strenghtIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x:0, y: 0, width: 90, height: 10),
            circleColor: .red, labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
    
    var agilityIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x:0, y: 0, width: 90, height: 10),
            circleColor: .green,
            labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
    
    var intelligenceIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x:0, y: 0, width: 90, height: 10),
            circleColor: .blue,
            labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
   
    var baseStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           stackView.spacing = 25
           stackView.distribution = .fillProportionally
           return stackView
       }()
    
    
    
    var rolesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.numberOfLines = 0
        return label
    }()
    
    var dispalyHeroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dota 2"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    var imageHeroView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "dota2_logo")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dispalyHeroName)
        contentView.addSubview(imageHeroView)
        contentView.addSubview(rolesLabel)
        contentView.addSubview(baseStackView)
        baseStackView.addArrangedSubview(strenghtIndicator)
        baseStackView.addArrangedSubview(agilityIndicator)
        baseStackView.addArrangedSubview(intelligenceIndicator)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureConstraints() {
        
        let imageHeroViewConstraints = [
            imageHeroView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageHeroView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageHeroView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageHeroView.widthAnchor.constraint(equalToConstant: 150)
        ]
      
        let dispalyHeroNameConstraints = [
            dispalyHeroName.leftAnchor.constraint(equalTo: imageHeroView.rightAnchor, constant: 5),
            dispalyHeroName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ]
        
        let rolesLabelViewConstraints = [
            rolesLabel.leadingAnchor.constraint(equalTo: dispalyHeroName.leadingAnchor),
            rolesLabel.topAnchor.constraint(equalTo: dispalyHeroName.bottomAnchor, constant: 5),
            rolesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -2)
        ]
        let stackConstraints = [
            baseStackView.leadingAnchor.constraint(equalTo: rolesLabel.leadingAnchor),
            baseStackView.topAnchor.constraint(equalTo: rolesLabel.bottomAnchor, constant: 15),
            baseStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
           
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        NSLayoutConstraint.activate(rolesLabelViewConstraints)
        NSLayoutConstraint.activate(imageHeroViewConstraints)
        NSLayoutConstraint.activate(dispalyHeroNameConstraints)
        
    }
    
    func configure(model: Dota2HeroModel, with image: UIImage, textForRoles: NSAttributedString) {
        rolesLabel.attributedText = textForRoles
        imageHeroView.image = image
        dispalyHeroName.text = model.localizedName
        intelligenceIndicator.label.text = String("\(model.baseInt) + \(model.intGain)")
        agilityIndicator.label.text = String("\(model.baseAgi) + \(model.agiGain)")
        strenghtIndicator.label.text = String("\(model.baseStr) + \(model.strGain)")
    }
}
