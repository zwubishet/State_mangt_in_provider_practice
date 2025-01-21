Implement a photo gallery with tagging and filtering functionality using Flutter and Provider.

- Added `GalleryModel` with state management for photo tagging and filtering.
- Introduced `PhotoState` class to represent individual photo states, including tags, selection, and visibility.
- Implemented `Gallery` screen with a grid view of images and a drawer menu for tag-based filtering.
- Added tagging feature: long-press to select photos and assign tags.
- Used `ChangeNotifierProvider` for state management to simplify widget tree updates.
- Included `Photo` widget for displaying individual photos with optional selection controls.
