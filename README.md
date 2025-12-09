# 📘 Simple Note App – Flutter
Link video demo: https://docs.google.com/spreadsheets/d/1Ffm7vp3uYPSdrpAyikwxahYx0T5YougJC7T_QNgjFJg/edit?usp=sharing
A simple and modern note-taking app built with Flutter.  
The app is easy to use, fast, and supports dark mode, tags, password protection, and local storage.

---

## 📱 Screenshots

> Replace the links with your own uploaded images.

### Home Screen – Dark Mode
![Home Dark](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689223/Home_Dark_af3er3.png)

### Home Screen – Light Mode
![Home Light](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689502/Home_Light_r5nhxw.png)

### Note Editor
![Editor](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689503/Note_Editer_mq2igg.png)

### Password Dialog
![Password](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689503/Note_Password_enhtnn.png)

---

## ✨ Features

- Create, edit, and delete notes  
- Save notes locally using SQLite  
- Search notes by keyword  
- Filter notes by:
  - Tag
  - Date range  
- Pin important notes  
- Lock notes with a password  
- Create custom tags with custom colors  
- Light / Dark theme switch  
- Toast messages for:
  - Create success
  - Update success
  - Wrong password
  - Delete success  
- Simple and clean UI  

---

## 🛠 Technologies

| Tool | Purpose |
|------|---------|
| Flutter | Main framework |
| Provider | State management |
| SQLite (sqflite) | Local database |
| Intl | Date formatting |
| Material Design | UI styling |

---

## 📂 Project Structure

```
lib/
 │── main.dart
 │
 ├── models/
 │    └── note.dart
 │
 ├── database/
 │    └── db_helper.dart
 │
 ├── providers/
 │    ├── note_provider.dart
 │    └── theme_provider.dart
 │
 ├── screens/
 │    ├── home_page.dart
 │    └── note_editor_screen.dart
 │
 └── widgets/
      └── note_card.dart
```

---

## 🚀 How to Run

### 1. Install Flutter  
https://docs.flutter.dev/get-started/install

### 2. Clone the project
```
git clone https://github.com/KimTuyen2505/simple-note-app-kimtuyen.git
cd simple-note-app-kimtuyen
```

### 3. Install packages
```
flutter pub get
```

### 4. Run the app
```
flutter run
```

---

## 📸 Screenshots

![Home Dark](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689223/Home_Dark_af3er3.png)

### Home Screen – Light Mode
![Home Light](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689502/Home_Light_r5nhxw.png)

### Note Editor
![Editor](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689503/Note_Editer_mq2igg.png)

### Password Dialog
![Password](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689503/Note_Password_enhtnn.png)

### Tag Picker  
![Tag Picker](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689822/Home_Tag_iufk1o.png)

### Date Picker  
![Date Picker](https://res.cloudinary.com/dpuy2k0yr/image/upload/v1764689822/Home_DatePicker_nflawu.png)

---

## 💬 Feedback

If you want to improve this project:
- Create an issue  
- Open a pull request  
- Suggest new ideas  

This app is created for learning Flutter, Provider, SQLite, and UI design.

