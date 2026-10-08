-- ============================================================================
-- LunaGuard AI Database Schema & Seed Data (FULL UPDATED SCRIPT)
-- Paste and Run this in the Supabase SQL Editor:
-- https://supabase.com/dashboard/project/qwnhgobuxfqewsjhivsm/sql
-- ============================================================================

-- ============================================================================
-- 1. Hazard Events Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.hazard_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hazard_type TEXT NOT NULL DEFAULT 'REGOLITH_DUST',
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    dust_density INTEGER NOT NULL CHECK (dust_density >= 0 AND dust_density <= 100),
    dust_velocity INTEGER NOT NULL,
    hazard_radius FLOAT NOT NULL,
    risk_score INTEGER NOT NULL CHECK (risk_score >= 0 AND risk_score <= 100),
    risk_level TEXT NOT NULL CHECK (risk_level IN ('SAFE', 'LOW', 'HIGH', 'CRITICAL')),
    confidence FLOAT NOT NULL CHECK (confidence >= 0 AND confidence <= 100),
    detected_by TEXT NOT NULL,
    detected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'MONITORING', 'RESOLVED'))
);

-- ============================================================================
-- 2. Satellites Constellation Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.satellites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    satellite_name TEXT NOT NULL,
    satellite_code TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'ONLINE' CHECK (status IN ('ONLINE', 'DEGRADED', 'OFFLINE')),
    orbit_type TEXT NOT NULL DEFAULT 'LUNAR',
    speed FLOAT NOT NULL,
    altitude FLOAT NOT NULL,
    sensor_status TEXT NOT NULL DEFAULT 'ACTIVE',
    current_target TEXT,
    last_scan TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 3. Alerts Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hazard_id UUID REFERENCES public.hazard_events(id) ON DELETE SET NULL,
    user_id UUID,
    alert_type TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('SAFE', 'LOW', 'HIGH', 'CRITICAL')),
    message TEXT NOT NULL,
    dust_coverage INTEGER,
    email TEXT,
    email_status TEXT,
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'RESOLVED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 4. Equipment Maintenance Table (With Original and Updated Data Columns)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.equipment_maintenance (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    recommended_method TEXT NOT NULL,
    cleaning_time_minutes INTEGER NOT NULL,
    cost_savings_usd INTEGER NOT NULL,

    -- Current / Live Columns
    health INTEGER NOT NULL CHECK (health >= 0 AND health <= 100),
    dust_level INTEGER NOT NULL CHECK (dust_level >= 0 AND dust_level <= 100),
    rul_hours INTEGER NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('OPTIMAL', 'CLEANING_RECOMMENDED', 'CRITICAL_DEGRADATION')),

    -- Original Pre-Cleaning Columns
    original_health INTEGER CHECK (original_health >= 0 AND original_health <= 100),
    original_dust_level INTEGER CHECK (original_dust_level >= 0 AND original_dust_level <= 100),
    original_rul_hours INTEGER,
    original_status TEXT,

    -- Updated Post-Cleaning Columns (NULL until Execute Cleaning is run)
    updated_health INTEGER CHECK (updated_health >= 0 AND updated_health <= 100),
    updated_dust_level INTEGER CHECK (updated_dust_level >= 0 AND updated_dust_level <= 100),
    updated_rul_hours INTEGER,
    updated_status TEXT,
    last_cleaned_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add columns if table already existed previously
ALTER TABLE public.equipment_maintenance
    ADD COLUMN IF NOT EXISTS original_health INTEGER,
    ADD COLUMN IF NOT EXISTS original_dust_level INTEGER,
    ADD COLUMN IF NOT EXISTS original_rul_hours INTEGER,
    ADD COLUMN IF NOT EXISTS original_status TEXT,
    ADD COLUMN IF NOT EXISTS updated_health INTEGER,
    ADD COLUMN IF NOT EXISTS updated_dust_level INTEGER,
    ADD COLUMN IF NOT EXISTS updated_rul_hours INTEGER,
    ADD COLUMN IF NOT EXISTS updated_status TEXT,
    ADD COLUMN IF NOT EXISTS last_cleaned_at TIMESTAMPTZ;

-- ============================================================================
-- 5. Tribology Experiments Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.tribology_experiments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exposure_hours INTEGER NOT NULL,
    particle_sharpness INTEGER NOT NULL,
    solar_wind_flux FLOAT NOT NULL,
    method TEXT NOT NULL,
    wear_percent INTEGER NOT NULL,
    transmittance_percent INTEGER NOT NULL,
    lifespan_multiplier TEXT NOT NULL,
    is_recommended BOOLEAN DEFAULT FALSE,
    simulated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 6. Seed Equipment Maintenance Data
-- ============================================================================
INSERT INTO public.equipment_maintenance (
    id, name, category, recommended_method, cleaning_time_minutes, cost_savings_usd,
    health, dust_level, rul_hours, status,
    original_health, original_dust_level, original_rul_hours, original_status,
    updated_health, updated_dust_level, updated_rul_hours, updated_status, last_cleaned_at
)
VALUES
    ('EQ-101', 'Primary Solar Array Alpha (Hab-1)', 'Solar Power', 'Electrostatic Dust Shield', 15, 45000, 64, 42, 128, 'CLEANING_RECOMMENDED', 64, 42, 128, 'CLEANING_RECOMMENDED', NULL, NULL, NULL, NULL, NULL),
    ('EQ-102', 'Lidar Sensor Mast 2 (Orbital Dock)', 'Optical Sensor', 'Ultrasonic Surface Vibration', 5, 18000, 89, 14, 540, 'OPTIMAL', 89, 14, 540, 'OPTIMAL', NULL, NULL, NULL, NULL, NULL),
    ('EQ-103', 'Airlock Outer Seal Cluster B', 'Life Support Seal', 'Nitrogen Gas Puff', 30, 120000, 38, 78, 18, 'CRITICAL_DEGRADATION', 38, 78, 18, 'CRITICAL_DEGRADATION', NULL, NULL, NULL, NULL, NULL),
    ('EQ-104', 'Regolith Rover Wheel Bearings', 'Rover Joint', 'Micro-Wiper Sweep', 45, 85000, 52, 61, 64, 'CLEANING_RECOMMENDED', 52, 61, 64, 'CLEANING_RECOMMENDED', NULL, NULL, NULL, NULL, NULL),
    ('EQ-105', 'Habitat Primary Heat Radiator', 'Thermal Radiator', 'Electrostatic Dust Shield', 20, 60000, 72, 31, 310, 'OPTIMAL', 72, 31, 310, 'OPTIMAL', NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    recommended_method = EXCLUDED.recommended_method,
    cleaning_time_minutes = EXCLUDED.cleaning_time_minutes,
    cost_savings_usd = EXCLUDED.cost_savings_usd,
    original_health = EXCLUDED.original_health,
    original_dust_level = EXCLUDED.original_dust_level,
    original_rul_hours = EXCLUDED.original_rul_hours,
    original_status = EXCLUDED.original_status,
    updated_at = NOW();

-- ============================================================================
-- 7. Seed Tribology Experiments Benchmarks
-- ============================================================================
INSERT INTO public.tribology_experiments (
    exposure_hours, particle_sharpness, solar_wind_flux, method, wear_percent, transmittance_percent, lifespan_multiplier, is_recommended
)
VALUES
    (180, 85, 1.2, 'Unprotected Baseline', 88, 12, '1.0x', FALSE),
    (180, 85, 1.2, 'Electrostatic Dust Shield (EDS)', 17, 83, '5.2x', TRUE),
    (180, 85, 1.2, 'Ultrasonic Surface Vibration (USV)', 34, 62, '3.1x', FALSE),
    (180, 85, 1.2, 'Nitrogen Gas Puff & Wiper', 47, 49, '2.4x', FALSE);

-- ============================================================================
-- 8. Seed Satellites Fleet
-- ============================================================================
INSERT INTO public.satellites (satellite_name, satellite_code, status, orbit_type, speed, altitude, sensor_status, current_target, last_scan)
VALUES
    ('Luna-Sat 01', 'LUNA-SAT-01', 'ONLINE', 'LUNAR', 1.62, 100, 'ACTIVE', 'Shackleton Crater Sector', NOW()),
    ('Luna-Sat 02', 'LUNA-SAT-02', 'ONLINE', 'LUNAR', 1.68, 120, 'ACTIVE', 'South Pole-Aitken Plume Lock', NOW()),
    ('Luna-Sat 03', 'LUNA-SAT-03', 'ONLINE', 'LUNAR', 1.55, 110, 'ACTIVE', 'Malapert Mountain Base', NOW()),
    ('Luna-Sat 04', 'LUNA-SAT-04', 'ONLINE', 'LUNAR', 1.60, 115, 'ACTIVE', 'Earth LEO High-Gain Relay', NOW())
ON CONFLICT (satellite_code) DO UPDATE SET
    status = EXCLUDED.status,
    current_target = EXCLUDED.current_target,
    last_scan = NOW();

-- ============================================================================
-- 9. Row Level Security (RLS) & Access Policies
-- ============================================================================
ALTER TABLE public.hazard_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.satellites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment_maintenance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tribology_experiments ENABLE ROW LEVEL SECURITY;

-- Drop and re-create read/write policies safely
DROP POLICY IF EXISTS "Allow public read access to hazard_events" ON public.hazard_events;
CREATE POLICY "Allow public read access to hazard_events" ON public.hazard_events FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public insert to hazard_events" ON public.hazard_events;
CREATE POLICY "Allow public insert to hazard_events" ON public.hazard_events FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read access to satellites" ON public.satellites;
CREATE POLICY "Allow public read access to satellites" ON public.satellites FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public update to satellites" ON public.satellites;
CREATE POLICY "Allow public update to satellites" ON public.satellites FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Allow public read access to alerts" ON public.alerts;
CREATE POLICY "Allow public read access to alerts" ON public.alerts FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public insert to alerts" ON public.alerts;
CREATE POLICY "Allow public insert to alerts" ON public.alerts FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read access to equipment_maintenance" ON public.equipment_maintenance;
CREATE POLICY "Allow public read access to equipment_maintenance" ON public.equipment_maintenance FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public update to equipment_maintenance" ON public.equipment_maintenance;
CREATE POLICY "Allow public update to equipment_maintenance" ON public.equipment_maintenance FOR UPDATE USING (true);
DROP POLICY IF EXISTS "Allow public insert to equipment_maintenance" ON public.equipment_maintenance;
CREATE POLICY "Allow public insert to equipment_maintenance" ON public.equipment_maintenance FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read access to tribology_experiments" ON public.tribology_experiments;
CREATE POLICY "Allow public read access to tribology_experiments" ON public.tribology_experiments FOR SELECT USING (true);
