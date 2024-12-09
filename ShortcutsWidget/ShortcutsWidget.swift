
/*
 info.plist - widget settings
 .entitlements - controls what Widget can do
 Assets.xcassets - Bundle which will contain the widget icon
 .intentdefinition - for Siri and Shortcuts customizations

 Apple's default Xcode Widget Extension code creates a simple Calendar
 Widget with a View (the UI) and three Provider methods: placeholder, getSnapshot, and getTimeline.

 Provider struct inherits from Apple class IntentTimelineProvider
 IntentTimelineProvider tells WidgetKit when to update the Widget
 */
import AppIntents
import SwiftUI
import WidgetKit

struct ProviderEntry: TimelineEntry {
    var date: Date
    var appShortcuts: AppShortcuts
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in _: Context) -> ProviderEntry {
        ProviderEntry(date: Date(), appShortcuts: shortcuts[0])
    }

    func snapshot(for configuration: SelectAppIntent, in _: Context) async -> ProviderEntry {
        ProviderEntry(date: Date(), appShortcuts: configuration.app)
    }

    func timeline(for configuration: SelectAppIntent,
                  in _: Context) async -> Timeline<ProviderEntry>
    {
        Timeline(
            entries: [ProviderEntry(
                date: Date(),
                appShortcuts: configuration.app
            )],
            policy: .never
        )
    }
}

struct KeyboardShortcutView: View {
    let shortcut: [String]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(shortcut, id: \.self) { key in
                HStack {
                    Text(key).font(.system(.body, design: .monospaced)).frame(
                        minWidth: 25,
                        minHeight: 25
                    ).foregroundColor(.secondary)
                }.background(Color(.secondarySystemFill).opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(
                        Color(.systemGray).opacity(0.2),
                        lineWidth: 1
                    ))
            }
        }
    }
}

struct ShortcutsWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            Text(entry.appShortcuts.appName + " shortcuts").font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom]).foregroundColor(.primary)

            ForEach(entry.appShortcuts.shortcuts) { shortcut in
                HStack {
                    KeyboardShortcutView(shortcut: shortcut.keys)
                    Spacer()
                    Text(shortcut.description).foregroundColor(.secondary)
                }
                Divider()
            }
            Spacer()
        }.containerBackground(Color(.systemFill), for: .widget)
    }
}

struct ShortcutsWidget: Widget {
    let kind: String = "ShortcutsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectAppIntent.self,
            provider: Provider()
        ) { entry in
            ShortcutsWidgetEntryView(entry: entry)
        }.configurationDisplayName("Shortcuts widget")
            .supportedFamilies([.systemSmall, .systemLarge, .systemExtraLarge,
                                .systemMedium])
    }
}
