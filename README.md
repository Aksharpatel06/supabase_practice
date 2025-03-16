# 🚀 **Flutter + Supabase App**  

A beautiful **Flutter app** powered by **Supabase** for authentication and database management. Users can **sign up, log in, create posts, and add comments** seamlessly.

---

## 📌 **Features**  
✨ **User Authentication** (Sign up, Login, Logout)  
📝 **Create & View Posts** (Linked to users)  
💬 **Add Comments** (Foreign key relationships)  
⚡ **Supabase as Backend** (Database & Authentication)  
🎨 **Modern UI with Flutter**  

---

## 🏗 **Database Schema**  
### **🟢 Users Table (`users`)**  
Stores user information.  

| Column Name  | Data Type   | Constraints         |
|-------------|------------|---------------------|
| `id`        | `UUID`      | Primary Key        |
| `email`     | `TEXT`      | Unique, Not Null   |
| `name`      | `TEXT`      | Nullable           |
| `created_at` | `TIMESTAMP` | Default: `now()`   |

---

### **🟡 Posts Table (`posts`)**  
Stores user-created posts.  

| Column Name  | Data Type   | Constraints                  |
|-------------|------------|------------------------------|
| `id`        | `UUID`      | Primary Key                  |
| `user_id`   | `UUID`      | Foreign Key → `users(id)`    |
| `title`     | `TEXT`      | Not Null                     |
| `content`   | `TEXT`      | Not Null                     |
| `created_at` | `TIMESTAMP` | Default: `now()`            |

---

### **🔴 Comments Table (`comments`)**  
Stores comments on posts.  

| Column Name  | Data Type   | Constraints                  |
|-------------|------------|------------------------------|
| `id`        | `UUID`      | Primary Key                  |
| `post_id`   | `UUID`      | Foreign Key → `posts(id)`    |
| `user_id`   | `UUID`      | Foreign Key → `users(id)`    |
| `comment`   | `TEXT`      | Not Null                     |
| `created_at` | `TIMESTAMP` | Default: `now()`            |

---

## 🛠 **Setup & Installation**  
### **1️⃣ Clone the Repository**  
```sh
git clone https://github.com/your-username/flutter-supabase-app.git
cd flutter-supabase-app
```

### **2️⃣ Install Dependencies**  
```sh
flutter pub get
```

### **3️⃣ Configure Supabase**  
1. Create a [Supabase](https://supabase.com/) project  
2. Enable **Email/Password Authentication**  
3. Copy your **Project URL** & **Anon Key**  
4. Add them to your Flutter project (`lib/config.dart`)  

### **4️⃣ Run the App**  
```sh
flutter run
```

