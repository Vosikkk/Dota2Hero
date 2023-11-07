//
//  Dota2HeroTableViewCell.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import UIKit


class Dota2HeroTableViewCell: UITableViewCell, MakeSpecialLabel {
    
    static let identifier = "Dota2HeroTableViewCell"
    
    private var screenSize: CGFloat? {
       return UIScreen.current?.bounds.width
    }
    
   private var strenghtIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x: 0, y: 0, width: 90, height: 10),
            circleColor: .red, labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
    
    private var agilityIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x:0, y: 0, width: 90, height: 10),
            circleColor: .green,
            labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
    
    private var intelligenceIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(x:0, y: 0, width: 90, height: 10),
            circleColor: .blue,
            labelColor: .black,
            labelTextSize: 12)
        return circle
    }()
   
    private var baseStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           stackView.spacing = 25
           stackView.distribution = .fillProportionally
           return stackView
       }()
    
    
    
    private var rolesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.numberOfLines = 0
        return label
    }()
    
    private var dispalyHeroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dota 2"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var imageHeroView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "dota2_logo")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var likeButton: FaveButton = {
        let button = FaveButton(frame: CGRect(x: UIScreen.current!.bounds.width - 50, y: 0, width: 38, height: 38),
                                faveIconNormal: UIImage(named: "unlike"))
        return button
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
   
    
    var registrationHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dispalyHeroName)
        contentView.addSubview(imageHeroView)
        contentView.addSubview(rolesLabel)
        contentView.addSubview(baseStackView)
        contentView.addSubview(likeButton)
        baseStackView.addArrangedSubview(strenghtIndicator)
        baseStackView.addArrangedSubview(agilityIndicator)
        baseStackView.addArrangedSubview(intelligenceIndicator)
        
        let action = UIAction { [weak self] _ in
            self?.didTapButton()
        }
        likeButton.addAction(action, for: .primaryActionTriggered)
        
      
        likeButton.delegate = self
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func didTapButton() {
        registrationHandler?()
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
            rolesLabel.topAnchor.constraint(equalTo: dispalyHeroName.bottomAnchor, constant: 30),
            rolesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
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
    
    func configure(model: Dota2HeroModel, with image: UIImage) {
        imageHeroView.image = image
        rolesLabel.attributedText = createLabel(with: model.attackType, and: model.roles)
        dispalyHeroName.text = model.localizedName
        intelligenceIndicator.label.text = String("\(model.baseInt) + \(model.intGain)")
        agilityIndicator.label.text = String("\(model.baseAgi) + \(model.agiGain)")
        strenghtIndicator.label.text = String("\(model.baseStr) + \(model.strGain)")
    }
}
