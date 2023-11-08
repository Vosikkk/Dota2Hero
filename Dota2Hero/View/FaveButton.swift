//
//  FaveButton.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 07.11.2023.
//


import UIKit


typealias DotColors = (first: UIColor, second: UIColor)


protocol FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool)
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?
}
extension FaveButtonDelegate{
   func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? { return nil }
}

class FaveButton: UIButton {
    
    private struct Constants {
        static let duration = 1.0
        static let expandDuration = 0.1298
        static let collapseDuration = 0.1089
        static let faveIconShowDelay = Constants.expandDuration + Constants.collapseDuration / 2.0
        static let dotRadiusFactors = (first: 0.0633, second: 0.04)
    }
    
    var normalColor: UIColor = UIColor(red: 137/255, green: 156/255, blue: 167/255, alpha: 1)
    var selectedColor: UIColor = UIColor(red: 226/255, green: 38/255,  blue: 77/255,  alpha: 1)
    var dotFirstColor: UIColor = UIColor(red: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    var dotSecondColor: UIColor = UIColor(red: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    var circleFromColor: UIColor = UIColor(red: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    var circleToColor: UIColor = UIColor(red: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    
    private(set) var sparkGroupCount: Int = 7
    
    weak var delegate: AnyObject?
    private var faveIconImage: UIImage?
    private var faveIcon: FaveIcon!
    private var animationsEnabled = true
    
   
    override var isSelected: Bool {
        didSet {
            guard self.animationsEnabled else { return }
            animateSelect(self.isSelected, duration: Constants.duration)
        }
    }
    
    convenience init(frame: CGRect, faveIconNormal: UIImage?) {
        self.init(frame: frame)
        
        guard let icon = faveIconNormal else {
            fatalError("missing image for normal state")
        }
        faveIconImage = icon
        applyInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        applyInit()
    }
    
    private func applyInit(){
            
            if nil == faveIconImage{
                faveIconImage = image(for: UIControl.State())
            }
            
            guard let faveIconImage = faveIconImage else {
                fatalError("please provide an image for normal state.")
            }
            
            
            setImage(UIImage(), for: UIControl.State())
            setTitle(nil, for: UIControl.State())
           
            
            faveIcon  = createFaveIcon(faveIconImage)
            
            addActions()
        }
        
    
    private func createFaveIcon(_ faveIconImage: UIImage) -> FaveIcon {
        return FaveIcon.createFaveIcon(self, icon: faveIconImage, color: normalColor)
    }
    
    
    private func createSparks(_ radius: CGFloat) -> [Spark] {
        var sparks = [Spark]()
        let step = 360.0 / Double(sparkGroupCount)
        let base = Double(bounds.size.width)
        let dotRadius = (base * Constants.dotRadiusFactors.first, base * Constants.dotRadiusFactors.second)
        let offset = 10.0
        
        for index in 0..<sparkGroupCount {
            let theta = step * Double(index) + offset
            let colors = dotColors(at: index)
            
            let spark = Spark.createSpark(self, radius: radius, firstColor: colors.first,secondColor: colors.second, angle: theta,
                                           dotRadius: dotRadius)
            sparks.append(spark)
        }
        return sparks
    }
    
    
    private func animateSelect(_ isSelected: Bool, duration: Double) {
        
        let color = isSelected ? selectedColor : normalColor
        
        faveIcon.animate(isSelected, fillColor: color, duration: duration, delay: duration > 0.0 ? Constants.faveIconShowDelay : 0.0)
        
        guard duration > 0.0 else { return }
        
        if isSelected {
            let radius = bounds.size.scaleBy(1.3).width / 2 // ring radius
            let igniteFromRadius = radius * 0.8
            let igniteToRadius = radius * 1.1
            
            let ring = Ring.createRing(self, radius: 0.01, lineWidth: 3, fillColor: self.circleFromColor)
            let sparks = createSparks(igniteFromRadius)
            
            ring.animateToRadius(radius, toColor: circleToColor, duration: Constants.expandDuration, delay: 0)
            ring.animateColapse(radius, duration: Constants.collapseDuration, delay: Constants.expandDuration)
            
            sparks.forEach {
                $0.animateIgniteShow(igniteToRadius, duration: 0.4, delay: Constants.collapseDuration / 3.0)
                $0.animateIgniteHide(0.7, delay: 0.2)
            }
            
        }
    }
    
    
    private func dotColors(at index: Int) -> DotColors{
        if case let delegate as FaveButtonDelegate = delegate , nil != delegate.faveButtonDotColors(self) {
            let colors = delegate.faveButtonDotColors(self)!
            let colorIndex = 0..<colors.count ~= index ? index : index % colors.count
            
            return colors[colorIndex]
        }
        return DotColors(self.dotFirstColor, self.dotSecondColor)
    }
    
    
    
    // MARK: Action
    
    func addActions() {
        let action = UIAction { [weak self] _ in
            self?.toggle(self!)
        }
        self.addAction(action, for: .primaryActionTriggered)
    }
    
    func toggle(_ sender: FaveButton) {
        
        sender.isSelected = !sender.isSelected
        guard case let delegate as FaveButtonDelegate = self.delegate else { return }
        
        let delay = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * Constants.duration)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            delegate.faveButton(sender, didSelected: sender.isSelected)
        }
    }
}
