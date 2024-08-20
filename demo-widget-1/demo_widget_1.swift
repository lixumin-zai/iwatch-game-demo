import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), position: 10, direction: 1, isCatWalking: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), position: 10, direction: 1, isCatWalking: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        var position: CGFloat = 10
        var direction: CGFloat = 1
        let maxX: CGFloat = 200  // 假设小组件宽度为100

        let stepSize: CGFloat = 1  // 保持步长较小
        let millisecondStep: Double = 100  // 每步100毫秒
        var isCatWalking = true

        for millisecondOffset in 0..<1200 {
            let entryDate = currentDate.addingTimeInterval(Double(millisecondOffset) * millisecondStep / 1000)
            position += direction * stepSize
            if position >= maxX || position <= 10 {
                direction *= -1
            }
            
            // Toggle the walking state
            isCatWalking.toggle()
            
            let entry = SimpleEntry(date: entryDate, position: position, direction: direction, isCatWalking: isCatWalking)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let position: CGFloat
    let direction: CGFloat
    let isCatWalking: Bool
}

struct demo_widget_1EntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            // Use different images to simulate walking
            Image(systemName: entry.isCatWalking ? "pawprint.fill" : "pawprint.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.orange)
                .position(x: entry.position, y: geometry.size.height / 2)
        }
    }
}

@main
struct demo_widget_1: Widget {
    let kind: String = "demo_widget_1"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            demo_widget_1EntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryCircular) {
    demo_widget_1()
} timeline: {
    SimpleEntry(date: .now, position: 10, direction: 1, isCatWalking: true)
    SimpleEntry(date: .now.addingTimeInterval(1), position: 20, direction: 1, isCatWalking: false)
}
