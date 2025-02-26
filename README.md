# Rapid News

Rapid News is a Flutter-based mobile application that provides users with the latest news articles. The application fetches news from various sources and displays them in a user-friendly interface. Users can search for news, view trending articles, and bookmark their favorite news articles for later reading.

## Features

- **Trending News**: View the latest trending news articles.
- **Search**: Search for news articles by keywords.
- **Categories**: Browse news articles by categories.
- **Bookmarks**: Save your favorite news articles for later reading.
- **Pull to Refresh**: Refresh the news feed by pulling down.

## Project Structure

The project is organized into the following directories and files:

### Components

- **Day_Picker.dart**: A widget for selecting days.
- **KNavigationBar.dart**: A custom navigation bar widget.
- **KScaffold.dart**: A custom scaffold widget with additional features.
- **KSearchbar.dart**: A custom search bar widget.
- **kButton.dart**: A custom button widget.
- **kCard.dart**: A custom card widget.
- **kCarousel.dart**: A custom carousel widget.
- **kTextfield.dart**: A custom text field widget.
- **kWidgets.dart**: A collection of custom widgets.
- **Label.dart**: A custom label widget.

### Helper

- **api_config.dart**: Configuration for API endpoints.
- **appLink.dart**: Application link configurations.
- **data.dart**: Data handling utilities.
- **hive_init.dart**: Initialization for Hive database.
- **router_config.dart**: Configuration for application routing.

### Models

- **Response_Model.dart**: Model classes for API responses.

### Pages

- **Explore_UI.dart**: UI for the Explore page.
- **Home_UI.dart**: UI for the Home page.
- **News_UI.dart**: UI for displaying individual news articles.
- **Saved_UI.dart**: UI for displaying saved news articles.

### Repository

- **newsRepo.dart**: Repository for fetching news data from APIs.

### Resources

- **app_config.dart**: Application configuration settings.
- **colors.dart**: Color definitions for the application.
- **commons.dart**: Common utility functions.
- **constants.dart**: Constant values used throughout the application.
- **theme.dart**: Theme settings for the application.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
