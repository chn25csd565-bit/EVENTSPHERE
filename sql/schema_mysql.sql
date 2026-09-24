-- ==============================================================
-- EventSphere College Event Management Platform Database Schema
-- Compatible with MySQL 8.x / MariaDB / H2 (MySQL Mode)
-- ==============================================================

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    college VARCHAR(150) DEFAULT 'Apex Institute of Technology',
    department VARCHAR(100) DEFAULT 'Computer Science & Engineering',
    phone VARCHAR(20),
    avatar VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(180) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    tagline VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    rules TEXT,
    schedule TEXT,
    venue VARCHAR(150) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    registration_deadline TIMESTAMP NOT NULL,
    min_team_size INT DEFAULT 1,
    max_team_size INT DEFAULT 4,
    max_capacity INT DEFAULT 100,
    current_registrations INT DEFAULT 0,
    prize_pool VARCHAR(100) DEFAULT '$5,000',
    banner_image VARCHAR(255),
    status VARCHAR(30) DEFAULT 'UPCOMING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    team_code VARCHAR(20) NOT NULL UNIQUE,
    leader_id INT NOT NULL,
    is_locked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (leader_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS team_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    role VARCHAR(20) DEFAULT 'MEMBER',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    team_id INT NULL,
    registration_code VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(30) DEFAULT 'CONFIRMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS invitations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    inviter_id INT NOT NULL,
    invitee_email VARCHAR(150) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
    FOREIGN KEY (inviter_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    team_id INT NULL,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    tech_stack VARCHAR(255) NOT NULL,
    repo_url VARCHAR(255) NOT NULL,
    demo_url VARCHAR(255),
    ppt_url VARCHAR(255),
    video_url VARCHAR(255),
    version INT DEFAULT 1,
    is_locked BOOLEAN DEFAULT FALSE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS judges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    title VARCHAR(120) NOT NULL,
    organization VARCHAR(150) NOT NULL,
    bio TEXT,
    specialization VARCHAR(200),
    avatar VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS judge_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judge_id INT NOT NULL,
    event_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(judge_id, event_id),
    FOREIGN KEY (judge_id) REFERENCES judges(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id INT NOT NULL,
    judge_id INT NOT NULL,
    criteria_innovation DECIMAL(4, 2) NOT NULL DEFAULT 0.0,
    criteria_technical DECIMAL(4, 2) NOT NULL DEFAULT 0.0,
    criteria_design DECIMAL(4, 2) NOT NULL DEFAULT 0.0,
    criteria_presentation DECIMAL(4, 2) NOT NULL DEFAULT 0.0,
    criteria_feasibility DECIMAL(4, 2) NOT NULL DEFAULT 0.0,
    total_weighted_score DECIMAL(5, 2) NOT NULL DEFAULT 0.0,
    feedback TEXT,
    is_submitted BOOLEAN DEFAULT FALSE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(submission_id, judge_id),
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (judge_id) REFERENCES judges(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    check_in_time TIMESTAMP NULL,
    UNIQUE(event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS previous_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_year INT NOT NULL,
    title VARCHAR(180) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    winner_team VARCHAR(120) NOT NULL,
    runner_up_team VARCHAR(120) NOT NULL,
    participant_count INT DEFAULT 0,
    prize_pool VARCHAR(100),
    cover_image VARCHAR(255),
    highlights TEXT
);

CREATE TABLE IF NOT EXISTS event_photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    previous_event_id INT NOT NULL,
    caption VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    aspect_ratio VARCHAR(20) DEFAULT '4:3',
    FOREIGN KEY (previous_event_id) REFERENCES previous_events(id) ON DELETE CASCADE
);
