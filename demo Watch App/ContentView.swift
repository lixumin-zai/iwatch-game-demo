//import SwiftUI
//
//struct ContentView: View {
//    @State private var image: UIImage? = nil
//    @State private var imagePosition: CGPoint = CGPoint(x: 100, y: 100)  // 展示的位置
//    @State private var initialPosition: CGPoint = CGPoint(x: 100, y: 100) //  初始位置
//    @State private var onDragImagePosition: CGPoint = CGPoint(x: 100, y: 100) // 点击拖拽前的位置
//    
//    @State private var gridBackground: UIImage? = nil
//    
//    @State private var gridSize = CGSize(width: 50, height: 50) // 初始化格子大小
//    @State private var margin: CGFloat = 30       // 假设边距为30
//    
//    @State private var showSuccessAlert = false
//    @State private var inWall = false
//    @State private var screenSize = WKInterfaceDevice.current().screenBounds.size
//    
//    @State private var maze: [[Int]] = [
//        [1, 1, 1, 1, 1],
//    ]  //迷宫数组
//    
//    let rows_init = 13
//    let cols_init = 9
//    
//    var body: some View {
//        ZStack {
//            if let gridBackground = gridBackground {
//                Image(uiImage: gridBackground)
//                    .edgesIgnoringSafeArea(.all)
//            }
//            Color.clear // 一个透明的全屏视图，用来捕捉拖拽手势
//                .contentShape(Rectangle()) // 确保整个区域都响应手势
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            // 计算拖拽的偏移量
//                            let translation = gesture.translation
//                            let newPosition = CGPoint(
//                                x: onDragImagePosition.x + translation.width,
//                                y: onDragImagePosition.y + translation.height
//                            )
//                            
//                            // 根据新的位置计算所在的row和col
//                            if let (row, col) = rowAndCol(for: newPosition) {
//                                if maze[row][col] == 0 && !inWall{
//                                    imagePosition = newPosition // 更新位置为手势的当前位置
//                                    inWall = false
//                                } else {
//                                    inWall = true
//                                }
//                            }
//                        }
//                        .onEnded { gesture in
//                            if let (row, col) = rowAndCol(for: imagePosition) {
//                                withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
//                                    let rect = CGRect(
//                                        x: margin + CGFloat(col) * gridSize.width,
//                                        y: margin + CGFloat(row) * gridSize.height,
//                                        width: gridSize.width,
//                                        height: gridSize.height
//                                    )
//                                    print(rect)
//                                    let rectMidPoint = CGPoint(
//                                        x: rect.midX,
//                                        y: rect.midY
//                                    )
//                                    imagePosition = rectMidPoint //这里放回当前row, col的中点
//                                }
//                                if row >= rows_init - 2 && col >= cols_init - 2 && !inWall{
//                                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
//                                        imagePosition = initialPosition // 动画回到初始位置
//                                    }
//                                    generateMazeBackground()
//                                    showSuccessAlert = true // 显示弹窗
//                                }
//                            }
//                            onDragImagePosition = imagePosition
//                            inWall = false
//                        }
//                )
//            if let image = image {
////                Circle()
////                    .strokeBorder(Color.gray, lineWidth: 2) // 灰色的边框表示加载状态
////                    .frame(width: 20, height: 20)
////                    .position(x: imagePosition.x,
////                              y: imagePosition.y)
////                    .edgesIgnoringSafeArea(.all) // 让视图填满整个屏幕
//                Image(uiImage: image)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .position(x: imagePosition.x,
//                              y: imagePosition.y)
//                    .edgesIgnoringSafeArea(.all) // 让视图填满整个屏幕
//            } else {
//                Circle()
//                    .strokeBorder(Color.gray, lineWidth: 2) // 灰色的边框表示加载状态
//                    .frame(width: 20, height: 20)
//                    .overlay(
//                        ProgressView()
//                            .frame(width: 10, height: 10)
//                    )
//            }
//        }
//
//        .alert(isPresented: $showSuccessAlert) {
//            Alert(title: Text("👍🐮"), message: RandomSuccessMessage(), dismissButton: .default(Text("好哒")))
//        }
//        .onAppear {
//            generateMazeBackground()
//            loadImageFromURL("http://82.156.3.170:55555/sanrio.png")
//        }
//    }
//    
//    func RandomSuccessMessage() -> Text {
//        let messages = ["宝宝你真棒", "好厉害", "真是太棒了", "继续加油"]
//        if let randomMessage = messages.randomElement() {
//            return Text(randomMessage)
//        }
//        else{
//            return Text("宝宝你真棒")
//        }
//    }
//    
//    func rowAndCol(for location: CGPoint) -> (row: Int, col: Int)? {
//        let col = Int((location.x - margin) / gridSize.width)
//        let row = Int((location.y - margin) / gridSize.height)
//        guard row >= 0 && row < maze.count && col >= 0 && col < maze[0].count else {
//            return nil
//        }
//        print(row, col)
//        return (row, col)
//    }
//    
//    
//    func loadImageFromURL(_ urlString: String) {
//        guard let url = URL(string: urlString) else {
//            self.image = UIImage(named: "defaultImage") // 加载默认图片
//            return
//        }
//        
//        let timeoutInterval: TimeInterval = 4 // 设置超时时间为10秒
//        let timeoutTask = DispatchWorkItem {
//            self.image = UIImage(named: "defaultImage") // 超时后加载默认图片
//        }
//        
//        // 在主队列上执行超时任务
//        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutInterval, execute: timeoutTask)
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            // 如果下载任务在超时之前完成，取消超时任务
//            timeoutTask.cancel()
//            
//            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
//                DispatchQueue.main.async {
//                    self.image = UIImage(named: "defaultImage") // 下载失败加载默认图片
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.image = downloadedImage
//            }
//        }
//        
//        task.resume()
//    }
//
//    
//    func generateMazeBackground() {
//        let screenSize = WKInterfaceDevice.current().screenBounds.size
//        print(screenSize)
//        let margin: CGFloat = 30
//        let adjustedWidth = screenSize.width - 2 * margin // 138.0
//        let adjustedHeight = screenSize.height - 2 * margin  // 182.0
//        gridSize = CGSize(width: adjustedWidth / CGFloat(cols_init), height: adjustedHeight / CGFloat(rows_init))
//        maze = generateMaze(rows: rows_init, cols: cols_init)
//        
//        UIGraphicsBeginImageContext(screenSize)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        let color1 = UIColor(red: 213/255.0, green: 246/255.0, blue: 242/255.0, alpha: 1.0) // 自定义颜色1
//        let color2 = UIColor(red: 251/255.0, green: 191/255.0, blue: 189/255.0, alpha: 1.0) // 自定义颜色2
//        let selectedColor = Bool.random() ? color1.cgColor : color2.cgColor
//        
//        for row in 0..<rows_init {
//            for col in 0..<cols_init {
//                let rect = CGRect(
//                    x: margin + CGFloat(col) * gridSize.width,
//                    y: margin + CGFloat(row) * gridSize.height,
//                    width: gridSize.width,
//                    height: gridSize.height
//                )
//                
//                if row == 1 && col == 0 {
//                    let rectMidPoint = CGPoint(
//                        x: rect.midX,
//                        y: rect.midY
//                    )
//                    imagePosition = rectMidPoint
//                    initialPosition = rectMidPoint
//                    onDragImagePosition = rectMidPoint
//                    
//                }
//                
//                context.setFillColor(maze[row][col] == 1 ? selectedColor : UIColor.black.cgColor)
//                context.fill(rect)
//            }
//        }
//        
//        gridBackground = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
//    
//    func generateMaze(rows: Int, cols: Int) -> [[Int]] {
//        var maze = Array(repeating: Array(repeating: 1, count: cols), count: rows)
//        
//        func carveMaze(x: Int, y: Int) {
//            let directions = [(0, -1), (-1, 0), (0, 1), (1, 0)].shuffled()
//            
//            for (dx, dy) in directions {
//                let nx = x + dx * 2
//                let ny = y + dy * 2
//                
//                if nx > 0 && nx < rows && ny > 0 && ny < cols && maze[nx][ny] == 1 {
//                    maze[nx - dx][ny - dy] = 0
//                    maze[nx][ny] = 0
//                    carveMaze(x: nx, y: ny)
//                }
//            }
//        }
//        
//        maze[1][0] = 0
//        maze[1][1] = 0
//        carveMaze(x: 1, y: 1)
//        maze[rows - 2][cols - 2] = 0
//        maze[rows - 2][cols - 1] = 0
//        
//        return maze
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


// ##############################################################################################################################

//import SwiftUI
//
//struct ContentView: View {
//    @State private var crownValue: Double = 0.0
//    @State private var boxOffset: CGFloat = 0.0
//    private let boxWidth: CGFloat = 20
//    private let screenWidth: CGFloat = WKInterfaceDevice.current().screenBounds.width
//    
//    var body: some View {
//        VStack {
//            Text("Crown Rotation")
//                .font(.headline)
//
//            Text(String(format: "%.2f", crownValue))
//                .font(.largeTitle)
//                .padding()
//
//            Spacer()
//
//            Rectangle()
//                .frame(width: boxWidth, height: 10)
//                .foregroundColor(.blue)
//                .offset(x: boxOffset)
//                .animation(.easeInOut, value: boxOffset) // Animate the movement
//
//            Spacer().frame(height: 50) // Add some space at the bottom
//        }
//        .focusable(true)
//        .digitalCrownRotation($crownValue, from: -1.0, through: 1.0, by: 0.01, sensitivity: .low, isContinuous: true)
//        .onChange(of: crownValue) { oldValue, newValue in
//            var moveOffset = CGFloat(0)
//            if newValue > oldValue {
//                moveOffset = CGFloat(1)
//            } else if newValue < oldValue {
//                moveOffset = CGFloat(-1)
//                
//            }
//            let newOffset = boxOffset + moveOffset
//            // Ensure the box does not move out of the screen bounds
//            if newOffset >= -(screenWidth / 2 - boxWidth / 2) && newOffset <= (screenWidth / 2 - boxWidth / 2) {
//                boxOffset = newOffset
//            }
//            print("Crown Value Changed: \(newOffset)")
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

// ##############################################################################################################################

import SwiftUI

struct ContentView: View {
    @State private var crownValue: Double = 0.0
    @State private var boxOffset: CGFloat = 0.0
    private let boxWidth: CGFloat = 20
    private let screenSize = WKInterfaceDevice.current().screenBounds.size
    private let runImages = ["run1", "run2", "run3", "run4", "run5", "run6"]
    private let flyImages = ["fly1", "fly2", "fly3", "fly4", "fly1", "fly2"]
    private let restImages = ["rest1", "rest1", "rest2", "rest3", "rest4", "rest5"]
    private let eatImages = ["eat1", "eat2", "eat3", "eat4", "eat1", "eat2"]
    let foodImages = ["applelogo", "carrot"] // 替换为你的图片名称
    @State private var foodImagesName = "applelogo"

    private let floor_height: CGFloat = 60
    private let pet_height: CGFloat = 70
    private let appleSize: CGSize = CGSize(width: 15.0, height: 15.0)
    
    @State private var idx = 1
    @State private var status = 0 // 用于区分当前是显示 runImages 还是 flyImages
    
    @State private var petsInitLocation: CGPoint
    @State private var applePosition = CGPoint(x: -100, y: -100) // 初始位置设置为屏幕外
    @State private var isFalling = false
    @State private var restTimer: Timer? = nil
    @State private var flyTimer: Timer? = nil
    @State private var eatTimer: Timer? = nil
    @State private var appleFallTimer: Timer? = nil
    @State private var resetWorkItem: DispatchWorkItem?
    
    
    var currentImages: [String] {
        switch status {
        case 1:
            return runImages
        case 2:
            return flyImages
        case 3:
            return eatImages
        default:
            return restImages // 或者根据需要返回一个默认值
        }
    }
    init() {
        self._petsInitLocation = State(initialValue: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2))
    }
    
    var body: some View {
        ZStack {
            // 背景矩形
            // 透明的捕捉手势区域
            Color.clear
                .contentShape(Rectangle()) // 确保整个区域都响应手势
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { gesture in
                            // 重置动画状态
                            eatTimer?.invalidate() // 进入其他状态时停止计时器
                            eatTimer = nil
                            applePosition = CGPoint(x: -100, y: -100)
                            resetToRestState(after: 0)
                            foodImagesName = foodImages.randomElement() ?? "applelogo"
                            applePosition = gesture.location
                            isFalling = true
                            startAppleFallImageTimer()
                        }
                )
                .frame(width: screenSize.width, height: screenSize.height - floor_height) // 覆盖整个屏幕
                .position(x: screenSize.width / 2, y: (screenSize.height - floor_height) / 2) // 居中放置
            Rectangle()
                .fill(Color(red: 81/255, green: 81/255, blue: 81/255))
                .frame(height: floor_height) // 调整高度
                .position(x: screenSize.width / 2, y: screenSize.height - (floor_height / 2))
                .gesture(
                    TapGesture()
                        .onEnded {
                            status = 2
                            idx = 0
                            startFlyImageTimer()
                        }
                )
            
            // 图像或文本
            if let image = UIImage(named: currentImages[idx]) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 保持原始比例
                    .frame(height: pet_height)
                    .offset(x: boxOffset) // 调整图像的偏移
                    .position(x: screenSize.width / 2, y: screenSize.height - floor_height - (pet_height / 2) + 5)
                    .gesture(
                        TapGesture()
                            .onEnded {
                                print("on")
                            }
                    )
            } else {
                Text("Image not found")
                    .foregroundColor(.red)
                    .position(x: screenSize.width / 2, y: screenSize.height - (floor_height / 2)) // 文本与矩形居于同一位置
            }
            
            
            if isFalling {
                Image(systemName: foodImagesName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: appleSize.width, height: appleSize.height)
                    .position(applePosition)
            }
        }
        .focusable(true)
        .digitalCrownRotation($crownValue, from: -1.0, through: 1.0, by: 0.01, sensitivity: .low, isContinuous: true)
        .onChange(of: crownValue) { oldValue, newValue in
            if let eatTimer = eatTimer {
                status = 3
            } else if let flyTimer = flyTimer {
                status = 2
            } else {
                status = 1
            }
            let petCenterY = screenSize.height - floor_height
            if isFalling && abs(applePosition.y - petCenterY) < 20 && abs(applePosition.x - (petsInitLocation.x+boxOffset)) < 10 {
                // 苹果接近宠物中心，执行 eatImages 播放
                isFalling = false // 停止检测
                status = 3
                startEatImageTimer()
            }
            if status != 3{
                var moveOffset = CGFloat(0)
                if newValue > oldValue {
                    moveOffset = CGFloat(1)
                } else if newValue < oldValue {
                    moveOffset = CGFloat(-1)
                    
                }
                let newOffset = boxOffset + moveOffset
                idx = (abs(Int(newOffset)) / 3) % 6  // 5是调整速度
                // Ensure the box does not move out of the screen bounds
                if newOffset >= -(screenSize.width / 2 - boxWidth / 2) && newOffset <= (screenSize.width / 2 - boxWidth / 2) {
                    boxOffset = newOffset
                }
                resetWorkItem?.cancel()
                
                // 创建新的延迟任务
                resetWorkItem = DispatchWorkItem {
                    resetToRestState(after: 0.2)
                }
                
                // 延迟执行 resetToRestState
                if let workItem = resetWorkItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
                }
            } else {
                resetWorkItem?.cancel()
            }
            

        }
        .onAppear {
            startRestImageTimer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func startFlyImageTimer() {
        flyTimer?.invalidate() // 如果定时器已经存在，先取消
        let interval = 0.1 // 每张图片显示的时间间隔
        var currentIteration = 0
                
        flyTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if currentIteration < flyImages.count*2 {
                idx = abs(currentIteration) % flyImages.count
                currentIteration += 1
            } else {
                // 停止定时器，并将 isRunning 设置回 true
                flyTimer?.invalidate()
                flyTimer = nil
                resetToRestState(after: 0)
            }
        }
    }
    func startRestImageTimer() {
        restTimer?.invalidate() // 如果定时器已经存在，先取消
        let interval = 0.2 // 每张图片显示的时间间隔
        var currentIteration = 0
        
        restTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if status == 0 { // 只有在rest状态下才更新图片
                idx = currentIteration % restImages.count
                currentIteration += 1
            } else {
                restTimer?.invalidate() // 进入其他状态时停止计时器
                restTimer = nil
            }
        }
        }
    func startAppleFallImageTimer() {
        appleFallTimer?.invalidate() // 如果定时器已经存在，先取消
        let interval = 0.02
        var timeElapsed: CGFloat = 0.0 // 记录时间
        let totalFallDistance = screenSize.height - floor_height - appleSize.height / 2 - applePosition.y
        let maxTime: CGFloat = 2.0 // 控制总时间长度，可以调整使下落时间合适

        appleFallTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            timeElapsed += CGFloat(interval)
            if timeElapsed < maxTime {
                // 使用二次方加速函数计算当前位置
                let progress = timeElapsed / maxTime
                let distanceFallen = totalFallDistance * pow(progress, 2)
                applePosition.y = screenSize.height - floor_height - appleSize.height / 2 - totalFallDistance + distanceFallen
                
                // 检查是否接近宠物的位置
                let petCenterY = screenSize.height - floor_height - (pet_height / 2) + 10
                if isFalling && abs(applePosition.y - petCenterY) < 10 && abs(applePosition.x - (petsInitLocation.x+boxOffset)) < 10 {
                    // 苹果接近宠物中心，执行 eatImages 播放
                    isFalling = false // 停止检测
                    status = 3
                    startEatImageTimer()
                }
            } else {
                // 到达终点时停止
                applePosition.y = screenSize.height - floor_height - appleSize.height / 2
                appleFallTimer?.invalidate()
            }
        }
    }
    func startEatImageTimer() {
        eatTimer?.invalidate() // 如果定时器已经存在，先取消
        let interval = 0.2 // 每张图片显示的时间间隔
        var currentIteration = 0
        
        eatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if currentIteration < flyImages.count*2 { // 只有在rest状态下才更新图片
                idx = currentIteration % eatImages.count
                currentIteration += 1
            } else {
                eatTimer?.invalidate() // 进入其他状态时停止计时器
                eatTimer = nil
                applePosition = CGPoint(x: -100, y: -100)
                resetToRestState(after: 0)
            }
        }
    }
    
    func resetToRestState(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            status = 0
            idx = 0
            startRestImageTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


