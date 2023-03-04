//
//  AuthorizerProtocol.swift
//  NewsApp
//
//  Created by Вячеслав on 05.03.2023.
//

import Foundation

protocol AuthorizerProtocol {
    func auth(login: String, password: String) -> Bool
}
