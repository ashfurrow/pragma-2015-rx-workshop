import Foundation
import Quick
import Nimble
import Nimble_Snapshots
import RxSwift
import Moya
@testable
import Signup_Demo

class ViewModelTests: QuickSpec {
  override func spec() {
    var subject: ViewModel!

    var isEnabled = false
    var image: UIImage?
    var errored = false

    var email: Variable<String>!
    var password: Variable<String>!
    var enabled: ObserverOf<Bool>!
    var submit: Variable<Void>!
    var errorHandler: ErrorHandler!
    var imageHandler: ObserverOf<UIImage!>!

    beforeEach {
      isEnabled = false
      errored = false
      image = nil

      email = Variable("")
      password = Variable("")
      enabled = ObserverOf<Bool> { (e: Event<Bool>) in
        isEnabled = e.element ?? false
      }
      submit = Variable<Void>()
      errorHandler = { _ -> Observable<UIImage!> in
        errored = true
        return just(nil)
      }
      imageHandler = ObserverOf<UIImage!> { (e: Event<UIImage!>) in
        if case .Next(let value) = e {
          image = value
        }
      }

      subject = ViewModel(
        email: email.asObservable(),
        password: password.asObservable(),
        enabled: enabled,
        submit: submit.asObservable(),
        errorHandler: errorHandler)
    }

    it("is not enabled when email is invalid") {
      password.value = "1234567890"
      email.value = "ashashfurrow.com"
      expect(isEnabled) == false
    }

    it("is not enabled when password is invalid") {
      password.value = "123"
      email.value = "ash@ashfurrow.com"
      expect(isEnabled) == false
    }

    describe("valid email and password") {
      beforeEach {
        password.value = "1234567890"
        email.value = "ash@ashfurrow.com"
      }

      it("is enabled") {
        expect(isEnabled) == true
      }

      describe("submission") {
        it("properly returns image") {let endpointClosure = { (target: MyAPI) -> Endpoint<MyAPI> in
          let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
          return Endpoint<MyAPI>(URL: url, sampleResponseClosure: { () -> EndpointSampleResponse in

            let bundle = NSBundle(forClass: self.dynamicType)
            let path = bundle.pathForResource("image", ofType: "jpg")!
            let data = NSData(contentsOfFile: path)!

            return .NetworkResponse(200, data)
          })
          }
          
          let provider = RxMoyaProvider<MyAPI>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)

          subject = ViewModel(
            email: email.asObservable(),
            password: password.asObservable(),
            enabled: enabled,
            submit: submit.asObservable(),
            errorHandler: errorHandler,
            provider: provider)

          submit.value = Void()

          expect(image) != nil
        }

        it("invokes error handler on unsuccessful status codes") {
          let endpointClosure = { (target: MyAPI) -> Endpoint<MyAPI> in
            let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
            return Endpoint<MyAPI>(URL: url, sampleResponseClosure: { () -> EndpointSampleResponse in
              return .NetworkResponse(404, NSData())
            })
          }

          let provider = RxMoyaProvider<MyAPI>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)

          subject = ViewModel(
            email: email.asObservable(),
            password: password.asObservable(),
            enabled: enabled,
            submit: submit.asObservable(),
            errorHandler: errorHandler,
            provider: provider)

            submit.value = Void()

          expect(errored) == true
        }

        it("invokes error handler on unsuccessful image mapping") {
          let endpointClosure = { (target: MyAPI) -> Endpoint<MyAPI> in
            let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
            return Endpoint<MyAPI>(URL: url, sampleResponseClosure: { () -> EndpointSampleResponse in

              let data = "hi".dataUsingEncoding(NSUTF8StringEncoding)!

              return .NetworkResponse(200, data)
            })
          }

          let provider = RxMoyaProvider<MyAPI>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)

          subject = ViewModel(
            email: email.asObservable(),
            password: password.asObservable(),
            enabled: enabled,
            submit: submit.asObservable(),
            errorHandler: errorHandler,
            provider: provider)

          submit.value = Void()
          
          expect(errored) == true
        }
      }
    }
  }
}
