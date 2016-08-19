//
//  Utils.swift
//  xmlToStrings
//
//  Created by Dev2 on 8/19/16.
//  Copyright © 2016 Frontware. All rights reserved.
//

import Foundation

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