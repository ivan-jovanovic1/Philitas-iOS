//
//  DataState.swift
//  Philitas
//
//  Created by Ivan Jovanović on 02/04/2022.
//

import Foundation

enum DataState<T: Equatable> {
    case loading
    case data(T)
    case error(Error)
    
    var value: T? {
        switch self {
        case .data(let t):
            return t
        default:
            return nil
        }
    }
}

extension DataState: Equatable {
    static func == (lhs: DataState<T>, rhs: DataState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .error(_)):
            return false
        case (.loading, .data(_)):
            return false
        case (.loading, .loading):
            return true
        case (.error(let error1), .error(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.error(_), .loading):
            return false
        case (.error(_), .data(_)):
            return false
        case (.data(_), .error(_)):
            return false
        case (.data(let data1), .data(let data2)):
            return data1 == data2
        case (.data(_), .loading):
            return false
        }
    }
}
