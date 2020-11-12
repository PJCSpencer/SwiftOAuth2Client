//
//  Foundation+Additions.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


extension Int
{
    func megabytes() -> Int
    { return self * 1024 * 1024 }
}

extension Dictionary
{
    static func + (lhs: [Key:Value],
                   rhs: [Key:Value]) -> [Key:Value]
    {
        return lhs.merging(rhs) {$1}
    }
}

extension CharacterSet
{
    static var extendedAlphanumerics: CharacterSet
    {
        var set = CharacterSet.alphanumerics
        set.insert(charactersIn: "*-._")
        
        return set
    }
}

extension String
{
    // TODO:Consider: https://github.com/EntropyString/EntropyString-Swift ..?
    static func randomHighEntropyCryptographic(in range: Range<Int>) -> String
    {
        enum Statics
        {
            static let scalars =
            [
                UnicodeScalar("a").value...UnicodeScalar("z").value,
                UnicodeScalar("A").value...UnicodeScalar("Z").value,
                UnicodeScalar("0").value...UnicodeScalar("9").value
            ].joined()

            static let table: [Character] = scalars.compactMap { UnicodeScalar($0) ?? nil }.map { Character($0) }
        }
        
        let result = (range).compactMap { _ in Statics.table.randomElement() }
        return String(result)
    }
}

