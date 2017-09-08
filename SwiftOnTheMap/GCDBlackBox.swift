//
//  GCDBlackBox.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/7/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain( _ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        
        updates()
    }

}
