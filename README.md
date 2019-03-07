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
