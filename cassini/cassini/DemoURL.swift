//
//  DemoURL.swift
//  cassini
//
//  Created by JiaShu Huang on 2019/3/7.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import Foundation

struct DemoURL {
    static let demoImageURL = URL(string: "http://g.hiphotos.baidu.com/image/pic/item/3c6d55fbb2fb4316cb63cc492ea4462309f7d381.jpg")
    static var NASA:Dictionary<String,URL> = {
        let NASAURLStrings = ["Cassini":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552137550164&di=57a42481a624cca19f6fedf7692ec614&imgtype=0&src=http%3A%2F%2Fi2.hdslb.com%2Fbfs%2Farchive%2Fa77e646b9c48c0108a733b701f8fce9178a1e27a.jpg",
                              "Earth":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552137617929&di=8b84bec4917107c19a252f5cbe55a9a1&imgtype=0&src=http%3A%2F%2Fimages6.fanpop.com%2Fimage%2Fphotos%2F39400000%2FMagical-earth-earth-planet-39492924-2880-1800.jpg",
                              "Saturn":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552137654546&di=63fa5575d5b6da7c1078922f18f8b40d&imgtype=0&src=http%3A%2F%2Fwww.thetimenow.com%2Fimg%2Fastronomy%2Fall%2FSaturn-650x250.jpg"]
        var urls = Dictionary<String,URL>()
        for (key,value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
