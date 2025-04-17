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
