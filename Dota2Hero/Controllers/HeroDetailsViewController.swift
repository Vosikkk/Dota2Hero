//
//  HeroDetailsViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 09.11.2023.
//

import UIKit
import QuartzCore

class HeroDetailsViewController: UIViewController {

    
    // MARK: - Properties
    
    private var hero: Dota2HeroModel!
      
    let heroesStorage: HeroDataManager
    
    let gradientLayer = CAGradientLayer()
    
    let factory: Factory
    
    
    // MARK: - UI Components
   
    private lazy var likedButton: FaveButton = {
        let button = FaveButton(
            frame: CGRect(
                x: UIScreen.current!.bounds.width - 50,
                y: .likedButtonYOffset,
                width: .buttonSize,
                height: .buttonSize),
            faveIconNormal: UIImage(named: "unlike"))
        return button
    }()
    
    private lazy var imageHeroView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: .shadowOffsetWidth, height: .shadowOffsetHeight)
        imageView.layer.shadowRadius = .shadowRadius
        return imageView
    }()
    
    private lazy var heroNameLabel: UILabel = {
        return factory.createMainLabel()
    }()
    
    private lazy var baseHealthLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.health,
            backgroundColor: AppColors.firstLinebackgroundColor)
    }()
    
    private lazy var baseHealthRegenLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.healthRegen,
            backgroundColor: AppColors.secondLinebackgroundColor)
    }()
    
    private lazy var baseManaLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.mana,
            backgroundColor: AppColors.firstLinebackgroundColor)
    }()
    
    private lazy var baseManaRegenLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.manaRegen,
            backgroundColor: AppColors.secondLinebackgroundColor)
    }()
    
    private lazy var baseAttack: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.baseAttack,
            backgroundColor: AppColors.firstLinebackgroundColor)
    }()
    
    private lazy var attackRangeLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.attackRange,
            backgroundColor: AppColors.secondLinebackgroundColor)
    }()
    
    private lazy var attackSpeedLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.attackSpeed,
            backgroundColor: AppColors.firstLinebackgroundColor)
    }()
    
    private lazy var moveSpeedLabel: UILabel = {
        return factory.createSupoortLabel(
            text: TextConstants.moveSpeed,
            backgroundColor: AppColors.secondLinebackgroundColor)
    }()
    
    
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [baseAttack, attackRangeLabel, attackSpeedLabel, moveSpeedLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .spacingForSupportStacks
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layer.borderWidth = .borderStackWidth
        stack.layer.borderColor = UIColor.white.cgColor
        stack.layer.cornerRadius = .cornerRadius
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [baseHealthLabel, baseHealthRegenLabel, baseManaLabel, baseManaRegenLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .spacingForSupportStacks
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layer.borderWidth = .borderStackWidth
        stack.layer.borderColor = UIColor.white.cgColor
        stack.layer.cornerRadius = .cornerRadius
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftStack, rightStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = .spacingForMainStacks
        return stack
    }()
    
    
    // MARK: - Initialization
    
    init(factory: Factory, heroesStorage: HeroDataManager) {
        self.heroesStorage = heroesStorage
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColorForDetail
        view.addSubview(imageHeroView)
        view.addSubview(mainStack)
        view.addSubview(heroNameLabel)
        view.addSubview(likedButton)
        configureGradientLayer()
        configureConstraints()
        likedButton.delegate = self
        let action = UIAction { [weak self] _ in
            self?.didTapLikeButton()
        }
        likedButton.setSelected(selected: true, animated: false)
        
        likedButton.addAction(action, for: .touchUpInside)
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }
    
    
    // MARK: - Helper Methods
    
    private func didTapLikeButton() {
        hero.isLiked = !hero.isLiked
        heroesStorage.completeHero(withID: hero.heroID)
        likedButton.isSelected = hero.isLiked
    }
    
    private func configureGradientLayer() {
        let gradientLayer = CAGradientLayer.gradientLayer(in: view.bounds)
        gradientLayer.zPosition = -1 
        view.layer.addSublayer(gradientLayer)

    }
    
    private func updateLabelWithPrefix(label: UILabel, prefix: String, value: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        
        let attributedString = NSMutableAttributedString(string: "\(prefix) \(value)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: prefix.count + 1, length: value.count))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        label.attributedText = attributedString
    }
    
    
    private func configureConstraints() {
        
        let imageHeroViewConstraints = [
            imageHeroView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .imageLeadingConstraint),
            imageHeroView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .imageTopConstraint),
            imageHeroView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .imageTrailingConstraint),
            imageHeroView.heightAnchor.constraint(equalToConstant: .imageHeightConstraint)
        ]
    
        
        let heroNameLabelConstraints = [
            heroNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            heroNameLabel.topAnchor.constraint(equalTo: imageHeroView.bottomAnchor, constant: .nameLabelTopConstraint)
        ]
        
        let mainStackConstraints = [
            mainStack.leadingAnchor.constraint(equalTo: imageHeroView.leadingAnchor),
            mainStack.topAnchor.constraint(lessThanOrEqualTo: heroNameLabel.bottomAnchor, constant: .mainStackTopConstraint),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .mainStackTrailingConstraint),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .mainStackBottomConstraint)
            
        ]
       
        NSLayoutConstraint.activate(heroNameLabelConstraints)
        NSLayoutConstraint.activate(mainStackConstraints)
        NSLayoutConstraint.activate(imageHeroViewConstraints)
        
    }
    
    func configureUI(with model: Dota2HeroModel, and image: UIImage ) {
           hero = model
           imageHeroView.image = image
           heroNameLabel.text = hero.localizedName
           
           let labelsToUpdate: [(UILabel, String, String)] = [
               (baseManaLabel, baseManaLabel.text!, String(hero.baseMana)),
               (baseManaRegenLabel, baseManaRegenLabel.text!, String(hero.baseManaRegen)),
               (baseHealthLabel, baseHealthLabel.text!, String(hero.baseHealth)),
               (baseHealthRegenLabel, baseHealthRegenLabel.text!, String(hero.baseHealthRegen)),
               (baseAttack,baseAttack.text!, "\(hero.baseAttackMin) - \(hero.baseAttackMax)"),
               (attackRangeLabel, attackRangeLabel.text!, String(hero.attackRange)),
               (moveSpeedLabel, moveSpeedLabel.text!, String(hero.moveSpeed)),
               (attackSpeedLabel, attackSpeedLabel.text!, String(hero.attackSpeed))
           ]
           for (label, prefix, value) in labelsToUpdate {
               updateLabelWithPrefix(label: label, prefix: prefix, value: value)
           }
       }
       
    
    
    // MARK: - Constants
    
     struct TextConstants {
        static let health = NSLocalizedString("HEALTH:", comment: "")
        static let healthRegen = NSLocalizedString("HEALTH REGEN:", comment: "")
        static let mana = NSLocalizedString("MANA:", comment: "")
        static let manaRegen = NSLocalizedString("MANA REGEN:", comment: "")
        static let baseAttack = NSLocalizedString("BASE ATTACK:", comment: "")
        static let attackRange = NSLocalizedString("ATTACK RANGE:", comment: "")
        static let attackSpeed = NSLocalizedString("ATTACK SPEED:", comment: "")
        static let moveSpeed = NSLocalizedString("MOVE SPEED:", comment: "")
    }
    
    enum AppColors {
        static let gradientStart = UIColor(red: 26/255, green: 43/255, blue: 62/255, alpha: 1.0).cgColor
        static let gradientEnd = UIColor(red: 20/255, green: 30/255, blue: 48/255, alpha: 1.0).cgColor
        static let firstLinebackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        static let secondLinebackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
    }
}

private extension CGFloat {
    static let imageLeadingConstraint: CGFloat = 2.0
    static let imageTopConstraint: CGFloat = 2.0
    static let imageTrailingConstraint: CGFloat = -2.0
    static let imageHeightConstraint: CGFloat = 400.0
    static let nameLabelTopConstraint: CGFloat = 20.0
    static let mainStackTopConstraint: CGFloat = 20.0
    static let mainStackTrailingConstraint: CGFloat = -2.0
    static let mainStackBottomConstraint: CGFloat = -2.0
    static let likedButtonYOffset: CGFloat = 100
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 10.0
    static let borderStackWidth: CGFloat = 1
    static let shadowOffsetHeight: CGFloat = 2.0
    static let shadowRadius: CGFloat = 4.0
    static let buttonSize: CGFloat = 38.0
    static let shadowOffsetWidth: CGFloat = 0
    static let spacingForSupportStacks: CGFloat = 10
    static let spacingForMainStacks: CGFloat = 3
}

