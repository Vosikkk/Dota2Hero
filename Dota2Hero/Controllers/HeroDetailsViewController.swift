//
//  HeroDetailsViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 09.11.2023.
//

import UIKit
import QuartzCore

class HeroDetailsViewController: UIViewController {
    
    enum AppColors {
        static let background = UIColor(red: 25/255, green: 32/255, blue: 35/255, alpha: 1.0)
        static let gradientStart = UIColor(red: 26/255, green: 43/255, blue: 62/255, alpha: 1.0).cgColor
        static let gradientEnd = UIColor(red: 20/255, green: 30/255, blue: 48/255, alpha: 1.0).cgColor
        static let firstLinebackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        static let secondLinebackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
    }
    
    private var hero: Dota2HeroModel!
      
    let heroesStorage: HeroDataManager
    
    let gradientLayer = CAGradientLayer()
    
    let factory: LabelFactory
    
    
    private lazy var likedButton: FaveButton = {
        let button = FaveButton(frame: CGRect(x: UIScreen.current!.bounds.width - 50, y: 100, width: 38, height: 38),
                                faveIconNormal: UIImage(named: "unlike"))
        return button
    }()
    
    private lazy var imageHeroView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4.0
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
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layer.borderWidth = 1.0
        stack.layer.borderColor = UIColor.white.cgColor
        stack.layer.cornerRadius = 10.0
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [baseHealthLabel, baseHealthRegenLabel, baseManaLabel, baseManaRegenLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layer.borderWidth = 1.0
        stack.layer.borderColor = UIColor.white.cgColor
        stack.layer.cornerRadius = 10.0
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftStack, rightStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 3
        return stack
    }()
    
    init(factory: LabelFactory, heroesStorage: HeroDataManager) {
        self.heroesStorage = heroesStorage
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
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
    }
    
    func didTapLikeButton() {
        hero.isLiked = !hero.isLiked
        heroesStorage.completeHero(withID: hero.heroID)
        likedButton.isSelected = hero.isLiked
    }
    
    private func configureGradientLayer() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            AppColors.gradientStart,
            AppColors.gradientEnd
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateLabelWithPrefix(label: UILabel, prefix: String, value: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        
        let attributedString = NSMutableAttributedString(string: "\(prefix) \(value)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: prefix.count + 1, length: value.count))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        label.attributedText = attributedString
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
    
    
    
    private func configureConstraints() {
        
        let imageHeroViewConstraints = [
            imageHeroView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            imageHeroView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            imageHeroView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            imageHeroView.heightAnchor.constraint(equalToConstant: 400)
        ]
    
        
        let heroNameLabelConstraints = [
            heroNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            heroNameLabel.topAnchor.constraint(equalTo: imageHeroView.bottomAnchor, constant: 20)
        ]
        
        let mainStackConstraints = [
            mainStack.leadingAnchor.constraint(equalTo: imageHeroView.leadingAnchor),
            mainStack.topAnchor.constraint(lessThanOrEqualTo: heroNameLabel.bottomAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2)
            
        ]
       
        NSLayoutConstraint.activate(heroNameLabelConstraints)
        NSLayoutConstraint.activate(mainStackConstraints)
        NSLayoutConstraint.activate(imageHeroViewConstraints)
        
    }
    
    
    private struct TextConstants {
        static let health = NSLocalizedString("HEALTH:", comment: "")
        static let healthRegen = NSLocalizedString("HEALTH REGEN:", comment: "")
        static let mana = NSLocalizedString("MANA:", comment: "")
        static let manaRegen = NSLocalizedString("MANA REGEN:", comment: "")
        static let baseAttack = NSLocalizedString("BASE ATTACK:", comment: "")
        static let attackRange = NSLocalizedString("ATTACK RANGE:", comment: "")
        static let attackSpeed = NSLocalizedString("ATTACK SPEED:", comment: "")
        static let moveSpeed = NSLocalizedString("MOVE SPEED:", comment: "")
    }
}
