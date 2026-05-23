## Grids

- **Scrollable grid source**: [`Utils/Utils/GridView.swift`](../Utils/Utils/GridView.swift)
- **Scrollable grid sample view**: [`ScrollGridViewSampleView` preview](../Utils/Utils/GridView.swift#L106-L211)
- **Square grid source**: [`Utils/Utils/SquareGridView.swift`](../Utils/Utils/SquareGridView.swift)
- **Square grid sample view**: [`GridViewSampleView` preview](../Utils/Utils/SquareGridView.swift#L92-L168)

### Import

```swift
import Utils
```

## `ScrollGridView` (lazy vertical/horizontal)

```swift
ScrollGridView(.vertical, columns: 2) {
    ForEach(0..<10) { index in
        Text("Item \(index)")
            .padding(8)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(8)
    }
}
```

Horizontal (configure `rows` + `.horizontal` orientation):

```swift
ScrollGridView(.horizontal, rows: 2, spacing: 12, showsIndicators: true) {
    ForEach(0..<12) { index in
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.blue.opacity(0.15))
            .overlay(Text("Item \(index)"))
            .frame(width: 120, height: 72)
    }
}
```

## `GridView` (square cells)

```swift
GridView(items: Array(0..<9), totalCount: 9, columns: 3) { item in
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.blue.opacity(0.15))
        .overlay(Text("\(item)"))
}
```

## `SquareGridView` (legacy alias)

`SquareGridView` is a deprecated alias of `GridView`.

```swift
SquareGridView(items: Array(0..<9), totalCount: 9, columns: 3) { item in
    Color.blue.opacity(0.15).overlay(Text("\(item)"))
}
```

