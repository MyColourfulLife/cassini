1. 什么时候应该去加载资源
如果一个视图控制器在tabViewController中，如果同时有5个控制器，那么都在viewDidload中加载资源，是不太妥当的。如果用户不去点击，那么没有显示的那些视图控制器的资源。
因此，应当在视图将要出现的时候去加载。
视图控制器有一个view，当视图控制器将要出现时，会把它的view加载到window上，由此可以判断，此控制器是否要呈现出来
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    imageURL = DemoURL.demoImageURL // if it in tabController we do not want load view until it will appear
}

var imageURL:URL? {
    didSet{
    image = nil
    if view.window != nil { // when controller will be show, its view will be add to window
        fetchImage()
        }
    }
}

```
此外，当视图将要出现时，如果image不存在，去加载资源

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if image == nil {// when image is nil fetch the image
    fetchImage()
    }
}
```

2. 在引用outlet的变量时，要注意此时使用它，它是否必然已被赋值，如果没有注意使用可选型

```swift
private var image:UIImage? {
    get{
    return imageView.image
    }
    set{
    imageView.image = newValue
    imageView.sizeToFit()
    scrollView?.contentSize = imageView.frame.size // when image set, the scorllView may be nil
    }
}
```
---

3. 比较耗时的操作，比如下载图片，应当使用多线程技术，避免用户操作卡顿
4. 比较耗时的操作，当结果返回时，应当检查用户是否已不再关心此操作，或已经切换到其他页面了
5. 耗时操作，应该状态提示
```swift
if let url = imageURL{
    // 操作可能很耗时，用户可能不等到结果就返回了，等block回来时，self可能已经不存在了。
    // 用户可能更改了image的赋值，如果图片地址发生了改变，用户已经不关心原有的地址了
    // 提醒用户有操作正在进行
    spinner.startAnimating()
    // 不论何时给图片赋值，只要给图片赋值了就停止
    DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let imageData = try? Data(contentsOf: url),self?.imageURL == url{
            // 注意上面的条件判断
            // 所有的UI操作都要回到主线程
            DispatchQueue.main.async {
            self?.image = UIImage(data: imageData)
            }
        }
    }
}
```
注意在图片赋值时，iboutlet可能还没有被hook住，需要使用可选型
```swift
private var image:UIImage? {
    get{
    return imageView.image
    }
    set{
    imageView.image = newValue
    imageView.sizeToFit()
    scrollView?.contentSize = imageView.frame.size // when image set, the scorllView may be nil
    spinner?.stopAnimating()// 在prepare时，outlet都没有，spinner也可能没有被赋值
    }
}
```

6. 使用splitViewController适配iPhone和iPad平台时，处于当没有详情页面时，应当显示master控制器
设置 UISplitViewController的代理，并实现collapseSecondary onto 方法
这个代理应该在早些设置，可以在awakeFromNib中设置
```swift
override func awakeFromNib() {
    super.awakeFromNib()
    if let splitViewController = self.splitViewController {
    splitViewController.delegate = self
    }
}

//Return YES to prevent UIKit from applying its default behavior; return NO to request that UIKit
// perform its default collapsing behavior.
func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
// detailViewController没有内容时，返回yes组织，有内容时返回NO使用默认行为
    if let imageVC = secondaryViewController.contents as? ImageViewController, imageVC.imageURL != nil {
    return false
    }else {
    return true
    }
}
```
