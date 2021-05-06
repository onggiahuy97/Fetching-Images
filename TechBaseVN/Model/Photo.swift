//
//  Photo.swift
//  TechBaseVN
//
//  Created by Huy Ong on 4/29/21.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
