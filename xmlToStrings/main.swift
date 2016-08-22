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
    //take all the tab lines
    if let tabLines = xmlDoc.root["string-array"].all {
        for t in tabLines {
            var arrayWithItem:[String] = [String]()
            //add items
            for c in t.children {
                arrayWithItem.append(c.value!)
            }
            dictionary[t.attributes["name"]!] = arrayWithItem.description
        }
    }
    writeInLocalizable(dictionary)
} catch {
    print("\(error)")
}

exit(EXIT_SUCCESS)
