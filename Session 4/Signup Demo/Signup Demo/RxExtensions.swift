import Foundation

func isEmail(string: String) -> Bool {
    return string.characters.contains("@")
}

func isPassword(string: String) -> Bool {
    return string.characters.count >= 6
}

func and(lhs: Bool, rhs: Bool) -> Bool {
    return lhs && rhs
}
