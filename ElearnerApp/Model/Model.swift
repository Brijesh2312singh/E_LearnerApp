import Foundation

struct SignupResponse: Codable {
    let success: Bool
    let message: String
    let user: UserData?
}

struct UserData: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let role: String
}
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let token: String?
}
struct HomeResponse: Codable {
    let success: Bool
    let message: String
    let data: HomeData
}

struct HomeData: Codable {
    let topMenus: [TopMenu]
    let banners: [Banner]
    let sections: [HomeSection]
}

struct TopMenu: Codable {
    let id: Int
    let title: String
    let icon: String
}

struct Banner: Codable {
    let id: Int
    let image: String
}

struct HomeSection: Codable {
    let id: Int
    let title: String
    let icon: String
    let color: String
}

