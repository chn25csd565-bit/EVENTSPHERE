-- ==============================================================
-- EventSphere Seed Data
-- Demo credentials:
-- Admin:   admin@eventsphere.edu   / Admin@123
-- Judge:   judge.alan@eventsphere.edu / Judge@123
-- Judge:   judge.grace@eventsphere.edu / Judge@123
-- Student: alex.chen@student.edu   / Student@123
-- Student: maya.patel@student.edu  / Student@123
-- Student: sarah.kim@student.edu   / Student@123
-- Student: david.lee@student.edu   / Student@123
-- ==============================================================

-- 1. USERS
INSERT INTO users (id, name, email, password_hash, role, college, department, phone, avatar) VALUES
(1, 'Admin Director Dr. Robert Vance', 'admin@eventsphere.edu', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN', 'Apex Institute of Technology', 'Dean of Student Affairs', '+1-555-0100', 'assets/images/avatars/admin.jpg'),
(2, 'Prof. Alan Turing', 'judge.alan@eventsphere.edu', 'a123210f9ac4a43180bb4e2baa2b078cbfe3057b3bf03b24e1399c134a844b56', 'JUDGE', 'Apex Institute of Technology', 'Computer Science & AI', '+1-555-0101', 'assets/images/avatars/judge1.jpg'),
(3, 'Dr. Grace Hopper', 'judge.grace@eventsphere.edu', 'a123210f9ac4a43180bb4e2baa2b078cbfe3057b3bf03b24e1399c134a844b56', 'JUDGE', 'Global Tech Ventures', 'Senior System Architect', '+1-555-0102', 'assets/images/avatars/judge2.jpg'),
(4, 'Alex Chen', 'alex.chen@student.edu', 'b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54', 'STUDENT', 'Apex Institute of Technology', 'Computer Science & Engineering', '+1-555-0103', 'assets/images/avatars/student1.jpg'),
(5, 'Maya Patel', 'maya.patel@student.edu', 'b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54', 'STUDENT', 'Apex Institute of Technology', 'Data Science & AI', '+1-555-0104', 'assets/images/avatars/student2.jpg'),
(6, 'Sarah Kim', 'sarah.kim@student.edu', 'b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54', 'STUDENT', 'Apex Institute of Technology', 'Software Engineering', '+1-555-0105', 'assets/images/avatars/student3.jpg'),
(7, 'David Lee', 'david.lee@student.edu', 'b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54', 'STUDENT', 'Apex Institute of Technology', 'Information Technology', '+1-555-0106', 'assets/images/avatars/student4.jpg'),
(8, 'Rohan Sharma', 'rohan.sharma@student.edu', 'b2a1f4fd0a460606b34c8913e2981dac8d2e283d778aba586c416ee2629bfa54', 'STUDENT', 'Apex Institute of Technology', 'Electronics & Comm. Eng', '+1-555-0107', 'assets/images/avatars/student5.jpg');

-- 2. JUDGES PROFILE
INSERT INTO judges (id, user_id, title, organization, bio, specialization, avatar) VALUES
(1, 2, 'Chair of AI & Intelligent Systems', 'Apex University', '20+ years leading cutting-edge research in distributed algorithms, neural architectures, and distributed systems.', 'Artificial Intelligence, Distributed Systems, Cloud Computing', 'assets/images/avatars/judge1.jpg'),
(2, 3, 'Principal Engineering Director', 'Global Tech Ventures', 'Pioneering contributor in compiler design, resilient microservices, and student hackathon mentorship worldwide.', 'Systems Architecture, Security, Software Engineering', 'assets/images/avatars/judge2.jpg');

-- 3. EVENTS
INSERT INTO events (id, title, slug, category, tagline, description, rules, schedule, venue, start_date, end_date, registration_deadline, min_team_size, max_team_size, max_capacity, current_registrations, prize_pool, banner_image, status) VALUES
(1, 'HackSphere 2026: National Hackathon', 'hacksphere-2026', 'Hackathon', 'Build resilient AI, Web3, and GreenTech solutions in a 36-hour sprint.', 'HackSphere is our annual flagship national-level hackathon bringing together over 600 top developers, designers, and innovators. Compete across three tracks: Next-Gen AI Agents, Sustainable Climate Tech, and Decentralized Infrastructure. Receive mentorship from top tech companies, enjoy non-stop caffeine and food, and pitch directly to venture capitalists.', '1. Teams must consist of 2 to 4 members.\n2. All code must be written during the hackathon hours.\n3. Open-source libraries are permitted, but core project logic must be novel.\n4. GitHub repository link and working prototype demo link are mandatory for submission.', 'Day 1:\n- 09:00 AM: Check-in & Breakfast\n- 10:30 AM: Opening Ceremony & Problem Statements\n- 12:00 PM: Hacking Begins\n- 07:00 PM: Mentor Checkpoint Round 1\nDay 2:\n- 12:00 AM: Midnight Midnight Challenge\n- 08:00 AM: Mentor Checkpoint Round 2\n- 04:00 PM: Submissions Close\n- 05:30 PM: Grand Pitch & Awards', 'Grand Auditorium & Innovation Labs B1-B4', '2026-10-15 09:00:00', '2026-10-16 18:00:00', '2026-10-10 23:59:59', 2, 4, 150, 4, '$10,000 + Cloud Credits', 'assets/images/events/hacksphere2026.jpg', 'UPCOMING'),

(2, 'CodeCraft Algorithmic Battle', 'codecraft-sprint', 'Technical', 'Fast-paced competitive programming and algorithmic puzzles.', 'Put your algorithmic mastery to the test in this intense 3-hour speed coding showdown. Solve escalating challenges ranging from dynamic programming and graph theory to computational geometry. Real-time test-case evaluation and dynamic score decay for delayed submissions.', '1. Individual competition only.\n2. Supported languages: Java, C++, Python, Go.\n3. Plagiarism check run automatically after the contest.\n4. Decisions by the technical jury are final.', 'Round 1 (Warmup): 14:00 - 14:30\nRound 2 (Main Battle): 14:30 - 17:00\nResult Announcement: 17:30', 'Computing Center Lab 301', '2026-09-28 14:00:00', '2026-09-28 18:00:00', '2026-09-27 20:00:00', 1, 1, 80, 2, '$2,500 Cash Prize', 'assets/images/events/codecraft.jpg', 'ONGOING'),

(3, 'DesignMatrix UI/UX Jam', 'designmatrix-jam', 'Technical', 'Design human-centric interfaces for complex autonomous products.', 'A 24-hour design sprint for UI/UX enthusiasts, product thinkers, and front-end crafters. Transform ambiguous real-world friction into intuitive, accessible, and breathtaking mobile & desktop application experiences using Figma and interactive prototypes.', '1. Teams of 1 to 3 participants.\n2. Must provide Figma source link with interactive component prototype.\n3. Include a 3-minute Loom walkthrough and design rationale case study.', 'Phase 1: Design Prompt Released at 10:00 AM\nPhase 2: User Flow & Wireframe Submission at 04:00 PM\nPhase 3: High-Fidelity Prototype Deadline at 10:00 AM next day', 'Design Studio & Media Center Room 102', '2026-10-22 10:00:00', '2026-10-23 12:00:00', '2026-10-20 23:59:59', 1, 3, 50, 1, '$3,000 + Figma Subscriptions', 'assets/images/events/designmatrix.jpg', 'UPCOMING'),

(4, 'CloudScale Architecture Summit', 'cloudscale-summit', 'Workshop', 'Hands-on enterprise cloud architecture and microservices masterclass.', 'A full-day intensive workshop conducted by senior cloud architects from leading tech unicorns. Learn high-throughput Kafka streaming, Docker/Kubernetes orchestration, zero-trust security meshes, and serverless architectures with hands-on AWS sandboxes provided.', '1. Bring your personal laptop with Git and Docker installed.\n2. AWS Sandboxes provided free of charge.\n3. Certificate of Completion awarded upon lab capstone sign-off.', '09:00 AM: Container Foundations\n11:30 AM: Kubernetes in Production\n02:00 PM: Kafka Event Streams\n04:30 PM: Capstone Lab Challenge', 'Seminar Hall Alpha', '2026-11-05 09:00:00', '2026-11-05 17:30:00', '2026-11-03 23:59:59', 1, 1, 120, 0, 'Exclusive Cloud Certifications', 'assets/images/events/cloudscale.jpg', 'UPCOMING'),

(5, 'CyberShield CTF Invitational', 'cybershield-ctf', 'Technical', 'Capture the Flag challenge across Web, Reverse Engineering & Cryptography.', 'Test your ethical hacking abilities in an adrenaline-pumping jeopardy-style CTF. Exploit vulnerabilities in web applications, analyze compiled binaries, break cryptographic ciphers, and investigate memory dumps in a secure isolated arena.', '1. Teams of 2 to 3 members.\n2. Strict rule against attacking contest infrastructure.\n3. Flag sharing between teams results in immediate disqualification.', '10:00 AM: Infrastructure Access Open\n01:00 PM: First Blood Bonus Round\n06:00 PM: Flag Submission Close\n06:30 PM: Write-up Verification', 'Network Security Center Lab 4', '2026-11-12 10:00:00', '2026-11-12 19:00:00', '2026-11-10 23:59:59', 2, 3, 60, 0, '$4,000 Bug Bounty Pool', 'assets/images/events/cybershield.jpg', 'UPCOMING'),

(6, 'PulseFest: Battle of the Bands', 'pulsefest-bands', 'Cultural', 'Electrifying college music festival celebrating original rock, indie & fusion.', 'Apex Institute’s biggest cultural celebration of music and performing arts. Campus bands and solo artists from across 30 universities compete across acoustic, metal, indie-pop, and world fusion categories before an open-air crowd of 3,000 spectators.', '1. Maximum 8 members per band.\n2. Slot duration: 20 minutes including sound check.\n3. At least one original composition mandatory.', '05:00 PM: Gates Open & Acoustic Prelims\n07:00 PM: Rock & Electric Showdown\n10:30 PM: Celebrity Guest Act & Trophy Ceremony', 'Open Air Amphitheatre', '2026-11-20 17:00:00', '2026-11-20 23:00:00', '2026-11-15 23:59:59', 3, 8, 20, 0, '$5,000 + Studio Recording Contract', 'assets/images/events/pulsefest.jpg', 'UPCOMING');

-- 4. JUDGE ASSIGNMENTS
INSERT INTO judge_assignments (id, judge_id, event_id) VALUES
(1, 1, 1), -- Alan Turing assigned to HackSphere 2026
(2, 2, 1), -- Grace Hopper assigned to HackSphere 2026
(3, 1, 2), -- Alan Turing assigned to CodeCraft
(4, 2, 3); -- Grace Hopper assigned to DesignMatrix

-- 5. TEAMS
INSERT INTO teams (id, event_id, name, team_code, leader_id, is_locked) VALUES
(1, 1, 'NeuralFlow Vanguard', 'NFV2026', 4, TRUE),
(2, 1, 'EcoPulse Analytics', 'EPA9912', 6, TRUE);

-- 6. TEAM MEMBERS
INSERT INTO team_members (id, team_id, user_id, role) VALUES
(1, 1, 4, 'LEADER'), -- Alex Chen
(2, 1, 5, 'MEMBER'), -- Maya Patel
(3, 2, 6, 'LEADER'), -- Sarah Kim
(4, 2, 7, 'MEMBER'); -- David Lee

-- 7. REGISTRATIONS
INSERT INTO registrations (id, event_id, user_id, team_id, registration_code, status) VALUES
(1, 1, 4, 1, 'REG-HS26-ALEX4', 'CONFIRMED'),
(2, 1, 5, 1, 'REG-HS26-MAYA5', 'CONFIRMED'),
(3, 1, 6, 2, 'REG-HS26-SARA6', 'CONFIRMED'),
(4, 1, 7, 2, 'REG-HS26-DAVI7', 'CONFIRMED'),
(5, 2, 4, NULL, 'REG-CC26-ALEX4', 'CONFIRMED'),
(6, 2, 8, NULL, 'REG-CC26-ROHA8', 'CONFIRMED');

-- 8. SUBMISSIONS
INSERT INTO submissions (id, event_id, team_id, user_id, title, description, tech_stack, repo_url, demo_url, ppt_url, video_url, version, is_locked) VALUES
(1, 1, 1, 4, 'MedVision AI: Automated Multi-Modal Clinical Triage', 'MedVision AI leverages vision transformers and large language models to assist emergency triage rooms. It cross-references patient vital telemetry, triage symptoms, and imaging data in real time to suggest acuity rankings and prioritize urgent cardiac or stroke alerts before physician examination.', 'Python, PyTorch, FastAPI, React, OpenCV, Docker', 'https://github.com/eventsphere-hackathon/medvision-ai', 'https://medvision-demo.eventsphere.edu', 'https://slides.eventsphere.edu/medvision-deck.pdf', 'https://youtu.be/medvision-triage-demo', 2, FALSE),

(2, 1, 2, 6, 'TerraGrid: Decentralized Microgrid Energy Exchange', 'A decentralized IoT and cryptographic protocol that enables residential solar power owners to trade surplus clean kilowatt-hours with local neighbors via automated micro-contracts, lowering carbon footprints and localized peak grid stress.', 'Solidity, Rust, Node.js, WebSockets, Raspberry Pi IoT', 'https://github.com/eventsphere-hackathon/terragrid-iot', 'https://terragrid-clean.eventsphere.edu', 'https://slides.eventsphere.edu/terragrid-deck.pdf', 'https://youtu.be/terragrid-iot-demo', 1, FALSE);

-- 9. SCORES & RUBRICS
-- Rubric weights:
-- Innovation: 25%, Technical: 30%, Design: 20%, Presentation: 15%, Feasibility: 10%
-- Score 1: Judge Alan Turing evaluates MedVision AI
-- 9.5 * 0.25 + 9.0 * 0.30 + 8.5 * 0.20 + 9.0 * 0.15 + 8.5 * 0.10 = 2.375 + 2.70 + 1.70 + 1.35 + 0.85 = 8.975 -> 8.98
INSERT INTO scores (id, submission_id, judge_id, criteria_innovation, criteria_technical, criteria_design, criteria_presentation, criteria_feasibility, total_weighted_score, feedback, is_submitted) VALUES
(1, 1, 1, 9.5, 9.0, 8.5, 9.0, 8.5, 8.98, 'Exceptional algorithmic formulation. The multi-modal transformer latency is well within emergency clinical thresholds. Consider edge-caching the weights for field deployment.', TRUE),

-- Score 2: Judge Grace Hopper evaluates MedVision AI
-- 9.0 * 0.25 + 9.5 * 0.30 + 9.0 * 0.20 + 8.5 * 0.15 + 9.0 * 0.10 = 2.25 + 2.85 + 1.80 + 1.275 + 0.90 = 9.075 -> 9.08
(2, 1, 2, 9.0, 9.5, 9.0, 8.5, 9.0, 9.08, 'Very clean architecture and rock-solid failover design. The live telemetry pipeline tested reliably. Outstanding documentation and presentation clarity.', TRUE),

-- Score 3: Judge Alan Turing evaluates TerraGrid
-- 8.5 * 0.25 + 8.5 * 0.30 + 8.0 * 0.20 + 8.0 * 0.15 + 8.0 * 0.10 = 2.125 + 2.55 + 1.60 + 1.20 + 0.80 = 8.275 -> 8.28
(3, 2, 1, 8.5, 8.5, 8.0, 8.0, 8.0, 8.28, 'Solid IoT prototype and intelligent ledger synchronization. The peer settlement algorithm demonstrates strong economic thinking for localized grids.', TRUE),

-- Score 4: Judge Grace Hopper evaluates TerraGrid
-- 8.0 * 0.25 + 8.5 * 0.30 + 8.5 * 0.20 + 8.5 * 0.15 + 8.5 * 0.10 = 2.00 + 2.55 + 1.70 + 1.275 + 0.85 = 8.375 -> 8.38
(4, 2, 2, 8.0, 8.5, 8.5, 8.5, 8.5, 8.38, 'Great hardware demo with real energy transducers. Clear user onboarding interface. Impressive execution in a short hackathon window.', TRUE);

-- 10. ANNOUNCEMENTS
INSERT INTO announcements (id, event_id, title, content, priority) VALUES
(1, NULL, 'EventSphere 2026 Season Official Launch', 'Welcome to the 2026 academic calendar of collegiate hackathons, technical conferences, and cultural fests! Make sure to complete your profile verification to register seamlessly.', 'NORMAL'),
(2, 1, 'HackSphere 2026: Mentor List & Tracks Published', 'Mentors from top AI and cloud labs have joined our Discord server. Review the updated rubric guidelines under your Student Dashboard before locking your team rosters.', 'HIGH'),
(3, 2, 'CodeCraft Sprint: Environment Check Complete', 'All compiler servers (Java 17, GCC 13, Python 3.11) have been benchmarked. Contest starts promptly at 2:00 PM in Lab 301.', 'URGENT');

-- 11. ATTENDANCE
INSERT INTO attendance (id, event_id, user_id, status, check_in_time) VALUES
(1, 1, 4, 'CHECKED_IN', '2026-10-15 09:12:00'),
(2, 1, 5, 'CHECKED_IN', '2026-10-15 09:15:00'),
(3, 1, 6, 'CHECKED_IN', '2026-10-15 09:20:00'),
(4, 1, 7, 'CHECKED_IN', '2026-10-15 09:22:00'),
(5, 2, 4, 'CHECKED_IN', '2026-09-28 13:50:00'),
(6, 2, 8, 'PENDING', NULL);

-- 12. PREVIOUS EVENTS (2023–2025 SHOWCASE)
INSERT INTO previous_events (id, event_year, title, category, description, winner_team, runner_up_team, participant_count, prize_pool, cover_image, highlights) VALUES
(1, 2025, 'DesignStorm: Next-Gen Product Sprint 2025', 'Technical / UX', 'Our 2025 design sprint centered on spatial computing and ambient AI. 42 teams created breathtaking interfaces for mixed reality productivity and healthcare devices.', 'Team PixelCraft (OmniCanvas XR)', 'AuraDesign (EchoAssist)', 138, '$4,500', 'assets/images/showcase/designstorm2025.jpg', '42 interactive prototypes, 12 venture demo day pitches, 97% judge satisfaction index.'),

(2, 2024, 'HackSphere National Hackathon 2024', 'Hackathon', 'Over 550 builders converged for 36 hours of non-stop innovation. Breakthrough projects spanned autonomous wildfire detection, open-source biomedical robotics, and zero-knowledge identity protocols.', 'Team NeuralPulse (BioSentinel)', 'Solaris Mesh (HyperGrid)', 560, '$10,000', 'assets/images/showcase/hacksphere2024.jpg', '118 working prototypes shipped, $25,000 in cloud credits distributed, 4 startups incorporated post-event.'),

(3, 2024, 'CodeClash: Inter-University Competitive Programming', 'Technical', 'The premier speed programming contest of the region featuring 200 of the sharpest algorithmic problem solvers tackling high-performance computing hurdles.', 'ByteBenders (Dept of CS)', 'RecursionKings (IIT Madras)', 194, '$3,000', 'assets/images/showcase/codeclash2024.jpg', '8 challenging problem sets, 1,840 submissions evaluated in real-time, median solve time: 42 mins.'),

(4, 2024, 'RoboQuest: Autonomous Robotics Challenge', 'Technical / Robotics', 'Field robotics arena challenge where autonomous ground rovers and computer-vision drones navigated simulated disaster recovery zones.', 'RoboTitans (Autonomous Rover)', 'AeroVanguard (Vision Drone)', 112, '$6,000', 'assets/images/showcase/roboquest2024.jpg', '14 obstacle terrain courses, 100% autonomous navigation category, sponsored by leading aerospace labs.'),

(5, 2023, 'InnoVate: IoT & Hardware Innovation Expo', 'Technical / Hardware', 'Showcase of physical computing, embedded sensor networks, and edge intelligence hardware designed to solve agricultural and environmental challenges.', 'SmartGrid AI (AgriSense)', 'CleanWater IoT (AquaFlow)', 220, '$5,000', 'assets/images/showcase/innovate2023.jpg', '48 live hardware demonstration booths, 15 patent applications drafted, national media coverage.');

-- 13. EVENT PHOTOS (Rich Gallery with categories & captions)
INSERT INTO event_photos (id, previous_event_id, caption, category, photo_url, aspect_ratio) VALUES
(1, 2, 'Late night coding sprint at HackSphere 2024 as teams fine-tune their neural network weights.', 'Coding', 'assets/images/gallery/gallery_coding_1.jpg', '16:9'),
(2, 2, 'Team NeuralPulse pitching their BioSentinel medical diagnostic prototype to the jury.', 'Presentation', 'assets/images/gallery/gallery_present_1.jpg', '4:3'),
(3, 2, 'Industry mentors assisting student builders with real-time distributed stream architecture.', 'Mentorship', 'assets/images/gallery/gallery_mentor_1.jpg', '3:2'),
(4, 2, 'The exhilarating moment winners were announced on the main stage at HackSphere 2024.', 'Celebration', 'assets/images/gallery/gallery_celeb_1.jpg', '16:9'),
(5, 2, 'Grand prize trophy and oversized ceremonial checks awarded to Team NeuralPulse.', 'Prize', 'assets/images/gallery/gallery_prize_1.jpg', '4:3'),
(6, 1, 'Designers collaborating over Figma design tokens and tactile mockups at DesignStorm 2025.', 'Coding', 'assets/images/gallery/gallery_design_1.jpg', '3:2'),
(7, 1, 'Final design showcase review with jury members evaluating XR spatial interactions.', 'Presentation', 'assets/images/gallery/gallery_design_2.jpg', '16:9'),
(8, 3, 'High-intensity arena during the final 10 minutes of CodeClash algorithmic sprint.', 'Coding', 'assets/images/gallery/gallery_codeclash_1.jpg', '4:3'),
(9, 4, 'Autonomous ground rover navigating through simulated obstacle terrain at RoboQuest.', 'Presentation', 'assets/images/gallery/gallery_robotics_1.jpg', '16:9'),
(10, 4, 'Robotics team troubleshooting sensors and microcontrollers in the pit lane.', 'Mentorship', 'assets/images/gallery/gallery_robotics_2.jpg', '3:2'),
(11, 5, 'Live agricultural IoT sensor demonstration at the InnoVate Hardware Expo 2023.', 'Presentation', 'assets/images/gallery/gallery_iot_1.jpg', '4:3'),
(12, 2, 'All 500+ participants, judges, and student organizers celebrating at the closing gala.', 'Celebration', 'assets/images/gallery/gallery_crowd_1.jpg', '16:9');
