//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Neil R.Bhasme on 26/04/2019.
//  Copyright © 2019 Neil R.Bhasme. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    


    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    var emojis = "😀🐻🦆🦀🐟🦘🦈🐎🦚🌲🐿🐚🌛🌎⭐️☄️🔥⛅️🌤☃️🍐🍉🍈🍌🍒🍠🌶🥑🍆".map {String ($0)}  //Array of emojis (string) mapped to an array of strings
    //map takes a collection and turns it into an array where it executes a closure on each items
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell {
            let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
            emojiCell.label.attributedText = text
        }
        return cell
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("got images NRB 1 can handle called")
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print("got images NRB copy called")
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print("got images NRB 1")
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                print("got images NRB ")
                print(image)
                self.emojiArtView.backgroundImage = image
            }
            
        }
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
    }
    
    @IBOutlet weak var emojiArtView: EmojiArtView!
}
