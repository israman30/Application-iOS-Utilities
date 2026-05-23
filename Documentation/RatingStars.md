## Rating (stars)

- **Source**: [`Utils/Utils/RatingStartsView.swift`](../Utils/Utils/RatingStartsView.swift)
- **Sample view**: [`RatingStarsSampleView` preview](../Utils/Utils/RatingStartsView.swift#L10-L133)

### Import

```swift
import Utils
```

### Use `RatingStarsView`

```swift
RatingStarsView(rating: 3.5, maxRating: 5)
    .frame(height: 28)
```

### Custom colors

```swift
RatingStarsView(
    rating: 4.0,
    maxRating: 5,
    color: .blue,
    backgroundColor: Color(.systemGray3)
)
.frame(height: 28)
```

