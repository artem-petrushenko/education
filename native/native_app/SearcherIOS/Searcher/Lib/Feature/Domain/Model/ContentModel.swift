import Foundation

// MARK: - Welcome
struct ContentDataModel: Codable {
    let data: [ContentModel]
    let meta: Meta
    let pagination: Pagination
}

// MARK: - Welcome
struct ContentDetailsModel: Codable {
    let data: ContentModel
}

// MARK: - ContentModel
struct ContentModel: Codable, Identifiable {
    let id: String
    let title: String
    let images: Images

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case images
    }
}

// MARK: - Images
struct Images: Codable {
    let original: FixedHeight

    enum CodingKeys: String, CodingKey {
        case original
        
    }
}


// MARK: - Meta
struct Meta: Codable {
    let status: Int
    let msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
