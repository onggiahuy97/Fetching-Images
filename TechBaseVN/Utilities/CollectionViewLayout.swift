//
//  CollectionViewLayout.swift
//  TechBaseVN
//
//  Created by Huy Ong on 4/30/21.
//

import UIKit

enum Layout: String, Codable {
    static let key = "LayoutKey"
    
    case regular = "Regular", compact = "Compact"
    
    func createLayout(_ bounds: CGRect, fractor: CGFloat = 5) -> UICollectionViewFlowLayout {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return ipadLayout(bounds, fractor)
        default:
            return iphoneLayout(bounds)
        }
    }
    
    static func getLayout() -> Layout {
        let string = UserDefaults.standard.value(forKey: Layout.key) as? String ?? "Regular"
        return string == "Regular" ? .regular : .compact
    }
    
    private func iphoneLayout(_ bounds: CGRect) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat
        let itemSize: CGSize
        if self == .compact {
            size = (bounds.size.width / 2) - 2
            itemSize = CGSize(width: size, height: size + 50)
        } else {
            size = bounds.size.width
            itemSize = CGSize(width: size, height: size / 2)
        }
        layout.itemSize = itemSize
        return layout
    }
    
    private func ipadLayout(_ bounds: CGRect, _ fractor: CGFloat = 5) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat
        let itemSize: CGSize
        if self == .compact {
            size = (bounds.size.width / fractor) - fractor
            itemSize = CGSize(width: size, height: size + 50)
        } else {
            size = (bounds.size.width / 2) - 2
            itemSize = CGSize(width: size, height: size / 2)
        }
        layout.itemSize = itemSize
        return layout
    }
}
