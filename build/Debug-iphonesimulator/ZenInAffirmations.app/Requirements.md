# ZenIn Affirmations App Requirements

## Overview
ZenIn Affirmations is an iOS application designed to provide users with daily affirmations, allowing them to view, browse, record, and share positive affirmations to improve their mental well-being.

## Core Features

### Home Screen
- Display banner with rotating affirmations at 16:9 aspect ratio
- Banner background changes based on affirmation category
- Show categories in a grid layout below the banner
- Each category has a distinct color and title

### Affirmation Detail Screen
- Full-screen modal presentation when tapping on a banner
- Gradient background that matches the affirmation category
- Large, centered text displaying the affirmation
- Vertical swipe gesture to navigate between random affirmations
- Smooth transition animations when changing affirmations

### Audio Recording Functionality
- Record button to capture user reading the affirmation
- Play/stop functionality for recorded audio
- Automatic playback when revisiting previously recorded affirmations
- Long-press gesture to re-record or delete existing recordings

### Theme Options
- Three theme types: Gradient, Static Image, and Dynamic Video
- Global setting persists across app sessions
- Theme selector accessible from the detail screen

### Sharing
- Create and share image of current affirmation with background
- Standard iOS sharing sheet for distribution

## Technical Requirements

### Data Management
- Categorized affirmations loaded from JSON file
- Persistent storage for user recordings
- Default affirmations when no data is available

### Audio Features
- Record using Core Audio Format (CAF) for iOS compatibility
- Properly handle microphone permissions
- Error handling for recording and playback issues

### User Interface
- Support for light/dark mode
- Safe area considerations for modern iOS devices
- Responsive layout that works on all iPhone screen sizes
- iPad support with proper popover presentations

### Localization
- All user-facing text must be in English
- No hardcoded strings in other languages
- Prepare for future localization with proper string management

## Design Guidelines
- Modern iOS design with fluid animations
- Visual feedback for user actions
- Appropriate use of system icons
- Shadow effects on buttons for better visibility against any background
- Consistent color scheme throughout the app

## Future Enhancements
- Favorites functionality
- Daily notifications
- Widget support
- Watch app extension
- Additional theme options
- Background audio persistence 