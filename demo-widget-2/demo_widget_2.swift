import WidgetKit
import SwiftUI
import CoreMotion

@main
struct GyroBallWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "GyroBallWidget", provider: Provider()) { entry in
            GyroBallWidgetView(entry: entry)
        }
        .configurationDisplayName("Gyro Ball")
        .description("Control a ball using the gyroscope.")
    }
}

struct Provider: TimelineProvider {
    private let motionManager = CMMotionManager()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), position: CGPoint(x: 50, y: 50))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), position: CGPoint(x: 50, y: 50))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        var currentPosition = CGPoint(x: 50, y: 50)

        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates()
        }

        for secondOffset in 0..<10 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 1, to: currentDate)!

            if let data = motionManager.gyroData {
                let xMovement = CGFloat(data.rotationRate.y) * 10
                let yMovement = CGFloat(data.rotationRate.x) * 10

                // 打印陀螺仪数据
                print("Gyro Data at \(entryDate): x = \(data.rotationRate.x), y = \(data.rotationRate.y), z = \(data.rotationRate.z)")
                
                currentPosition = CGPoint(x: currentPosition.x + xMovement, y: currentPosition.y - yMovement)
            }
            
            let entry = SimpleEntry(date: entryDate, position: currentPosition)
            entries.append(entry)
        }
        
        motionManager.stopGyroUpdates()
        
        let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(5)))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let position: CGPoint
}

struct GyroBallWidgetView: View {
    var entry: SimpleEntry

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .frame(width: 20, height: 20)
                .position(x: max(min(entry.position.x, geometry.size.width), 0),
                          y: max(min(entry.position.y, geometry.size.height), 0))
        }
        .containerBackground(Color.clear, for: .widget)
    }
}
