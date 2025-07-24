//
//  CustomError.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

enum CustomError: Error{
    case urlIsInvalid
    case dataTaskFailed
    case decodingFailed
    case statusCode(Int)
}
