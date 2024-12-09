import AppIntents
import SwiftUI

struct AppShortcutsQuery: EntityQuery {
    func entities(for identifiers: [AppShortcuts.ID]) async throws
        -> [AppShortcuts]
    {
        shortcuts.filter {
            identifiers.contains($0.id)
        }
    }

    func suggestedEntities() async throws -> [AppShortcuts] {
        shortcuts
    }

    func defaultResult() async -> AppShortcuts? {
        shortcuts.first
    }
}

struct Shortcut: Identifiable {
    var description: String
    var keys: [String]
    var id: UUID = .init() // A unique identifier for each shortcut
}

struct AppShortcuts: AppEntity {
    var id: String
    var appName: String
    var shortcuts: [Shortcut]

    static var typeDisplayRepresentation: TypeDisplayRepresentation =
        "typeDisplayRepresentation"
    static var defaultQuery = AppShortcutsQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(appName)")
    }
}

struct SelectAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Character"
    @Parameter(title: "App")
    var app: AppShortcuts
}

enum Keys {
    static let CTRL = "⌃"
    static let SHIFT = "⇧"
    static let OPTION = "⌥"
    static let COMMAND = "⌘"
    static let ESCAPE = "⎋"
    static let ENTER = "⏎"
    static let DELETE = "⌫"
    static let RIGHT = "→"
    static let LEFT = "←"
    static let UP = "↑"
    static let DOWN = "↓"
    static let UPDOWN = "↕"
}

var shortcuts: [AppShortcuts] = [
    AppShortcuts(id: "2", appName: "XCode", shortcuts: [
        Shortcut(
            description: "Drop build cache",
            keys: [Keys.COMMAND, Keys.SHIFT, "K"]
        ),
        Shortcut(
            description: "Build",
            keys: [Keys.COMMAND, "B"]
        ),
        Shortcut(
            description: "Command palette",
            keys: [Keys.COMMAND, Keys.SHIFT, "A"]
        ),
    ]),
    AppShortcuts(id: "3", appName: "Telegram", shortcuts: [
        Shortcut(description: "Search messages", keys: [Keys.COMMAND, "F"]),
        Shortcut(description: "Fast search", keys: [Keys.COMMAND, "K"]),
        Shortcut(
            description: "Global search",
            keys: [Keys.COMMAND, Keys.SHIFT, "F"]
        ),
        Shortcut(
            description: "Select message",
            keys: [Keys.COMMAND, Keys.UPDOWN]
        ),
        Shortcut(description: "Voice/Video message", keys: [Keys.COMMAND, "R"]),
        Shortcut(description: "Chat profile", keys: [Keys.RIGHT]),
    ]),
]
