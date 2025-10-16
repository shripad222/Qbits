
# 🩸 Blood Bank Management System

A **Flutter + Supabase** application designed to digitalize and streamline the process of **blood donation, request, and management** between **donors**, **hospitals**, and **blood banks**.  
The app ensures real-time tracking of blood inventory, donor activity, and blood request flow using a modular and scalable architecture.

---

## 🚀 Features

### 🔹 General Features
- Unified **Inventory Management System** for blood banks and hospitals.
- Role-based access for:
  - Blood Banks
  - Hospitals
  - Individual Donors
- Real-time synchronization powered by **Supabase** (PostgreSQL + Auth + Storage).
- **Notifications** for requests, appointments, and confirmations.
- Clean modular structure to ensure each file is maintainable (<400 lines).

---

## 🧠 System Overview

### 🩸 Blood Bank Flow
- Blood banks can list **blood donation camps**.
- Users (donors) can **register for camps** or donate individually.
- Blood banks can manage **collection records**, including:
  - Camps  
  - Individual donations  
  - Blood transportation to hospitals
- Blood banks receive requests from hospitals:
  - Blood requests
  - Volunteer support
  - Urgent transfusion notifications
- **Dashboard**:
  - Total blood units collected
  - Requests fulfilled
  - Active donation events

---

### 👤 Individual Donor Flow
- Donors register with:
  - Name, contact info, blood group, location, health details
- View donation **cool-down time**, **recent donations**, and **history**
- Book **voluntary donation appointments**
- Register for upcoming **blood donation camps**
- Receive confirmations from blood banks or hospitals
- **Dashboard** displays:
  - Total lives saved
  - Total liters donated
  - Donation reminders

---

### 🏥 Hospital Flow
- Register with name, location, contact info, and linked blood bank (if any)
- Hospitals with an internal blood bank get a **dashboard**:
  - Available stock
  - Faulty/expired stock
  - Alerts for low stock
  - Search/filter options
- Hospitals can:
  - Request blood from nearby banks or donors
  - View donation history and responses
  - Receive **notifications** for approved or declined requests

---

## 🧩 System Modules (Modular Architecture)

Each module follows **clean architecture** and **MVVM** pattern for scalability.

```

lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   ├── services/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── usecases/
├── presentation/
│   ├── auth/
│   ├── dashboard/
│   ├── donor/
│   ├── hospital/
│   ├── bloodbank/
│   ├── requests/
│   └── common/
└── routes/
└── app_routes.dart

````

### Key Design Rules:
- Each feature has its own folder.
- UI, logic, and service layers are separated.
- No file should exceed **400 lines**.
- Reusable components live in `core/widgets`.
- Shared logic (auth, utils) lives in `core/services`.

---

## 🗄️ Database Design (Supabase)

### Tables

#### `users`
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| name | text | Full name |
| email | text | Unique user email |
| role | text | `donor`, `hospital`, or `bloodbank` |
| phone | text | Contact number |
| blood_group | text | Donor blood type |
| location | text | Address or coordinates |
| last_donation | timestamp | Last donation date |
| health_status | text | Basic health info |

#### `blood_banks`
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| name | text | Name of blood bank |
| license_no | text | Accreditation or license number |
| email | text | Contact email |
| phone | text | 24/7 contact number |
| address | text | Physical location |
| service_area | text | Operational area |
| donation_camps | boolean | Whether camps are organized |
| parent_org | text | Parent organization |

#### `hospitals`
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| name | text | Hospital name |
| email | text | Contact email |
| phone | text | Contact number |
| address | text | Physical location |
| blood_bank_linked | boolean | Has own blood bank? |
| available_stock | json | Blood stock by type |
| fault_stock | json | Expired/faulty blood |

#### `requests`
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| requester_id | uuid | Hospital or user making the request |
| blood_type | text | Requested blood type |
| quantity | int | Units requested |
| status | text | `pending`, `approved`, `declined`, `completed` |
| created_at | timestamp | Request timestamp |

---

## ⚙️ Setup Instructions

### 1️⃣ Prerequisites
- Flutter (latest stable)
- Dart SDK
- Supabase account + project
- VSCode or Android Studio

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/blood-bank-system.git
cd blood-bank-system
````

### 3️⃣ Install Dependencies

```bash
flutter pub get
```

### 4️⃣ Environment Variables

Create a `.env` file in the root directory and add your Supabase credentials:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 5️⃣ Run the App

```bash
flutter run
```

---

## 🧠 Tech Stack

| Layer            | Technology                           |
| ---------------- | ------------------------------------ |
| Frontend         | Flutter (Dart)                       |
| Backend          | Supabase (PostgreSQL, Auth, Storage) |
| State Management | Riverpod / Provider                  |
| Architecture     | MVVM + Modular Design                |
| Authentication   | Supabase Auth (Email, OTP)           |
| Database         | Supabase PostgreSQL                  |
| Hosting          | Supabase / Vercel (Web)              |

---

## 🧪 Testing

Run all widget and integration tests:

```bash
flutter test
```

---

## 📊 Future Enhancements

* AI-based donor-hospital matching
* Geo-location for nearest donors
* Analytics dashboard (lives saved, donation trends)
* SMS/Email notifications via Supabase Edge Functions
* Multi-language support
* Dark mode UI

---

## 🧑‍💻 Contributors

| Name         | Role               | GitHub                                           |
| ------------ | ------------------ | ------------------------------------------------ |
| Your Name    | Flutter Developer  | [@yourhandle](https://github.com/yourhandle)     |
| Collaborator | Backend (Supabase) | [@collaborator](https://github.com/collaborator) |

---

## 🛡️ License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for more details.

---

## ❤️ Acknowledgements

Special thanks to all donors, hospitals, and organizations saving lives every day.

> “You don’t have to be a doctor to save a life. Sometimes, you just have to roll up your sleeve.” 🩸

---

```

---

Would you like me to also generate a **folder-by-folder code template** (with boilerplate Flutter + Supabase setup) that matches this README?  
It’ll give you the starting `.dart` files for models, services, and UIs so you can just plug in logic.
```
