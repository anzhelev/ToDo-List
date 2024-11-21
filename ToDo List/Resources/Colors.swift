//
//  Colors.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 17.11.2024.
//
import UIKit

extension UIColor {
    static var blackMainBackground: UIColor {UIColor(named: "mainBackground") ?? UIColor.black}
    static var whiteMainTextActive: UIColor {UIColor(named: "mainText") ?? UIColor.white}
    static var grayMainTextInactive: UIColor {UIColor(named: "mainText")?.withAlphaComponent(0.5) ?? UIColor.lightGray} //#4D555E
//    static var graySearchBarText: UIColor {UIColor(named: "searchBarText")?.withAlphaComponent(0.5) ?? UIColor.lightGray}
    static var grayFooterBackground: UIColor {UIColor(named: "footerBackground") ?? UIColor.gray} // + searchBarBackground
    static var grayFooterDivider: UIColor {UIColor(named: "divider") ?? UIColor.gray}
}
