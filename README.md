# Revl - Masked Face Recognition System 🎭

> **Semester 5 PBL Project - Group 7**

**Revl** is a robust Face Recognition system designed specifically to handle masked faces. It utilizes a hybrid approach focusing on the eye region to accurately identify individuals even when they are wearing medical masks or other face coverings. The system consists of a high-performance Python backend and a user-friendly Flutter mobile application.

## 🌟 Key Features

*   **Mask-Robust Recognition:** Specialized algorithms (KNN + PCA + Multi-scale LBP) trained to recognize faces primarily from the eye region.
*   **Real-time Performance:** Fast inference times suitable for live applications.
*   **Dual Interface:**
    *   **Mobile App:** A clean, native experience for scanning and recognition on the go.
    *   **Web Interface:** A Gradio-based web UI for testing and easy access.
*   **Dockerized:** Fully containerized backend for easy deployment on any platform (including Hugging Face Spaces).

## 🏗️ Architecture

The project is divided into two main components:

1.  **Mobile App (`/mobile`)**:
    *   Built with **Flutter** (Dart).
    *   Captures images via camera or gallery.
    *   Communicates with the backend REST API.
    *   Handles user feedback and displays recognition results.

2.  **Backend (`/revl-maskedface-recognition`)**:
    *   Built with **Python** (FastAPI & Gradio).
    *   **Core Logic:** Uses `scikit-learn` for KNN/PCA and `scikit-image` for LBP feature extraction.
    *   **API:** Exposes endpoints like `/warmup`, `/health`, and `/recognize`.
    *   **UI:** Provides a Gradio dashboard for model interaction and testing.

## 🚀 Getting Started

### Prerequisites

*   **Docker** (Recommended for backend)
*   **Flutter SDK** (For mobile app)
*   **Python 3.10+** (If running backend without Docker)

---

### 1. Backend Setup

We recommend using Docker to ensure a consistent environment.

**Option A: Using Docker**

```bash
# Navigate to the backend directory
cd revl-maskedface-recognition

# Build the image
docker build -t revl-backend .

# Run the container (Maps port 7860)
docker run -p 7860:7860 revl-backend
```

**Option B: Manual Setup**

```bash
cd revl-maskedface-recognition

# Install dependencies
pip install -r requirements.txt

# Run the server
python app.py
```

*The backend will be available at `http://localhost:7860`*

---

### 2. Mobile App Setup

Ensure your backend is running before starting the app.

```bash
# Navigate to the mobile directory
cd mobile

# Get dependencies
flutter pub get

# Run the app (ensure you have an emulator or device connected)
flutter run
```

> **Note:** If testing on a physical device, ensure the mobile app points to your computer's local IP address instead of `localhost`. Check `config.dart` or `api_service.dart` if connectivity issues arise.

## 📖 Usage Guide

1.  **Warm Up:** When the backend starts, it may need to load models. The mobile app automatically handles this, or you can hit the `/warmup` endpoint.
2.  **Recognize:**
    *   **Mobile:** Point the camera at a face (masked or unmasked) and tap capture.
    *   **Web:** Upload an image to the Gradio interface at `http://localhost:7860`.

## 🛠️ Technology Stack

*   **Frontend:** Flutter, Dart
*   **Backend:** Python, FastAPI, Gradio, Uvicorn
*   **ML/CV:** Scikit-learn, Scikit-image, Pillow, NumPy, MediaPipe (for detection)
*   **DevOps:** Docker

## 👥 Authors

**PBL Group 7**
*   *Haikal Muhammad Rafli*
*   *Vincentius Leonanda Prabowo*
*   *[Other Team Members]*
*   *Nahdia Putri Safira*
*   *M. Firmansyah*

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
