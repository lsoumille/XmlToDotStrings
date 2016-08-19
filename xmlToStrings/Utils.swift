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
    var inSubsitute:Bool = false
    for c in strWith2Quote.characters {
        if inSubsitute {
            if c == " " {
                res = res + "@"
                inSubsitute = false
            } else if c == "d" {
                inSubsitute = false
            } else {
                continue
            }
        }
        if c == "\n" {
            res = res + String("\\n")
            continue
        }
        if c == "\"" {
            res = res + "\\"
        }
        if c == "%" {
            inSubsitute = true
        }
        res = res + String(c)
    }
    return res
}