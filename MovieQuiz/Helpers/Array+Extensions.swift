import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

/*
 subscript(index: Int) -> Int {
     get {
         // Возвращаем соответствующее значение
     }
     set(newValue) {
         // Устанавливаем подходящее значение
     }
 }
 */
