//
//  ReportFormsView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ReportFormsViewParameters: NSObject {
    var startAngle: Double = 0.00
    var endAngle: Double = 0.00
    var color: UIColor?
    var text: String?
    var scale: Double = 0.00
}

class ReportFormsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let startAngle: Double = -210.00
    var endAngle: Double{
        get{
            return self.startAngle - 360.00
        }
    }
    
    private var _params: Array<Any> = Array.init()
    public var params: Array<Any>{
        set{
            _params = newValue
            self.loadData()
        }
        get{
            return _params
        }
    }
    private let radius: CGFloat = 80
    private let offsetX: CGFloat = 70
    private var timer: Timer? = nil
    private var angle: Double = -180.00
    private var showData: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        loadData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            
            NSLog("开始了timer")
            
            self.setNeedsDisplay()
            self.angle -= 1.00 * 10
            
            if self.angle < self.endAngle{
                timer.fireDate = Date.distantFuture
//                timer.invalidate()
                self.showData = true
                self.setNeedsDisplay()
            }
            
        })
        
    }
    
    init() {
        super.init(frame: CGRect.zero)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() -> Void {
        
        self.backgroundColor = drawColor
        
        let centerView: UIView = UIView.init()
        centerView.backgroundColor = UIColor.white
        centerView.frame = CGRect.init(x: 0, y: 0, width: radius * 2 - 60, height: radius * 2 - 60)
        centerView.layer.cornerRadius = (radius * 2 - 60) / 2.0
        self.addSubview(centerView)
        centerView.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        
    }
    
    
    private func loadData() -> Void {
        
        self.showData = false
        self.angle = self.startAngle
        self.timer?.fireDate = Date.distantPast

    }
    

    override func draw(_ rect: CGRect) {
        
        let context: CGContext! = UIGraphicsGetCurrentContext()
        
        var color: UIColor = UIColor.init(red: 231 / 255.0, green: 231 / 255.0, blue: 231 / 255.0, alpha: 1.0)
        var startAngle: Double = self.startAngle
        var endAngle: Double = self.endAngle
        
        if self.params.count == 0 {
            
            //扇形
            context.setFillColor(color.cgColor)
            context.move(to: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY))
            context.addArc(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY), radius: radius, startAngle:(CGFloat)(startAngle * Double.pi / 180.0), endAngle: (CGFloat)(self.angle * Double.pi / 180.0), clockwise: true)
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.fill)
            return
            
        }
        
        
        for dic: Any in self.params {
            
            /*
            let dictionary: Dictionary = dic as! Dictionary<String, Any>
            color = dictionary["color"] as! UIColor
            startAngle = dictionary["startAngle"] as! Double
            endAngle = dictionary["endAngle"] as! Double
            let text: String = dictionary["text"] as! String
            */
            
            let params: ReportFormsViewParameters = dic as! ReportFormsViewParameters
            color = params.color ?? UIColor.red
            startAngle = params.startAngle
            endAngle = params.endAngle
            
            if self.angle <= startAngle && self.angle >= endAngle{
                
                //扇形
                context.setFillColor(color.cgColor)
                context.move(to: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY))
                context.addArc(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY), radius: radius, startAngle:(CGFloat)(startAngle * Double.pi / 180.0), endAngle: (CGFloat)(self.angle * Double.pi / 180.0), clockwise: true)
                context.closePath()
                context.drawPath(using: CGPathDrawingMode.fill)
                break
                
            }else{
                //扇形
                context.setFillColor(color.cgColor)
                context.move(to: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY))
                context.addArc(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY), radius: radius, startAngle:(CGFloat)(startAngle * Double.pi / 180.0), endAngle: (CGFloat)(endAngle * Double.pi / 180.0), clockwise: true)
                context.closePath()
                context.drawPath(using: CGPathDrawingMode.fill)
            }

        }
        
        
        if self.showData == false {
            return
        }
        
        for dic: Any in self.params {
            /*
            let dictionary: Dictionary = dic as! Dictionary<String, Any>
            let color: UIColor = dictionary["color"] as! UIColor
            let startAngle: Double = dictionary["startAngle"] as! Double
            let endAngle: Double = dictionary["endAngle"] as! Double
            let text: String = dictionary["text"] as! String
            */
            
            let params: ReportFormsViewParameters = dic as! ReportFormsViewParameters
            color = params.color ?? UIColor.red
            startAngle = params.startAngle
            endAngle = params.endAngle
            let text: String = params.text ?? ""
            
            if params.scale < 0.025{
                continue
            }
            
            //小圆点
            var y: CGFloat = (radius + 10) * CGFloat(sin(((endAngle - startAngle) / 2.0  + startAngle) * Double.pi / 180.0))
            var x: CGFloat = (radius + 10) * CGFloat(cos(((endAngle - startAngle) / 2.0 + startAngle) * Double.pi / 180.0))
            x += self.bounds.midX
            y += self.bounds.midY
            
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(1)
            context.addArc(center: CGPoint.init(x: x, y: y), radius: 5, startAngle: 0, endAngle: CGFloat.init(2 * Double.pi), clockwise: false)
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
            
            context.setFillColor(color.cgColor)
            context.addArc(center: CGPoint.init(x: x, y: y), radius: 3, startAngle: 0, endAngle: CGFloat.init(2 * Double.pi), clockwise: false)
            context.drawPath(using: CGPathDrawingMode.fill)
            
            
            //折线
            var y1: CGFloat = (radius + 25) * CGFloat(sin(((endAngle - startAngle) / 2.0  + startAngle) * Double.pi / 180.0))
            var x1: CGFloat = (radius + 25) * CGFloat(cos(((endAngle - startAngle) / 2.0 + startAngle) * Double.pi / 180.0))
            x1 += self.bounds.midX
            y1 += self.bounds.midY
            
            var points:Array<CGPoint> = Array.init();
            let point1: CGPoint = CGPoint.init(x: x, y: y)
            points.append(point1)
            
            var point2: CGPoint! = CGPoint.zero
            var point3: CGPoint! = CGPoint.zero
            var point4: CGPoint! = CGPoint.zero
            if x >= self.bounds.midX && y >= self.bounds.midY{
                //                point2 = CGPoint.init(x: x + 15, y: y + 15)
                point2 = CGPoint.init(x: x1, y: y1)
                points.append(point2)
                //                point3 = CGPoint.init(x: point2.x + offsetX, y: point2.y)
                point3 = CGPoint.init(x: self.bounds.maxX - 15, y: point2.y)
                points.append(point3)
                point4 = CGPoint.init(x: point3.x - lengthOf(text), y: point3.y - 15)
            }else if x >= self.bounds.midX && y <= self.bounds.midY{
                //                point2 = CGPoint.init(x: x + 15, y: y - 15)
                point2 = CGPoint.init(x: x1, y: y1)
                points.append(point2)
                //                point3 = CGPoint.init(x: point2.x + offsetX, y: point2.y)
                point3 = CGPoint.init(x: self.bounds.maxX - 15, y: point2.y)
                points.append(point3)
                point4 = CGPoint.init(x: point3.x - lengthOf(text), y: point3.y - 15)
            }else if x <= self.bounds.midX && y >= self.bounds.midY{
                //                point2 = CGPoint.init(x: x - 15, y: y + 15)
                point2 = CGPoint.init(x: x1, y: y1)
                points.append(point2)
                //                point3 = CGPoint.init(x: point2.x - offsetX, y: point2.y)
                point3 = CGPoint.init(x: 15, y: point2.y)
                points.append(point3)
                point4 = CGPoint.init(x: point3.x, y: point3.y - 15)
                
            }else if x <= self.bounds.midX && y <= self.bounds.midY{
                //                point2 = CGPoint.init(x: x - 15, y: y - 15)
                point2 = CGPoint.init(x: x1, y: y1)
                points.append(point2)
                //                point3 = CGPoint.init(x: point2.x - offsetX, y: point2.y)
                point3 = CGPoint.init(x: 15, y: point2.y)
                points.append(point3)
                point4 = CGPoint.init(x: point3.x, y: point3.y - 15)
                
            }
            
            context.addLines(between: points)
            context.setStrokeColor(color.cgColor)
            context.drawPath(using: CGPathDrawingMode.stroke)
            
            let attribute: Dictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            (text as NSString).draw(in: CGRect.init(x: point4.x, y: point4.y, width: lengthOf(text), height: 15), withAttributes: attribute)
            
            
        }
        
        
        
        
    }
    
    func lengthOf(_ text:String) -> CGFloat {
        let rect = (text as NSString).boundingRect(with: CGSize.init(width: 0, height: 15), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context: nil)
        return rect.width
    }
    
}
