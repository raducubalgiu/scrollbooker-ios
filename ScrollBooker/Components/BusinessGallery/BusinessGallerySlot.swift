//
//  BusinessGallerySlot.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

/// Un slot din galeria unui business: gol, o poză deja urcată (`existing`, doar
/// URL, fără bytes descărcați încă) sau o poză aleasă acum din galeria device-ului
/// (`picked`, bytes gata de urcat). Distincția contează la salvare: endpoint-ul
/// de business gallery face un full-replace (șterge tot ce exista și scrie exact
/// ce trimitem), deci un slot `existing` neschimbat trebuie re-descărcat și
/// re-urcat — nu există un mecanism de "păstrează poza asta" pe server.
enum BusinessGallerySlot: Equatable {
    case empty
    case existing(URL)
    case picked(Data)
}
