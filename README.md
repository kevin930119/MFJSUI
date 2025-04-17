# MFJSUI第一版
# 一、引擎说明
MFJSUI，是一款通过JSON数据映射成节点数据，再通过节点数据配置UI控件属性的UI渲染引擎
## 1、开发语言
该引擎使用Swift语言开发
## 2、三方库依赖
* HandyJSON（JSON转模型）
* Kingfisher（网络图片加载）
## 3、功能特点
此引擎拥有以下特点：

1、多项目UI快速迁移（还原度100%）

2、后台实时下发JSON实现UI热更新

3、数据绑定（单向绑定，修改模型数据可快速同步到UI）

# 二、UI支持情况
已支持的UI控件基本覆盖日常开发需求，未覆盖到的功能后续再进行完善

|  UI控件   | 支持情况  |
|  ----  | ----  |
| UIView  | ✅ |
| UILabel  | ✅ |
| UIImageView  | ✅ |
| UIControl  | ✅ |
| UIButton  | ✅ |
| UIScrollView  | ✅ |
| UITextField  | ✅ |
| UITextView  | ✅ |
| UITableView  | ❌ |
| UICollectionView  | ❌ |

# 三、使用指南
## 1、集成方式
使用cocopods集成
```
# MFJSUI引擎，内部Git服务器
pod 'MFJSUI', :git => 'http://10.10.10.20:3000/socialproduct/MFJSUI.git'
```
## 2、JSON格式说明
渲染UI控件的API与系统原生API保持一致
### 2.1 UI控件API说明
UI控件的API基本系统原生API保持一致，这里不过多赘述
### 2.2 事件API说明
引擎内置以下这几种事件，分为View事件与Control事件两种
* View事件
|  事件名   | 描述  |
|  ----  | ----  |
| viewTap  | 视图点击事件 |
| viewDoubleTap  | 视图双击事件 |
| viewLongPress  | 视图长按事件 |

* Control事件
|  事件名   | 描述  |
|  ----  | ----  |
| controlTouchUpInsize  | 点击在内部抬起 |
| controlTouchUpOutsize  | 点击在外部抬起 |
| controlTouchDown  | 点击 |
| controlTouchCancel  | 点击取消 |
| controlValueChanged  | 数值改变 |

事件数据挂载在View下的actions字段，示例如下：
```
"actions":[
    {
        "event":"viewTap",
        "data":"传递数据"
    },
    {
        "event":"controlTouchUpInsize",
        "data":"传递数据"
    }
 ]
```

event字段为事件名，data为需要传递的数据，触发事件后将会把事件通过冒泡形式传递到最上层View，通过MFJSUIView的代理事件中获取
```
public protocol MFJSUIViewDelegate: NSObjectProtocol {
    /// 内部视图触发事件
    /// - Parameters:
    ///   - actionName: 事件名
    ///   - View: 响应事件的视图
    ///   - userInfo: 额外信息 如果是手势事件
    ///   key[MFViewActionKeyGestureRecognizer]里面存储手势对象
    ///   key[data]里面存储JSON文件事件里面存储的data数据
    func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String:Any]?)
    
    /// 内部手势被添加
    /// 外部可通过该手势做一些处理，例如：不同手势间的交互兼容
    /// - Parameter gestureRecognizer: 手势
    /// - Parameter view: 添加视图
    /// - Parameter identifier: 视图标识
    func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?)
}
```

### 2.3 枚举字段自定义
View的属性为枚举的，将通过内部自定义枚举字符串的形式进行赋值，自定义的枚举类型列举如下：
|  枚举   | 值(string)  |
|  ----  | ----  |
| ContentMode  | scaleToFill<br>scaleAspectFit<br>scaleAspectFill  |
| TextAlignment  | left<br>center<br>right  |
| LineBreakMode  | wordWrapping<br>charWrapping<br>clipping<br>truncatingHead<br>truncatingTail<br>truncatingMiddle  |

### 2.4 常见结构体自定义
常见的结构体使用字符串形式表达
|  类型   | 示例  |
|  ----  | ----  |
| CGRect  | "{"x":0,"y":30,"width":375,"height":"${data.data.height}"}"  |
| UIEdgeInsets  | "{"top":0,"bottom":30,"left":375,"right":"${data.data.height}"}"  |
| CGSize  | "{"width":0,"height":30}"  |
| CACornerMask  | "topLeft,topRight,bottomLeft,bottomRight"<br>PS：圆角类型，,分割  |
| UIFont  | "regular,16"<br>"medium,16"<br>"semibold,16"<br>"bold,16"<br>"light,16"<br>
PS：自定义字体请通过MFJSUIConfigure全局配置类的代理处理  |

### 2.5 数据绑定
引擎支持数据绑定，即JSON数据里面可以通过数据绑定，将数据绑定在传入的模型数据里，NSObject类型的数据支持动态绑定（修改模型数据实时更新到UI）
PS：绑定数据同样支持字典形式，只是传入字典就无法使用动态绑定
数据绑定格式如下：
```
"backgroundColor":"${data.data.backgroundColor}"
```
第一个data默认为传入的模型数据，以上字符串表示backgroundColor取值为传入的模型数据里的data模型里的backgroundColor字段，模型设计如下：
```
class AAA: NSObject, HandyJSON {
    var data: BBB = .init()
    
    required override init() {}
}

class BBB: NSObject {
    @objc dynamic var backgroundColor: String = "#000000"
}
```
### 2.6 屏幕自适应
引擎支持数值类型的屏幕自适应，当数值类型传入的是字符串形式时，将会默认开启屏幕自适应，按照375的屏幕比例来适配，数值后缀为rpx为启用屏幕自适应，后缀为px为不启用，例如：

```
"layer_cornerRadius":"30rpx" // 等同于 "layer_cornerRadius":"30"
"layer_cornerRadius":"30px"
```

### 2.7 示例JSON
如下所示：
```
{
    "platform": "ios",
    "rootView": {
        "class":"View",
        "identifier":"root",
        "frame":"{\"x\":0,\"y\":30,\"width\":375,\"height\":\"${data.data.height}\"}",
        "backgroundColor":"${data.data.backgroundColor}",
        "subviews":[
            {
                "class":"View",
                "identifier":"root",
                "frame":"{\"x\":\"${data.x}\",\"y\":\"${data.y}\",\"width\":\"${data.width}\",\"height\":\"${data.height}\"}",
                "backgroundColor":"#FFFFFFDE",
                "layer_cornerRadius":"30rpx",
                "actions":[
                    {
                        "event":"viewTap",
                        "data":"传递数据"
                    }
                ]
            },
            {
                "class":"Label",
                "identifier":"label",
                "frame":"{\"x\":20,\"y\":100,\"width\":0,\"height\":\"0\"}",
                "backgroundColor":"#FFFFFF",
                "layer_cornerRadius":"30",
                "text":"按钮",
                "textColor":"${data.data.titleColor}",
                "textAlignment":"center",
                "attributedText":{
                    "text":"${data.text}",
                    "textColor":"${data.data.titleColor}",
                    "font":"semibold,12",
                    "lineSpacing":10,
                    "highlights":[
                        {
                            "text":"${data.hightText}",
                            "textColor":"#FF6A6A",
                            "font":"semibold,16"
                        },
                        {
                            "location":"1",
                            "length":"1",
                            "textColor":"#FF6A6A",
                            "font":"semibold,15"
                        }
                    ]
                }
            },
            {
                "class":"Button",
                "identifier":"btn",
                "frame":"{\"x\":20,\"y\":200,\"width\":200,\"height\":\"60\"}",
                "backgroundColor":"#FFFFFF",
                "title":"按钮",
                "titleColor":"${data.data.titleColor}",
                "actions":[
                    {
                        "event":"controlTouchUpInsize",
                        "data":"传递数据"
                    }
                ]
            }
        ]
    }
}
```
## 3、使用说明
### 3.1 初始化
使用 MFJSUIView 类来承载渲染出来的UI，可以使用JSON对象，也可以使用JSON字符串渲染，用法如下：
```
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
```
### 3.2 事件接收
事件接收使用 MFJSUIView 的代理接收
```
public protocol MFJSUIViewDelegate: NSObjectProtocol {
    /// 内部视图触发事件
    /// - Parameters:
    ///   - actionName: 事件名
    ///   - View: 响应事件的视图
    ///   - userInfo: 额外信息 如果是手势事件
    ///   key[MFViewActionKeyGestureRecognizer]里面存储手势对象
    ///   key[data]里面存储JSON文件事件里面存储的data数据
    func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String:Any]?)
    
    /// 内部手势被添加
    /// 外部可通过该手势做一些处理，例如：不同手势间的交互兼容
    /// - Parameter gestureRecognizer: 手势
    /// - Parameter view: 添加视图
    /// - Parameter identifier: 视图标识
    func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?)
}
```
### 3.3 数据动态绑定/刷新
- 数据动态绑定
数据动态绑定默认是开启的，要关闭需要更改 MFJSUIConfigure 里的enableDataBind
```
MFJSUIConfigure.shared.enableDataBind = false

// 当开启了动态绑定，并且JSON数据里面指定了要使用数据绑定，当修改了模型数据里的数据，将会实时更新到UI上
guard let a = uiView?.bindedData as? AAA else { return }
a.data.backgroundColor = "#E6E6E6"

// 当JSON里面有地方使用 ${data.data.backgroundColor} 来进行数据绑定时，上面的代码修改了数据，就会同步更新到UI上
```
- 数据刷新
当没有开启动态绑定是，数据源修改了，如果要同步到UI上，需要调用 MFJSUIView的reload方法
```
guard let a = uiView?.bindedData as? AAA else { return }
a.data.backgroundColor = "#E6E6E6"
uiView?.reloadData()
```
### 3.4 自定义网络图片加载/自定义字体处理
引擎内部自带图片加载与系统字体处理，当外部有需要自定义图片加载（例如图片解密）以及字体处理的时候可以使用 MFJSUIConfigure 的代理事件处理
```
public protocol MFJSUIConfigureDelegate: NSObjectProtocol {
    /// 获取自定义字体
    func jsUIConfigureFont(with fontName: String, size: CGFloat) -> UIFont
    /// 获取本地图片（UIButton使用）
    func jsUIConfigureImage(with imageName: String) -> UIImage?
    /// 获取本地图片（外部设置图片）
    func jsUIConfigureImage(with imageName: String, for imageView: UIImageView)
    /// 获取网络图片（外部设置图片）
    func jsUIConfigureNetImage(with urlString: String, for imageView: UIImageView)
}
```
# 四、关键技术点解析
## 1、事件传递
事件传递采用冒泡传递方式（逐层向上传递），将事件传递到最上层UI视图触发代理事件，供开发者接收处理
```
@objc func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String : Any]?) {
        // 事件冒泡向上传递
        superview?.actionsOccured(event: event, view: view, identifier: identifier, userInfo: userInfo)
    }
    
@objc func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?) {
        // 事件冒泡向上传递
        superview?.gestureRecognizerDidAdd(gestureRecognizer: gestureRecognizer, to: view, identifier: identifier)
    }
```
## 2、数据绑定（单向绑定）
### 2.1 两层KVO监听实现的数据动态绑定
#### 2.1.1 动态绑定的原理如图所示：
![alt desc](https://github.com/kevin930119/MFJSUI/blob/main/img1.jpg)
#### 2.1.2 通过链式语法获取数据模型里的数据
使用的是swift语言的反射机制来获取，代码如下
```
/// 通过链式语法获取data里面的数据
    static func value(for key: String, in data: Any) -> Any? {
        if let dict = data as? [AnyHashable:Any] {
            // 切割字符串
            var subStrs = key.components(separatedBy: ".")
            var targetDict = dict
            var targetValue: Any?
            while subStrs.count > 0 {
                let value = targetDict[subStrs[0]]
                if let valueDict = value as? [String:Any] {
                    targetDict = valueDict
                    subStrs.removeFirst()
                } else {
                    targetValue = value
                    subStrs.removeAll()
                }
            }
            return targetValue ?? key
        } else if !isBaseType(with: data) {
            // 切割字符串
            var subStrs = key.components(separatedBy: ".")
            var targetObject = data
            var targetValue: Any?
            while subStrs.count > 0 {
                var fieldDatas: [String:Any] = [:]
                // 通过反射获取数据
                let mirror = Mirror(reflecting: targetObject)
                for child in mirror.children {
                    if let label = child.label {
                        fieldDatas.updateValue(child.value, forKey: label)
                    }
                }
                let value = fieldDatas[subStrs[0]]
                if !isBaseType(with: value), let value {
                    targetObject = value
                    subStrs.removeFirst()
                } else {
                    targetValue = value
                    subStrs.removeAll()
                }
            }
            return targetValue ?? key
        }
        return key
    }
```
### 2.2 frame多层数据结构的绑定逻辑
由于frame是通过JSON字符串实现的，字符串格式比较复杂，里面的数据如果要实现动态绑定需要多做一些处理，比如：
```
"{"x":"${data.x}","y":"${data.y}","width":"${data.width}","height":"${data.height}"}"
```
实现原理为依次去除里面的数据，将数据绑定到frame上，数据发生改变直接刷新frame的数据获取即可，代码如下：
```
func extendAddKVO(with key: String) {
        if key == "frame" {
            guard let value = value(with: key) as? String else { return }
            if value.hasPrefix("${") && value.hasSuffix("}") {
                // 简单数据绑定字段
                return
            }
            if !value.contains("${") {
                return
            }
            // 解析json
            if let jsonData = value.data(using: .utf8) {
                if let dict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:Any] {
                    var waitToBindInfo: [(String, String)] = []
                    if let x = dict["x"] as? String {
                        if x.hasPrefix("${") && x.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((x, "x"))
                        }
                    }
                    if let y = dict["y"] as? String {
                        if y.hasPrefix("${") && y.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((y, "y"))
                        }
                    }
                    if let width = dict["width"] as? String {
                        if width.hasPrefix("${") && width.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((width, "width"))
                        }
                    }
                    if let height = dict["height"] as? String {
                        if height.hasPrefix("${") && height.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((height, "height"))
                        }
                    }
                    
                    for info in waitToBindInfo {
                        guard let object = bindData as? NSObject else { return }
                        // 获取参数
                        var pat = info.0.subString(start: 2, count: info.0.count-3)
                        if pat.hasPrefix("data.") {
                            pat = pat.subString(start: 5, count: pat.count-5)
                        }
                        guard let kvoInfo = MFJSUITool.parentObject(for: pat, in: object) else { return }
                        if observerInfo[kvoInfo.1] != nil {
                            continue
                        }
                        kvoInfo.0.addObserver(self, forKeyPath: kvoInfo.1, options: .new, context: nil)
                        observerInfo.updateValue(kvoInfo.0, forKey: kvoInfo.1)
                        // 扩展KVO字段
                        extentKeyMap.updateValue("frame", forKey: kvoInfo.1)
                    }
                }
            }
        }
    }
```
### 2.3 attributedText多层数据结构的绑定逻辑
attributedText的绑定逻辑与frame的绑定逻辑一致，就不过多赘述了
# 五、引擎功能第二版功能展望
第一版功能还属于比较基础的实现，接下来对于该引擎还将会有一些完善的工作要完成
- UITableView支持
- UICollectionView支持
- 布局方式引入AutoLayout
- 数据的双向绑定
