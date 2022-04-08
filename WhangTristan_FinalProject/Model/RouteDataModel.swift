//
//  RouteDataModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation

protocol RouteDataModel {
    func addPin(lng: Double, lat: Double, hrsSpent: Int, minSpent: Int)
}
