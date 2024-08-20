//
//  File.swift
//  VoltGo
//
//  Created by Grady Blair on 6/27/24.
//

import Foundation
import Combine

import SwiftUI

class SideMenuViewModel: ObservableObject {
    @Published var isMenuVisible = false
    @Published var selectedView: String? = nil // Add selectedView to track navigation
    
    func navigateTo(_ view: String) {
        selectedView = view
        isMenuVisible = false // Close the side menu after navigation
    }
}


