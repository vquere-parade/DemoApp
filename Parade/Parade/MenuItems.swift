//
//  MenuItems.swift
//  Parade
//
//  Created by Simon Le Bras on 25/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

let menuItems = [
    MenuItem(
        title: NSLocalizedString("Elevator Pitch", comment: "Elevator Pitch menu item"),
        image: UIImage(named: "pitch")!,
        imageHighlight: UIImage(named: "pitch_highlight")!,
        type: .Pitch
    ),
    MenuItem(
        title: NSLocalizedString("Shoe Demo", comment: "Shoe Demo menu item"),
        image: UIImage(named: "demo")!,
        imageHighlight: UIImage(named: "demo_highlight")!,
        type: .Demo
    ),
    MenuItem(
        title: NSLocalizedString("Presentation", comment: "Presentation menu item"),
        image: UIImage(named: "presentation")!,
        imageHighlight: UIImage(named: "presentation_highlight")!,
        type: .PDF(file: "presentation")
    ),
    MenuItem(
        title: NSLocalizedString("Video", comment: "Video menu item"),
        image: UIImage(named: "video")!,
        imageHighlight: UIImage(named: "video_highlight")!,
        type: .Video(file: "video", type: "mp4")
    ),
    MenuItem(
        title: NSLocalizedString("Collection Vigil", comment: "Collection Vigil menu item"),
        image: UIImage(named: "collection_vigil")!,
        imageHighlight: UIImage(named: "collection_vigil_highlight")!,
        type: .Collection(file: "vigil")
    ),
    MenuItem(
        title: NSLocalizedString("Collection Metier", comment: "Collection Metier menu item"),
        image: UIImage(named: "collection_metier")!,
        imageHighlight: UIImage(named: "collection_metier_highlight")!,
        type: .Collection(file: "metier")
    ),
    MenuItem(
        title: NSLocalizedString("Technology Deck", comment: "Technology Deck menu item"),
        image: UIImage(named: "technology")!,
        imageHighlight: UIImage(named: "technology_highlight")!,
        type: .PDF(file: "")
    ),
    MenuItem(
        title: NSLocalizedString("Press Release", comment: "Press Release menu item"),
        image: UIImage(named: "press")!,
        imageHighlight: UIImage(named: "press_highlight")!,
        type: .PDF(file: "press")
    ),
    MenuItem(
        title: NSLocalizedString("Website Link", comment: "Website Link menu item"),
        image: UIImage(named: "website")!,
        imageHighlight: UIImage(named: "website_highlight")!,
        type: .Link(url: "http://e-vone.com/")
    ),
    MenuItem(
        title: NSLocalizedString("Update Data", comment: "Update Data menu item"),
        image: UIImage(named: "update")!,
        imageHighlight: UIImage(named: "update_highlight")!,
        type: .Update
    ),
]
