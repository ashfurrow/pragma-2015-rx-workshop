Session 2
=========

- Make sure you have CocoaPods installed (`[sudo] gem install cocoapods`).
- Create new Xcode project with Single View template.
- Run `pod init` and add "RxSwift" to the podfile. Also add `use_frameworks!`.

```rb
use_frameworks!

target 'Example' do

pod 'RxSwift', '~> 2.0.0-alpha'
pod 'RxCocoa', '~> 2.0.0-alpha'

end
```

- Open the workspace.
- Play 🎉

### Sequence Demo

- Sequence inside an object (text field)
- rx_text
- ObserverOf

### Signup Demo

- combine stuff

## Next Steps

Look for abstractions like:

- long running tasks
- network tasks
- text field validation
- simple stuff first, not complex