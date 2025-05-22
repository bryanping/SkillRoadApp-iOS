import Foundation

enum ResourceType: String, CaseIterable, Codable {
    case link = "链接"
    case image = "图片"
    case file = "文件"
    
    var allowedExtensions: [String] {
        switch self {
        case .link:
            return ["http", "https"]
        case .image:
            return ["jpg", "jpeg", "png", "gif", "webp"]
        case .file:
            return ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt"]
        }
    }
}

struct Resource: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: ResourceType
    let url: String
    let createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    var isValidURL: Bool {
        guard let url = URL(string: url) else { return false }
        
        switch type {
        case .link:
            return url.scheme?.lowercased() == "http" || url.scheme?.lowercased() == "https"
        case .image, .file:
            let fileExtension = url.pathExtension.lowercased()
            return type.allowedExtensions.contains(fileExtension)
        }
    }
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        type: ResourceType,
        url: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.url = url
        self.createdAt = createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(ResourceType.self, forKey: .type)
        url = try container.decode(String.self, forKey: .url)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        guard isValidURL else {
            throw DecodingError.dataCorruptedError(
                forKey: .url,
                in: container,
                debugDescription: "Invalid URL format for resource type"
            )
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, type, url, createdAt
    }
}