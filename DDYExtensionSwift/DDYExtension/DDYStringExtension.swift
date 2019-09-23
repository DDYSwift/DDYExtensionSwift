// String扩展


import UIKit

extension String: DDYNameSpaceProtocol { }

extension DDYWrapperProtocol where DDYT == String {

    /// 是否包含Emoji
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in ddyValue.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// json字符串格式化输出
    var jsonFormat: String {

        if (ddyValue.starts(with: "{") || ddyValue.starts(with: "[")) {
            var level = 0
            var jsonFormatString = String()
            func getLevelStr(level:Int) -> String {
                var string = ""
                for _ in 0..<level {
                    string.append("\t")
                }
                return string
            }

            for char in ddyValue {

                if level > 0 && "\n" == jsonFormatString.last {
                    jsonFormatString.append(getLevelStr(level: level))
                }

                switch char {
                case "{":
                    fallthrough
                case "[":
                    level += 1
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case ",":
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case "}":
                    fallthrough
                case "]":
                    level -= 1;
                    jsonFormatString.append("\n")
                    jsonFormatString.append(getLevelStr(level: level));
                    jsonFormatString.append(char);
                    break;
                default:
                    jsonFormatString.append(char)
                }
            }
            return jsonFormatString;
        }
        return ddyValue
    }

    /// 去掉两端空格和换行符
    public func trimChars(_ set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return ddyValue.trimmingCharacters(in: set)
    }
    /// 去掉指定字符集中字符
    public func trimPerCharacter(in characterStr: String) -> String {
        return ddyValue.trimmingCharacters(in: CharacterSet.init(charactersIn: characterStr))
    }

    /// 顺序查找指定子串，每个字符只扫描一次，不重复扫描。返回Range数组
    func rangesArray(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = ddyValue.range(of: ddyValue) else {
            return rangeArray
        }
        searchedRange = sr

        var resultRange = ddyValue.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = ddyValue.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }

    /// 顺序查找指定子串，每个字符只扫描一次，不重复扫描。返回NSRange数组
    func nsrangesArray(of string: String) -> [NSRange] {
        return rangesArray(of: string).map {
            NSRange($0, in: ddyValue)
        }
    }



    /// 判断是否存在汉字
    func isIncludeChinese() -> Bool {
        for ch in ddyValue.unicodeScalars {
            // 中文字符一般指的范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }

    /// 转拼音
    public func convertToPinYin(_ trimWhiteispace: Bool) -> String? {

        let strRef = NSMutableString.init(string: ddyValue) as CFMutableString
        // 转换带音标的拼音
        CFStringTransform(strRef, nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(strRef, nil, kCFStringTransformStripCombiningMarks, false)
        // 是否去掉空格
        let endStr = strRef as String
        return trimWhiteispace ? endStr.replacingOccurrences(of: " ", with: "") : endStr
    }

    /// Unicode转码
    public func unicodeToString() -> String? {
        let tempStr1 = ddyValue.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }

    /// 转富文本改变子串属性
    public func change(_ subStr: String,_ subAttrs: [NSAttributedString.Key : Any],_ otherAttrs:[NSAttributedString.Key : Any]? = nil) -> NSMutableAttributedString {

        let attributeStr = NSMutableAttributedString(string: ddyValue, attributes: otherAttrs)

        guard var searchedRange = ddyValue.range(of: ddyValue) else {
            return attributeStr
        }
        var resultRange = ddyValue.range(of: subStr, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            attributeStr.addAttributes(subAttrs, range: NSRange(range, in: ddyValue))
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = ddyValue.range(of: subStr, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return attributeStr
    }

}

// 下标截取任意位置的便捷方法
extension String {

    private var length: Int {
        return self.count
    }

    public func ddySubstring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    public func ddySubstring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    /// 通过下标范围取值和赋值 如 let subStr = str1[0..<10] str2[0..<2] = "NB"
    subscript (range: Range<Int>) -> String {
        get {
            let newRange = Range(uncheckedBounds: (lower: max(0, min(self.count, range.lowerBound)), upper: min(self.count, max(0, range.upperBound))))
            let start = index(startIndex, offsetBy: newRange.lowerBound)
            let end = index(start, offsetBy: newRange.upperBound - newRange.lowerBound)
            return String(self[start ..< end])
        }
        set {
            let newRange = Range(uncheckedBounds: (lower: max(0, min(self.count, range.lowerBound)), upper: min(self.count, max(0, range.upperBound))))
            let tmp = self
            var preStr = ""
            var sufStr = ""
            for (idx, item) in tmp.enumerated() {
                if (idx < newRange.startIndex) {
                    preStr += "\(item)"
                } else if (idx >= newRange.endIndex) {
                    sufStr += "\(item)"
                }
            }
            self = preStr + newValue + sufStr
        }
    }
    /// 通过起始下标和长度取值与赋值 如 let subStr = str1[0, 10] str2[0, 2] = "NB"
    subscript(location:Int, length:Int) -> String {
        get {
            return self[location..<location+length]
        }
        set {
            self[location..<location+length] = newValue
        }
    }
    /// 通过索引下标取值与赋值
    subscript(index: Int) -> String {
        get {
            return self[index ..< index + 1]
        }
        set {
            self[index..<index+1] = newValue
        }
    }
}

/// 判断字符串是否为空或nil 
public func ddyEmptyString(_ value: AnyObject?) -> Bool {
    if nil == value { //首先判断是否为nil
        return true
    } else {
        if let myValue = value as? String { //然后是否可以转化为String
            return myValue == "" || myValue == "(null)" || 0 == myValue.count
        } else { //字符串都不是，直接认为是空串
            return true
        }
    }
}
