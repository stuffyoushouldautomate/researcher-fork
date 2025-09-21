# 🚜 Bulldozer Mobile - iOS App

A sleek, premium iOS app for labor union research powered by AI. Built with SwiftUI and designed for maximum productivity on mobile devices.

## ✨ Features

### 🎯 Core Functionality
- **AI-Powered Chat**: Intelligent conversation with Bulldozer AI for labor research
- **Research Reports**: Comprehensive analysis of companies, unions, and labor conditions
- **Real-time Updates**: Live streaming responses from the backend API
- **Offline Support**: Core functionality works without internet connection

### 🎨 Premium Design
- **Minimalist UI**: Clean, distraction-free interface
- **Dark Theme**: Premium dark mode optimized for mobile
- **Smooth Animations**: Native iOS-style transitions and gestures
- **Touch Optimized**: All interactions designed for finger navigation

### 🔧 Advanced Features
- **Swipe Navigation**: Natural gesture-based navigation between chat and research
- **Smart Suggestions**: Quick action buttons for common research tasks
- **Export & Share**: Export research reports in multiple formats
- **Deep Thinking Mode**: Enhanced AI analysis for complex queries
- **Background Investigation**: Automated research gathering

## 🏗️ Architecture

### 📱 SwiftUI + MVVM
- **Views**: SwiftUI-based UI components
- **Models**: Codable data structures for API communication
- **Services**: Network layer and API integration
- **State Management**: ObservableObject for reactive UI updates

### 🌐 API Integration
- **Backend**: Connects to your deployed Railway backend
- **Real-time**: Server-Sent Events for streaming responses
- **Error Handling**: Comprehensive error management and user feedback
- **Caching**: Intelligent data caching for offline functionality

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Open `BulldozerMobile.xcodeproj` in Xcode
2. Select your development team in project settings
3. Build and run on simulator or device

### Configuration
The app automatically connects to your deployed backend at:
```
https://python-backend-production-2258.up.railway.app/api
```

## 📱 User Experience

### 🎯 Onboarding
- Welcome screen with quick action buttons
- Guided tour of key features
- Permission requests for notifications and data access

### 💬 Chat Interface
- Clean message bubbles with timestamps
- Typing indicators and loading states
- Smart suggestions and quick actions
- Expandable long messages

### 📊 Research View
- Tabbed interface (Overview, Sources, Analysis)
- Interactive risk assessment
- Source credibility indicators
- Export and sharing options

### 🎨 Visual Design
- **Colors**: Orange accent (#FF6B35) with dark backgrounds
- **Typography**: SF Pro system font with proper hierarchy
- **Spacing**: Consistent 16px grid system
- **Animations**: Spring-based transitions for natural feel

## 🔧 Technical Details

### 📦 Dependencies
- **SwiftUI**: Native iOS UI framework
- **Foundation**: Core system frameworks
- **URLSession**: Network communication
- **Combine**: Reactive programming (future enhancement)

### 🏗️ Project Structure
```
BulldozerMobile/
├── BulldozerMobileApp.swift     # App entry point
├── ContentView.swift            # Main navigation
├── Views/                       # UI Components
│   ├── ChatView.swift
│   ├── ResearchView.swift
│   ├── ChatBubbleView.swift
│   └── ResearchCardView.swift
├── Services/                    # Business Logic
│   └── APIService.swift
├── Models/                      # Data Models
│   └── Models.swift
└── Assets.xcassets/            # App Resources
```

### 🌐 API Endpoints
- `POST /api/chat/stream` - Send messages and receive streaming responses
- `GET /api/research/{id}` - Retrieve research reports
- `POST /api/research` - Create new research
- `GET /api/config` - Get app configuration

## 🎯 Key Features

### 💡 Smart Suggestions
Quick action buttons for common tasks:
- Research Company
- Find Violations  
- Union Resources

### 🔍 Research Analysis
- Risk assessment with color-coded levels
- Source credibility scoring
- Recommendation engine
- Concern identification

### 📤 Export Options
- PDF reports
- Share via iOS share sheet
- Copy to clipboard
- Save to Files app

## 🚀 Future Enhancements

### 📈 Planned Features
- [ ] Push notifications for research updates
- [ ] Offline mode with local storage
- [ ] Advanced search and filtering
- [ ] Custom research templates
- [ ] Team collaboration features
- [ ] Analytics dashboard

### 🔧 Technical Improvements
- [ ] Combine framework integration
- [ ] Core Data for local storage
- [ ] Unit and UI testing
- [ ] Accessibility improvements
- [ ] Performance optimizations

## 📄 License

Copyright © 2025 Bulldozer. All rights reserved.

## 🤝 Contributing

This is a proprietary application. For development questions or feature requests, contact the Bulldozer development team.

---

**Built with ❤️ for the labor movement**
