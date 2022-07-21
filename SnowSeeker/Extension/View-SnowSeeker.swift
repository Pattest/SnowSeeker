//
//  View-SnowSeeker.swift
//  SnowSeeker
//
//  Created by Baptiste Cadoux on 21/07/2022.
//

import SwiftUI

extension View {

    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}
