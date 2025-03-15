//
//  LoremIpsum.swift
//  iChecks
//
//  Created by Christophe Guégan on 08/12/2024.
//

import Foundation

class LoremIpsum {
    
    static var short: String {
        return paragraphs(3)
    }
    
    static var medium: String {
        return paragraphs(6)
    }
    
    static var long: String {
        return paragraphs(9)
    }
    
    /// Return a random sentence
    ///
    static func sentence() -> String {
        let sentences = [
            "Lorem ipsum odor amet, consectetuer adipiscing elit.",
            "Netus mattis ut laoreet adipiscing aptent turpis odio scelerisque.",
            "Risus vel fermentum magnis vel egestas duis.",
            "Eu eleifend volutpat proin malesuada maximus volutpat facilisis efficitur ultricies.",
            "Sagittis molestie ligula pretium magna in phasellus scelerisque nam.",
            "Consequat parturient orci venenatis eget venenatis tellus ridiculus ad.",
            "Accumsan porta dictum malesuada lobortis dictumst fusce; rhoncus semper molestie?",
            "Curabitur fringilla tristique purus penatibus tortor congue pulvinar id.",
            "Magnis tortor vehicula quisque ultricies porttitor lectus et imperdiet.",
            "Finibus interdum habitant vehicula; accumsan velit est elit.",
            "Phasellus volutpat montes integer platea class etiam.",
            "Consequat libero gravida eu vel eros a cras.",
            "Porttitor ut tortor mattis est rhoncus.",
            "Ut ipsum lorem sed platea purus nunc tristique!",
            "Ipsum laoreet vulputate non; ut placerat semper dapibus vel.",
            "Dis lorem metus neque lectus, tempor ultrices congue dui.",
            "Commodo tortor porttitor amet, quisque nec pharetra ultrices aenean lobortis.",
            "Natoque consequat molestie sodales iaculis urna leo quisque."
        ]
        
        /// Return the sentence
        return sentences.randomElement()!
    }
    
    /// Return a random paragraph
    /// - Parameter length: Number of sentences in the paragraph
    ///
    static func paragraphs(_ length: Int) -> String {
        var paragraph = ""
        for _ in 0...length {
            paragraph += "\(sentence()) "
        }
        
        /// Return the paragraph
        return paragraph
    }
    
}

