//
//  AuthService.swift
//

import NodeKit

public protocol AuthService {

    /// Метод для отправки логина и пароля на сервер. Первый фактор авторизации.
    func postAuth(authRequest: AuthRequest?) -> Observer<AuthResponseEntity>

    /// Метод для отправки логина и пароля на сервер. Первый фактор авторизации.
    func postAuth(silentAuthRequest: SilentAuthRequest?) -> Observer<AuthResponseEntity>

}