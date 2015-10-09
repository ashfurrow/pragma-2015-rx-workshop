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
    errorHandler: ErrorHandler,
    imageHandler: ObserverOf<UIImage!>)
}

class ViewModel: NSObject, ViewModelType {

    let disposeBag = DisposeBag()
    private let _povider: RxMoyaProvider<MyAPI>

    convenience required init(
        email: Observable<String>,
        password: Observable<String>,
        enabled: ObserverOf<Bool>,
        submit: Observable<Void>,
        errorHandler: ErrorHandler,
        imageHandler: ObserverOf<UIImage!>) {

            self.init(
                email: email,
                password: password,
                enabled: enabled,
                submit: submit,
                errorHandler: errorHandler,
                imageHandler: imageHandler,
                provider: provider
            )
    }

    init(
        email: Observable<String>,
        password: Observable<String>,
        enabled: ObserverOf<Bool>,
        submit: Observable<Void>,
        errorHandler: ErrorHandler,
        imageHandler: ObserverOf<UIImage!>,
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
        .bindTo(imageHandler)
        .addDisposableTo(disposeBag)
    }
}
