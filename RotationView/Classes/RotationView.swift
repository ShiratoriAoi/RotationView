
import UIKit

open class RotationView : UIView {
    public var functionList : [Int] //0: rotate, 1: scale, 2: rotate and scale, 3: 45 degrees rotate
    
    public var viewCorners = [UIView]() //left top, left bottom, right bottom, right top
    public var cornerScale = 1.0 {
        didSet {
            viewCorners.forEach { 
                $0.transform = CGAffineTransform.identity
                $0.transform = CGAffineTransform(scaleX: cornerScale, y: cornerScale)
            }
        }
    }
    public var minSize = 44 as CGFloat
    
    public var isShownCorner = true {
        didSet {
            viewCorners.forEach { a in
                a.isHidden = !isShownCorner
            }
            recognizers.forEach { a in 
                a.isEnabled = isShownCorner
            }
        }
    }

    var recognizers = [UIGestureRecognizer]()

    //computed property
    public var scale : CGFloat{
        let a = self.transform.a
        let b = self.transform.b
        return (a*a + b*b).squareRoot()
    }

    public var angle : CGFloat{
        let a = self.transform.a
        let b = self.transform.b
        //let scale = (a*a + b*b).squareRoot()
        //return atan2(b/scale, a/scale)
        return atan2(b,a)
    }
    
    public convenience init() {
        //left top:     0=rotate
        //left bottom:  1=scale
        //right bottom: 2=rotate and scale
        //right top:    3=45 degrees rotate
        self.init(functionList: [0,1,2,3], cornerSize: 44)
    }
    
    public init(functionList: [Int], cornerSize: CGFloat) {
        self.functionList = functionList
        super.init(frame: .zero)

        //rotation view's recognizer
        let selector = #selector(RotationView.pannedView(sender:))
        let recognizer = UIPanGestureRecognizer(target: self, action: selector)
        addGestureRecognizer(recognizer)
        recognizers.append(recognizer)

        //corners view's initialization
        for i in 0..<4 {
            let v = UIView()
            viewCorners.append(v)
            v.isUserInteractionEnabled = true
            v.tag = i
            addSubview(v)

            //constarints
            let ltA = leftAnchor
            let rtA = rightAnchor
            let tpA = topAnchor
            let btA = bottomAnchor
            let anchors = [(ltA, tpA), (ltA, btA), (rtA, btA), (rtA, tpA)]
            let A0 = anchors[i].0
            let A1 = anchors[i].1
            v.translatesAutoresizingMaskIntoConstraints = false
            v.centerXAnchor.constraint(equalTo: A0).isActive = true
            v.centerYAnchor.constraint(equalTo: A1).isActive = true
            v.heightAnchor.constraint(equalToConstant: cornerSize).isActive = true
            v.widthAnchor.constraint(equalToConstant: cornerSize).isActive = true
            
            //recognizer
            if functionList[i] == 3 {
                let selector2 = #selector(RotationView.tappedCorner(sender:))
                let recognizer2 = UITapGestureRecognizer(target: self, action: selector2)
                v.addGestureRecognizer(recognizer2)
                recognizers.append(recognizer2)
            } else {
                let selector2 = #selector(RotationView.pannedCorner(sender:))
                let recognizer2 = UIPanGestureRecognizer(target: self, action: selector2)
                v.addGestureRecognizer(recognizer2)
                recognizers.append(recognizer2)
            }
        }

    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func resize() {
        let scale = self.scale //scale ha transform ni izon suru computed property nanode shouryaku fukanou.(tabun.)
        self.transform = self.transform.scaledBy(x: 1/scale, y: 1/scale)
        self.bounds.size = CGSize(width: bounds.width*scale, height: bounds.height*scale)
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
        let ct = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let pt0 = CGPoint(x: pt.x - tr.x, y: pt.y - tr.y)
        let tag = sender.view?.tag ?? -1
        
        switch functionList[tag] {
        case 0: //rotate
            let theta = atan2(bounds.height, bounds.width)
            let cornerAngle = [CGFloat.pi-theta, CGFloat.pi+theta, -theta, theta][tag]
            let rotateAngle = angle(from: ct, to: pt) + cornerAngle
            self.transform = self.transform.rotated(by: rotateAngle)
        case 1: //scale
            let d0 = distance(from: ct, to: pt0) * scale
            let d = distance(from: ct, to: pt) * scale
            let scale = CGFloat.maximum(d, minSize) / CGFloat.maximum(d0, minSize)
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            sender.setTranslation(.zero, in: self)
            resize()
        case 2: //rotate and scale
            let theta = atan2(bounds.height, bounds.width)
            let cornerAngle = [CGFloat.pi-theta, CGFloat.pi+theta, -theta, theta][tag]
            let rotateAngle = angle(from: ct, to: pt) + cornerAngle
            self.transform = self.transform.rotated(by: rotateAngle)

            let d0 = distance(from: ct, to: pt0) * scale
            let d = distance(from: ct, to: pt) * scale
            let scale = CGFloat.maximum(d, minSize) / CGFloat.maximum(d0, minSize)
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            sender.setTranslation(.zero, in: self)
            resize()
        default:
            break
        }
    }
    
    @objc func tappedCorner(sender: UITapGestureRecognizer) {
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


