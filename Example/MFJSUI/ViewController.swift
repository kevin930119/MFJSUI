//
//  ViewController.swift
//  MFJSUI
//
//  Created by weijialin on 01/13/2025.
//  Copyright (c) 2025 weijialin. All rights reserved.
//

import UIKit
import MFJSUI
import HandyJSON

class ViewController: UIViewController, MFJSUIViewDelegate {

    var uiView: MFJSUIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let dic: [String:Any] = ["a":1]
//        if let a = AAA.deserialize(from: dic) {
//            print(a.a)
//            if let b = a.value(forKey: "b") as? NSObject {
//                if let c = b.value(forKey: "c") as? CCC {
//                    print(c.name)
//                }
//            }
//        }
        MFJSUIConfigure.shared.enableDataBind = false
        let str = "${data.data.c.name}"
        
        let a = AAA()
        
        if let value = ValueFromObject(str, a) {
            print(value)
        } else {
            print("空值")
        }
        
        let path = Bundle.main.path(forResource: "Json", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        if let data = try? Data(contentsOf: url) {
            do {
                let object = try JSONSerialization.jsonObject(with: data)
                if let dic = object as? [String:Any] {
                    let view1 = MFJSUIView()
                    view1.delegate = self
                    view1.render(with: dic, bindData: a)
                    view.addSubview(view1)
                    self.uiView = view1
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let a = uiView?.bindedData as? AAA else { return }
        a.data.backgroundColor = "#E6E6E6"
        a.data.titleColor = "#999999"
        a.frame = "{\"x\":20,\"y\":30,\"width\":100,\"height\":\"50\"}"
//        a.x = 60
//        a.y = 0
        a.width = 100
        a.height = 20
        a.text = "哈建设大街哈酒"
        a.hightText = "大街哈酒"
        uiView?.reloadData()
    }
    
    func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String : Any]?) {
        print("事件触发：\(event)_\(identifier ?? "")_\(userInfo ?? [:])")
    }
    
    func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?) {
        print("事件已添加\(identifier ?? "")")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class AAA: NSObject, HandyJSON {
    var a = "a"
    var data: BBB = .init()
    @objc dynamic var text = "富文本"
    @objc dynamic var hightText = "富"
    @objc dynamic var frame = "{\"x\":20,\"y\":30,\"width\":200,\"height\":\"50\"}"
    @objc dynamic var x: CGFloat = 30
    @objc dynamic var y: CGFloat = 30
    @objc dynamic var width: CGFloat = 300
    @objc dynamic var height: CGFloat = 50
    
    required override init() {}
}

class BBB: NSObject {
    var name = "bbb"
    var c: CCC = .init()
    var value: String?
    var height: CGFloat = 300
    @objc dynamic var titleColor: String = "#000000"
    @objc dynamic var backgroundColor: String = "#000000"
}

@objcMembers
class CCC: NSObject {
    var name = "ccc"
}
