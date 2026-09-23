//
//  BaseViewModel.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
    }
}
