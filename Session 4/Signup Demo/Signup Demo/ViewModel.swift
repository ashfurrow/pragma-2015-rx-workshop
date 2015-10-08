import Foundation
import Moya
import RxSwift

class ViewModel: NSObject {
    typealias ErrorHandler = ErrorType -> Observable<UIImage!>

    let disposeBag = DisposeBag()

    init(
        email: Observable<String>,
        password: Observable<String>,
        enabled: ObserverOf<Bool>,
        submit: Observable<Void>,
        errorHandler: ErrorHandler,
        imageHandler: ObserverOf<UIImage!>) {

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
