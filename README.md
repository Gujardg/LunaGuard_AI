# 🌙 LunaGuard AI

**LunaGuard AI** is an AI-powered lunar safety and monitoring platform designed to detect, analyze, and predict **lunar regolith (moon dust) hazards** that can affect astronauts, spacecraft, satellites, and lunar equipment.

The platform combines **real-time hazard monitoring, predictive forecasting, risk analysis, equipment degradation simulation, safe-route decision support, maintenance planning, and automated alerts** into a single dashboard.

## 🎯 Problem Statement

Lunar regolith is highly abrasive and can create serious operational challenges during lunar exploration. Dust accumulation can affect:

- 🛰️ Sensors and satellite systems
- ☀️ Solar panel efficiency
- 🚀 Exploration equipment
- 🧑‍🚀 Astronaut operations
- 🔧 Mechanical components
- 👁️ Visibility and monitoring systems

LunaGuard AI provides a centralized system to monitor these risks and support safer lunar exploration decisions.

## ✨ Key Features

### 📊 Dashboard
Provides an overview of lunar environmental conditions, hazards, system status, and important operational metrics.

### 🔮 Predictive Forecasting
Predicts future lunar dust accumulation and risk levels for different lunar regions based on environmental parameters.

### 🗺️ Hazard Map
Displays detected lunar dust hazards, their locations, risk scores, severity levels, and affected regions.

### 🌑 Lunar Dust Simulation
Simulates regolith dust behavior and visualizes lunar dust conditions using interactive visual elements.

### 🔬 Tribology & Equipment Degradation
Analyzes how lunar dust exposure can affect equipment and compares different dust-mitigation approaches.

### 🔧 Maintenance Scheduler
Helps identify equipment requiring maintenance and supports preventive maintenance planning.

### 📈 Analytics
Provides analytical views of hazard conditions, equipment performance, risk levels, and system data.

### 📜 Hazard History
Maintains historical hazard and alert information for monitoring and analysis.

### 🤖 AI Recommendations
Provides risk-based recommendations and suggested actions for different hazard conditions.

### 🚨 Automated Alerts
The backend supports sending risk alerts through configured email/SMS services when critical conditions are detected.

### 🔐 Authentication
Uses Supabase authentication for secure user login and session management.

## 🛠️ Technology Stack

### Frontend
- React
- TypeScript
- Vite
- Tailwind CSS
- Framer Motion
- Three.js
- Lucide React

### Backend
- Python
- FastAPI
- HTTPX

### Database & Authentication
- Supabase
- PostgreSQL

### Deployment
- Vercel

## 📁 Project Structure

```text
LunaGuard_AI_Project/
│
├── src/
│   ├── components/
│   │   ├── Dashboard.tsx
│   │   ├── PredictiveForecasting.tsx
│   │   ├── HazardMap.tsx
│   │   ├── LunarDustMap.tsx
│   │   ├── EquipmentDegradation.tsx
│   │   ├── MaintenanceScheduler.tsx
│   │   ├── Analytics.tsx
│   │   └── HazardHistory.tsx
│   │
│   ├── lib/
│   │   ├── api.ts
│   │   ├── aiRecommendation.ts
│   │   └── supabase.ts
│   │
│   ├── App.tsx
│   └── main.tsx
│
├── alert-service/
│   ├── app.py
│   ├── requirements.txt
│   └── .env.example
│
├── supabase_schema.sql
├── package.json
├── vite.config.ts
└── README.md
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd LunaGuard_AI_Project
```

### 2. Install Frontend Dependencies

```bash
npm install
```

### 3. Configure Environment Variables

Create a `.env` file and add the required Supabase configuration.

Example:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_ALERT_SERVICE_URL=your_backend_url
```

> **Never upload `.env` files or Supabase service-role/secret keys to GitHub.**

### 4. Run the Frontend

```bash
npm run dev
```

The application will be available at the local URL shown in the terminal.

## 🐍 Backend Setup

Navigate to the backend:

```bash
cd alert-service
```

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Run the FastAPI service:

```bash
uvicorn app:app --reload --port 8000
```

The backend provides APIs for:

- Predictive forecasting
- Tribology simulation
- Safe-route analysis
- Maintenance analysis
- Risk alerts
- Health monitoring

## 🏗️ Build the Project

```bash
npm run build
```

The production files are generated in:

```text
dist/
```

## 🌐 Deployment

The frontend can be deployed using **Vercel**.

```bash
npm install -g vercel
vercel login
vercel
```

For a production deployment:

```bash
vercel --prod
```

## 🔒 Security

- Environment variables are used for sensitive configuration.
- Supabase authentication manages user sessions.
- Backend service credentials should remain server-side.
- Secret keys should never be committed to GitHub.

## 🔮 Future Scope

- Integration with real lunar satellite telemetry
- Advanced machine-learning prediction models
- Real-time NASA/space-agency data integration
- More accurate lunar terrain and hazard mapping
- IoT-based equipment monitoring
- Advanced astronaut route optimization
- Mobile application
- Improved AI-based decision support

## 👩‍💻 Project

**LunaGuard AI — Lunar Regolith Hazard Intelligence & Decision Support Platform**

Built using **React, TypeScript, Python, FastAPI, Supabase, Three.js, and AI-driven analytics.**

---

⭐ **If you find this project useful, consider giving the repository a star!**
