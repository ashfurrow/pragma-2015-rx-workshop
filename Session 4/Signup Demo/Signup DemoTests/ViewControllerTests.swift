import Foundation
import Quick
import Nimble
import Nimble_Snapshots
import RxSwift
import Moya
@testable
import Signup_Demo

let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

class ViewControllerTests: QuickSpec {
  override func spec() {
    var viewModel: TestViewModel!
    var subject: ViewController!

    beforeEach {
      viewModel = TestViewModel(
        email: Variable("").asObservable(),
        password: Variable("").asObservable(),
        enabled: ObserverOf<Bool>(eventHandler: { _ in }),
        submit: Variable<Void>().asObservable(),
        errorHandler: { _ -> Observable<UIImage!> in
          return just(nil)
        })

        subject = storyboard.instantiateInitialViewController() as! ViewController
        subject.viewModel = viewModel
    }

    it("looks fine with an image") {
      let bundle = NSBundle(forClass: self.dynamicType)
      let path = bundle.pathForResource("image", ofType: "jpg")!
      let image = UIImage(contentsOfFile: path)
      viewModel.sendImage(image)

      expect(subject).to( recordSnapshot() )
    }
  }
}

class TestViewModel: NSObject, ViewModelType {
  var email: Observable<String>
  var password: Observable<String>
  var enabled: ObserverOf<Bool>
  var submit: Observable<Void>
  var errorHandler: ErrorHandler
  var imageVariable = Variable<UIImage!>(nil)

  var image: Observable<UIImage!> {
    return imageVariable.asObservable()
  }

  required init(
    email: Observable<String>,
    password: Observable<String>,
    enabled: ObserverOf<Bool>,
    submit: Observable<Void>,
    errorHandler: ErrorHandler) {
    self.email = email
    self.password = password
    self.enabled = enabled
    self.submit = submit
    self.errorHandler = errorHandler
  }

  func sendImage(image: UIImage!) {
    imageVariable.value = image
  }
}