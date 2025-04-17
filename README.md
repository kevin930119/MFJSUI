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
| ContentMode  | scaleToFill<br>asda  |
