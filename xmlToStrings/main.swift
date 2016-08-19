#!/usr/bin/swift

import Foundation

// get file name if it's empty take strings by default
var url:String = ""
var urlTo:String = ""
for ind:Int in 0 ... Process.arguments.count - 1  {
    if ind == 1 {
        url = Process.arguments[ind]
    }
    if ind == 2 {
        urlTo = Process.arguments[ind]
    }
}
//Default values
if url == "" {
    url = "./strings.xml"
}

//Get XML path
guard let
    //xmlPath = NSBundle.mainBundle().pathForResource("strings", ofType: "xml"),
    data = NSData(contentsOfFile: url)
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
    //Convert XML to Dictionary
    let xmlDoc = try AEXMLDocument(xmlData: data, xmlParserOptions: options)
    //Take all the string lines
    if let lines = xmlDoc.root["string"].all {
        for l in lines {
            dictionary[l.attributes["name"]!] = l.value
        }
    }
    //Write each line in the new file
    if let o = NSOutputStream(toFileAtPath: urlTo + "Localizable.strings", append: false){
        o.open()
        for (k, v) in dictionary {
            //escape the double quotes and the \n
            var str:String = escapeDoubleQuote(v)
            o.write("\"\(k)\"=\"" + str + "\";\n")
        }
        o.close()
    }
    
} catch {
    print("\(error)")
}

exit(EXIT_SUCCESS)
