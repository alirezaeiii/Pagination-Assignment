//
//  PaginationAssignmentApp.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import SwiftUI

@main
struct PaginationAssignmentApp: App {
    
    @State var viewModel = PaginationViewModel(networkService: NetworkService())
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(viewModel)
        }
    }
}
