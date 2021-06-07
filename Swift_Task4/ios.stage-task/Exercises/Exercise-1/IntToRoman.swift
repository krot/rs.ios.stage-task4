import Foundation

public extension Int {
    
    var roman: String? {
        if self <= 0 || self >= 4000 {
              return nil
            }
            
            var input = self
            var output = ""
            
            var count = input / 1000
            output  += String(repeating: "M", count:count)
            
            input %= 1000
            count = input / 100
            output  += convert(number: count, roman1: "C", roman5: "D", roman10: "M")
            
            input %= 100
            count = input / 10
            output  += convert(number: count, roman1: "X", roman5: "L", roman10: "C")
            
            input %= 10
            output  += convert(number: input, roman1: "I", roman5: "V", roman10: "X")
            return output
          }
          
          func convert(number: Int, roman1 : String, roman5 : String, roman10 : String) -> String {
            if number == 0 {
              return ""
            }
            var output = ""
            switch number {
            case 1...3:
              output +=  String(repeating: roman1, count:number)
            case 4:
              output += roman1 + roman5
            case 5:
              output += roman5
            case 6...8:
              output += roman5 + String(repeating: roman1, count: number - 5)
            // case 9:
            default:
              output += roman1 + roman10
            }
            return output
    }
}
