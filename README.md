# Offline PDF Manager

A Flutter app module to manage PDF downloads, view, and deletion—all offline.

---

## 🚀 Setup Instructions

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd offline_pdf_manager
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Add your PDF files:**
   - Place your PDF files in the `assets/pdfs/` directory.
   - Make sure your `pubspec.yaml` lists these assets.

4. **Run the app:**
   ```sh
   flutter run
   ```

---

## ✨ Key Features

- **Home Screen:**  
  - Two main buttons:  
    - **Download PDF:** View all available PDFs and download them to your device (simulated).
    - **View Downloaded PDFs:** See all PDFs you have downloaded.

- **Download PDF Screen:**  
  - Lists all PDFs in the assets folder.
  - Tap a PDF to view it.
  - Download icon to add it to your downloaded list.
  - Downloaded PDFs show a green checkmark.

- **Downloaded Reports Screen:**  
  - Lists only the PDFs you have downloaded.
  - Tap to view a PDF.
  - Long-press to select multiple PDFs.
  - Delete icon to remove selected PDFs from your downloaded list.

- **Modern UI:**  
  - Card-based lists, styled Snackbars, and clear navigation.

---

## ⚠️ Limitations & Assumptions

- **Simulated Downloads:**  
  - "Downloading" a PDF means adding it to an in-app list. PDFs are not actually copied to device storage.
  - All PDFs must be present in the `assets/pdfs/` folder.

- **Persistence:**  
  - The list of downloaded PDFs is stored in memory only. It resets when the app restarts.

- **PDF Viewing:**  
  - Opening a PDF uses the device's default PDF viewer or browser via `url_launcher`.

- **No Real File System Management:**  
  - PDFs are not saved to or deleted from the device's file system—only managed within the app.

---

## 📝 Assumptions

- The app is intended for demonstration or offline use with bundled assets.
- Users have a compatible PDF viewer installed on their device.

---

## 📂 Folder Structure

```
lib/
  models/
  screens/
assets/
  pdfs/
pubspec.yaml
```

---

## 📢 Contributions

Feel free to fork and improve!

---