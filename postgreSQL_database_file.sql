-- ======================================================
-- DATABASE CREATION
-- ======================================================

-- Optional: drop existing database before creating
-- DROP DATABASE IF EXISTS disaster_forecast;

CREATE DATABASE disaster_forecast
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;



-- ======================================================
-- USERS TABLE
-- ======================================================
CREATE TABLE public.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age > 0),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    location VARCHAR(100),
    region VARCHAR(50),
    emergency_contact VARCHAR(15),
    password TEXT NOT NULL,
    role VARCHAR(10) CHECK (role IN ('user', 'admin')) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- PROFILES TABLE
-- ======================================================
CREATE TABLE public.profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    profile_image TEXT DEFAULT 'default.jpg',
    address VARCHAR(255),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- REPORTS TABLE
-- ======================================================
CREATE TABLE public.reports (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    disaster_type VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(20) DEFAULT 'Pending',
    image_url TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- INDEXES
-- ======================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_reports_disaster_type ON reports(disaster_type);
CREATE INDEX idx_reports_status ON reports(status);

-- ======================================================
-- AUTO PROFILE CREATION FUNCTION + TRIGGER
-- ======================================================
CREATE OR REPLACE FUNCTION create_profile_for_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (user_id, address)
    VALUES (NEW.id, NEW.location);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION create_profile_for_new_user();

-- ======================================================
-- SAMPLE DATA (Optional for testing)
-- ======================================================

-- 👤 Regular User
INSERT INTO users (name, age, phone, email, location, region, emergency_contact, password, role)
VALUES ('Disha Satpute', 22, '9876543210', 'disha@example.com', 'Pune', 'Maharashtra', '9999999999', 'secure123', 'user');

-- 👑 Admin User
INSERT INTO users (name, age, phone, email, location, region, emergency_contact, password, role)
VALUES ('Admin User', 30, '9998887777', 'admin@example.com', 'Mumbai', 'Maharashtra', '7777777777', 'admin123', 'admin');

CREATE TABLE sms_alerts (
    id SERIAL PRIMARY KEY,
    disaster_type VARCHAR(100),
    message TEXT NOT NULL,
    shelter_info TEXT,
    sent_to_all BOOLEAN DEFAULT TRUE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,                        -- Unique ID for each alert
    disaster_type VARCHAR(100) NOT NULL,          -- Type of disaster (Flood, Earthquake, etc.)
    location VARCHAR(255) NOT NULL,               -- City/Village
    emergency_contact VARCHAR(20),                -- Admin or local emergency contact number
    drill_status VARCHAR(10),                     -- "Yes" or "No" for previous drill
    response_team_level INT CHECK (response_team_level BETWEEN 0 AND 10),  -- Readiness 0-10
    evacuation_needed BOOLEAN DEFAULT FALSE,      -- Whether evacuation transport needed
    kit_items TEXT,                               -- Comma-separated emergency kit items
    status VARCHAR(50) DEFAULT 'Active',          -- Active / Resolved
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Time of creation
);

--Optional — Index for Fast Filtering (by location or disaster type)

-- If you plan to filter alerts often by city or type (for dashboards, maps, etc.), add:

CREATE INDEX idx_alerts_location ON alerts(location);
CREATE INDEX idx_alerts_disaster_type ON alerts(disaster_type);

