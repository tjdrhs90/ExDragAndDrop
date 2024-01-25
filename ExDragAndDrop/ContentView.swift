//
//  ContentView.swift
//  ExDragAndDrop
//
//  Created by ssg on 1/25/24.
//

import SwiftUI

// 드래그 앤 드랍 (순서 변경)
struct ContentView: View {
    
    // 그냥 [Image] 배열로 하면 애니메이션이 작동하지 않고, String 같은 Hashable 데이터로 해야 애니메이션이 적용 됨.
    @State var items = ["person", "photo", "dog", "cat"]
    
    @State var draggedItem: String?
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(items, id: \.self) { item in
                Image(systemName: item)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onDrag {
                        self.draggedItem = item
                        return NSItemProvider()
                    }
                    .onDrop(
                        of: [.image],
                        delegate: DropViewDelegate(
                            item: item,
                            items: $items,
                            draggedItem: $draggedItem
                        )
                    )
            }
        }
    }
}

// https://www.codecademy.com/resources/docs/swiftui/drag-and-drop
// https://hyeondxx.medium.com/swiftui-customlist-순서-바꾸기-58ff224b1ad8
struct DropViewDelegate: DropDelegate {
    
    let item: String
    @Binding var items: [String]
    @Binding var draggedItem: String?
    
    // 드래그 할 때 아이템 우측 상단에 표시되는 이미지 설정 (이 매서드 아예 안쓰면 기본 값 copy : + 플러스 이미지)
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move) // move, cancel 은 이미지 안나옴. forbidden 는 ⛔︎ 이런 이미지 나옴
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem != item,
              let to = items.firstIndex(of: item),
              let from = items.firstIndex(of: draggedItem) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        }
    }
}

#Preview {
    ContentView()
}
