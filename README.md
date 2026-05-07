# 📚 Book Finder

A Flutter app for discovering books and managing a personal reading list.


## Features

- **Search** — query the Google Books API by title, author, or keyword
- **Book Detail** — view cover, description, page count, publish year, and genres
- **Reading List** — save books locally so your list persists between sessions
- **Read / Unread** — mark books as read with a single tap
- **Remove** — delete books from your list with a confirmation dialog
- **Stats** — see your total, read, and to-read counts at a glance


## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- A free [Google Books API key](https://console.cloud.google.com)

### Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/BookHub.git
   cd BookHub
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the project root:
   ```
   GOOGLE_BOOKS_API_KEY=your_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

