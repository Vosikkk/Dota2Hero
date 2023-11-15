import UIKit

class CircleValueView: UIView {
    
    let circleView = UIView()
    let label = UILabel()

    init(frame: CGRect, circleColor: UIColor, labelColor: UIColor, labelTextSize: CGFloat) {
        super.init(frame: frame)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.frame = CGRect(x: 0, y: 0, width: min(frame.size.width, frame.size.height), height: min(frame.size.width, frame.size.height))
        circleView.layer.cornerRadius = circleView.bounds.size.width / 2
        circleView.backgroundColor = circleColor
        addSubview(circleView)
        
        
        label.text = "default"
        label.textColor = labelColor
        label.font = UIFont.systemFont(ofSize: labelTextSize)
        label.sizeToFit()
        let labelX = circleView.frame.maxX + 10
        label.frame = CGRect(x: labelX, y: (frame.size.height - label.frame.size.height) / 2, width: frame.size.width - labelX, height: label.frame.size.height)
        
        addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

