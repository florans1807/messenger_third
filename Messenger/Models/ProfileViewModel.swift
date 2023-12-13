//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Флоранс on 12.12.2023.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
