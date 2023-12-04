//
//  Dota2HeroTableViewCell.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import UIKit

protocol Dota2HeroTableViewCellDelegate: AnyObject {
    func didTapOnImageHeroView(heroID: Int)
}

class Dota2HeroTableViewCell: UITableViewCell, MakeSpecialLabel {
    
    
    // MARK: - Properties
    
    var registrationHandler: (() -> Void)?
    
    private(set) var heroID: Int?
    
    weak var delegate: Dota2HeroTableViewCellDelegate?
    
    static let identifier = "Dota2HeroTableViewCell"
    
    private var screenSize: CGFloat? {
        return UIScreen.current?.bounds.width
    }
    
    // MARK: - UI Components
    
     var strenghtIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(
                x: СonstraintConstants.indicatorXOffset,
                y: СonstraintConstants.indicatorYOffset,
                width: SizeConstants.indicatorWidth,
                height: SizeConstants.indicatorHeight),
            circleColor: .red,
            labelColor: .red,
            labelTextSize: 13)
        return circle
    }()
    
     var agilityIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(
                x: СonstraintConstants.indicatorXOffset,
                y: СonstraintConstants.indicatorYOffset,
                width: SizeConstants.indicatorWidth,
                height: SizeConstants.indicatorHeight),
            circleColor: .green,
            labelColor: .red,
            labelTextSize: 13)
        return circle
    }()
    
     var intelligenceIndicator: CircleValueView = {
        let circle = CircleValueView(
            frame: CGRect(
                x: СonstraintConstants.indicatorXOffset,
                y: СonstraintConstants.indicatorYOffset,
                width: SizeConstants.indicatorWidth,
                height: SizeConstants.indicatorHeight),
            circleColor: .blue,
            labelColor: .red,
            labelTextSize: 13)
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
        label.lineBreakMode = .byWordWrapping
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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    
    lazy var likeButton: FaveButton = {
        let button = FaveButton(
            frame: CGRect(
                x: UIScreen.current!.bounds.width - 50,
                y: СonstraintConstants.likeButtonYOffset,
                width: SizeConstants.buttonWidth,
                height: SizeConstants.buttonHeight),
            faveIconNormal: UIImage(named: "unlike"))
        return button
    }()


    // MARK: - Initialization
    
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
        
        imageHeroView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        
        
        let action = UIAction { [weak self] _ in self?.didTapButton() }
        likeButton.addAction(action, for: .primaryActionTriggered)
        
        likeButton.delegate = self
        
        configureConstraints()
        setAccessibility()
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // When reuse we don't want to see image which has been before
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageHeroView.image = nil
    }
    
    // MARK: - Button Action
    
     private func didTapButton() {
        registrationHandler?()
    }
    
    
    // MARK: - Image View Tap Action
    
    @objc func didTapImageView() {
        if let heroID = heroID {
            delegate?.didTapOnImageHeroView(heroID: heroID)
        }
    }
    
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        
        let imageHeroViewConstraints = [
            imageHeroView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageHeroView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: СonstraintConstants.imageTopOffset),
            imageHeroView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: СonstraintConstants.imageBottomOffset),
            imageHeroView.widthAnchor.constraint(equalToConstant: SizeConstants.imageWidth)
        ]
      
        let dispalyHeroNameConstraints = [
            dispalyHeroName.leftAnchor.constraint(equalTo: imageHeroView.rightAnchor, constant: СonstraintConstants.dispalyHeroNameLeftOffset),
            dispalyHeroName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: СonstraintConstants.dispalyHeroNameTopOffset)
        ]
        
        let rolesLabelViewConstraints = [
            rolesLabel.leadingAnchor.constraint(equalTo: dispalyHeroName.leadingAnchor),
            rolesLabel.topAnchor.constraint(equalTo: dispalyHeroName.bottomAnchor, constant: СonstraintConstants.rolesLabelTopOffset),
            rolesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: СonstraintConstants.rolesLabelTrailingOffset),
            rolesLabel.bottomAnchor.constraint(lessThanOrEqualTo: baseStackView.topAnchor, constant: СonstraintConstants.rolesLabelBottomOffset)
            
        ]
        
        let stackConstraints = [
            baseStackView.leadingAnchor.constraint(equalTo: rolesLabel.leadingAnchor),
            baseStackView.topAnchor.constraint(equalTo: rolesLabel.bottomAnchor, constant: СonstraintConstants.stackTopOffset),
            baseStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: СonstraintConstants.stackBottomOffset),
        ]
       
        NSLayoutConstraint.activate(stackConstraints)
        NSLayoutConstraint.activate(rolesLabelViewConstraints)
        NSLayoutConstraint.activate(imageHeroViewConstraints)
        NSLayoutConstraint.activate(dispalyHeroNameConstraints)
        
    }
    
    
    // MARK: - Method
    
    func configure(model: Dota2HeroModel, with image: UIImage) {
        heroID = model.heroID
        imageHeroView.image = image
        rolesLabel.attributedText = createLabel(with: model.attackType, and: model.roles)
        dispalyHeroName.text = model.localizedName
        intelligenceIndicator.label.text = String("\(model.baseInt) + \(model.intGain)")
        agilityIndicator.label.text = String("\(model.baseAgi) + \(model.agiGain)")
        strenghtIndicator.label.text = String("\(model.baseStr) + \(model.strGain)")
    }
    
    private func setAccessibility() {
        let allLabels = [dispalyHeroName, rolesLabel, intelligenceIndicator.label, agilityIndicator.label, strenghtIndicator.label]
           
           allLabels.forEach { label in
               label.isAccessibilityElement = true
               label.accessibilityTraits.update(with: .updatesFrequently)
           }
    }
    
    // MARK: - Constants
        
    private enum СonstraintConstants {
        
        static let imageTopOffset: CGFloat = 5.0
        static let imageBottomOffset: CGFloat = -5.0
        static let dispalyHeroNameLeftOffset: CGFloat = 5.0
        static let dispalyHeroNameTopOffset: CGFloat = 5.0
        static let rolesLabelTrailingOffset: CGFloat = -5.0
        static let rolesLabelBottomOffset: CGFloat = -5.0
        static let rolesLabelTopOffset: CGFloat = 30.0
        static let stackTopOffset: CGFloat = 15.0
        static let stackBottomOffset: CGFloat = -20.0
        static let indicatorYOffset: CGFloat = 0
        static let indicatorXOffset: CGFloat = 0
        static let likeButtonYOffset: CGFloat = 0
        
    }
    
    private enum SizeConstants {
        static let imageWidth: CGFloat = 150.0
        static let buttonWidth: CGFloat = 38.0
        static let buttonHeight: CGFloat = 38.0
        static let indicatorWidth: CGFloat = 100.0
        static let indicatorHeight: CGFloat = 15.0
    }
}
