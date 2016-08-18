#!/usr/bin/swift

import Foundation

extension NSOutputStream {
    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int{
        if let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}

func escapeDoubleQuote(strWith2Quote:String) -> String {
    var res:String = String("")
    for c in strWith2Quote.characters {
        if c == "\n" {
            res = res + String("\\n")
            continue
        }
        if c == "\"" {
            res = res + "\\"
        }
        res = res + String(c)
    }
    return res
}

var url:String = ""
for ind in 0...Process.arguments.count {
    if ind == 1 {
        url = Process.arguments[ind]
    }
}

guard let
    xmlPath = NSBundle.mainBundle().pathForResource("strings", ofType: "xml"),
    data = NSData(contentsOfFile: xmlPath)
else {
       print("No file")
       exit(EXIT_FAILURE)
}

var options = AEXMLDocument.NSXMLParserOptions()
options.shouldProcessNamespaces = false
options.shouldReportNamespacePrefixes = false
options.shouldResolveExternalEntities = false
var dictionary:Dictionary<String, String> = [:]

do {
    let xmlDoc = try AEXMLDocument(xmlData: data, xmlParserOptions: options)
    
    if let lines = xmlDoc.root["string"].all {
        for l in lines {
            dictionary[l.attributes["name"]!] = l.value
        }
    }
    if let o = NSOutputStream(toFileAtPath: "Localization.strings", append: true){
        o.open()
        for (k, v) in dictionary {
            var str:String = escapeDoubleQuote(v)
            /*if v[v.startIndex] == "\"" && v[v.endIndex.predecessor()] == "\"" {
                str = "\"\(k)\":\"" + "\\" + String(v.characters.dropLast()) + "\\\"" + "\";\n"
            } else {*/
            
           // }
           // str =
            o.write("\"\(k)\":\"" + str + "\";\n")
        }
        o.close()
    }
    
} catch {
    print("\(error)")
}

exit(EXIT_SUCCESS)
