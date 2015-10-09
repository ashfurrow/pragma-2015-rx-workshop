import Foundation
import Moya
import RxSwift

typealias ErrorHandler = ErrorType -> Observable<UIImage!>

protocol ViewModelType {
  init(
    email: Observable<String>,
    password: Observable<String>,
    enabled: ObserverOf<Bool>,
    submit: Observable<Void>,
    errorHandler: ErrorHandler)

  var image: Observable<UIImage!> { get }
}

class ViewModel: NSObject, ViewModelType {

    let disposeBag = DisposeBag()
    private let _povider: RxMoyaProvider<MyAPI>

    private var imageVariable = Variable<UIImage!>(nil)
    var image: Observable<UIImage!> {
        return self.imageVariable.asObservable()
    }

    convenience required init(
        email: Observable<String>,
        password: Observable<String>,
        enabled: ObserverOf<Bool>,
        submit: Observable<Void>,
        errorHandler: ErrorHandler) {

            self.init(
                email: email,
                password: password,
                enabled: enabled,
                submit: submit,
                errorHandler: errorHandler,
                provider: provider
            )
    }

    init(
        email: Observable<String>,
        password: Observable<String>,
        enabled: ObserverOf<Bool>,
        submit: Observable<Void>,
        errorHandler: ErrorHandler,
        provider: RxMoyaProvider<MyAPI>) {

        _povider = provider

        super.init()

        let validEmail = email.map(isEmail)
        let validPassword = password.map(isPassword)

        combineLatest(validEmail, validPassword, and).bindTo(enabled)

        submit.take(1).map { _ -> Observable<MoyaResponse> in
            return provider.request(.Image)
        }.switchLatest()
        .filterSuccessfulStatusCodes()
        .mapImage()
        .catchError(errorHandler)
        .subscribeNext { [weak self] (receivedImage) -> Void in
          self?.imageVariable.value = receivedImage
        }
        .addDisposableTo(disposeBag)
    }
}
