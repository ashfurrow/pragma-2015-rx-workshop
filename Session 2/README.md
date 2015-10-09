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

- Sequence inside an object (text field).
- `rx_text`
- `ObserverOf`.

### Signup Demo

- Combine sequences.

## Next Steps

Look for things like the following to abstact with RxSwift:

- Long running tasks.
- Network tasks.
- Text field validation.
- Simple stuff first, not complex.
- [Intro to Rx](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754).
