
import UIKit

public class RotationView : UIView {
    public var functionList : [Int] //0: rotate, 1: scale, 2: rotate and scale, 3: 45 degrees rotate
    
    public var lblCorners = [UILabel]() //left top, left bottom, right bottom, right top
    public var minCornerSize = 20 as CGFloat
    
    public var isShownCorner = true {
        didSet {
            lblCorners.forEach { a in
                a.isHidden = !isShownCorner
            }
        }
    }

    public convenience init() {
        //left top:     0=rotate
        //left bottom:  1=scale
        //right bottom: 2=rotate and scale
        //right top:    3=45 degrees rotate
        self.init(functionList: [0,1,2,3])
    }
    
    public init(functionList: [Int]) {
        self.functionList = functionList
        super.init(frame: .zero)

        for i in 0..<4 {
            let lbl = UILabel(frame: .zero)
            lblCorners.append(lbl)
            lbl.backgroundColor = .orange
            addSubview(lbl)
            
            lbl.text = "\(i)"

            //constarints
            let ltA = leftAnchor
            let rtA = rightAnchor
            let tpA = topAnchor
            let btA = bottomAnchor
            let anchors = [(ltA, tpA), (ltA, btA), (rtA, btA), (rtA, tpA)]
            let A0 = anchors[i].0
            let A1 = anchors[i].1
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.centerXAnchor.constraint(equalTo: A0).isActive = true
            lbl.centerYAnchor.constraint(equalTo: A1).isActive = true
            lbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
            lbl.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            //recognizer
            if functionList[i] == 3 {
                let selector2 = #selector(RotationView.tappedCorner(sender:))
                let recognizer2 = UITapGestureRecognizer(target: self, action: selector2)
                lbl.addGestureRecognizer(recognizer2)
            } else {
                let selector2 = #selector(RotationView.pannedCorner(sender:))
                let recognizer2 = UIPanGestureRecognizer(target: self, action: selector2)
                lbl.addGestureRecognizer(recognizer2)
            }
            lbl.isUserInteractionEnabled = true
            lbl.tag = i
        }

        let selector = #selector(RotationView.pannedView(sender:))
        let recognizer = UIPanGestureRecognizer(target: self, action: selector)
        addGestureRecognizer(recognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pannedView(sender: UIPanGestureRecognizer) {
        let pt = sender.translation(in: self)
        self.transform = self.transform.translatedBy(x: pt.x, y: pt.y)
        sender.setTranslation(.zero, in: self)
    }
    
    @objc func pannedCorner(sender: UIPanGestureRecognizer) {
        func angle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
            let dx = dest.x - source.x
            let dy = dest.y - source.y
            return atan2(dy, dx)
        }
        
        func distance(from source: CGPoint, to dest: CGPoint) -> CGFloat {
            let dx = dest.x - source.x
            let dy = dest.y - source.y
            let d = (dx*dx + dy*dy).squareRoot()
            return d
        }
        
        let tr = sender.translation(in: self)
        let pt = sender.location(in: self)
        let pt2 = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let pt0 = CGPoint(x: pt.x - tr.x, y: pt.y - tr.y)
        let tag = sender.view?.tag ?? -1
        let cornerAngle = CGFloat.pi/4 * CGFloat([3,5,7,1][tag])
        
        switch functionList[tag] {
        case 0: //right top
            let rotateAngle = angle(from: pt2, to: pt) + cornerAngle
            self.transform = self.transform.rotated(by: rotateAngle)
        case 1: //right bottom
            let d0 = distance(from: pt2, to: pt0)
            let d = distance(from: pt2, to: pt)
            let scale = CGFloat.maximum(d, minCornerSize) / CGFloat.maximum(d0, minCornerSize)
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            sender.setTranslation(.zero, in: self)
        case 2: //left top
            let d0 = distance(from: pt2, to: pt0)
            let d = distance(from: pt2, to: pt)
            let scale = CGFloat.maximum(d, minCornerSize) / CGFloat.maximum(d0, minCornerSize)
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            sender.setTranslation(.zero, in: self)
            
            let rotateAngle = angle(from: pt2, to: pt) + cornerAngle
            self.transform = self.transform.rotated(by: rotateAngle)
        default:
            break
        }
    }
    
    @objc func tappedCorner(sender: UITapGestureRecognizer) {
        let a = self.transform.a
        let b = self.transform.b
        let scale = (a*a + b*b).squareRoot()
        let angle = atan2(b/scale, a/scale)
        let fixedAngle = ceil(angle * 4 / CGFloat.pi) * CGFloat.pi / 4
        var deltaAngle = fixedAngle - angle
        if deltaAngle < 0.00000000001 { //equal 0 dato tama ni komaru. hobo 0 no jouken.
            deltaAngle = CGFloat.pi / 4
        }
        self.transform = self.transform.rotated(by: deltaAngle)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }

        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }

        return super.hitTest(point, with: event)
    }
}


