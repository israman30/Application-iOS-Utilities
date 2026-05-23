## Rating (hearts)

- **Source**: [`Utils/Utils/RatingHeartsView.swift`](../Utils/Utils/RatingHeartsView.swift)
- **Sample view**: [`RatingHeartsSampleView` preview](../Utils/Utils/RatingHeartsView.swift#L10-L131)

### Import

```swift
import Utils
```

### Use `RatingHeartsView`

```swift
RatingHeartsView(rating: 4.0, maxRating: 5)
    .frame(height: 28)
```

### Custom colors

```swift
RatingHeartsView(
    rating: 3.0,
    maxRating: 5,
    color: .orange,
    backgroundColor: Color(.systemGray3)
)
.frame(height: 28)
```

