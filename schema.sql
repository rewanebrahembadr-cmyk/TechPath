DROP DATABASE IF EXISTS techpath_db;

CREATE DATABASE techpath_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE techpath_db;

CREATE TABLE tracks (
    track_id INT AUTO_INCREMENT PRIMARY KEY,
    track_name VARCHAR(100) NOT NULL UNIQUE,
    short_description VARCHAR(255) NOT NULL,
    full_description TEXT NOT NULL,
    skills TEXT NOT NULL,
    tools TEXT NOT NULL,
    job_roles TEXT NOT NULL,
    roadmap TEXT NOT NULL,
    coding_level ENUM('Low', 'Medium', 'High') NOT NULL,
    math_level ENUM('Low', 'Medium', 'High') NOT NULL,
    creativity_level ENUM('Low', 'Medium', 'High') NOT NULL,
    data_level ENUM('Low', 'Medium', 'High') NOT NULL,
    has_mini_task BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    faculty VARCHAR(150) NOT NULL,
    study_year VARCHAR(50) NOT NULL,
    experience_level ENUM(
        'Beginner',
        'Intermediate',
        'Advanced'
    ) NOT NULL DEFAULT 'Beginner',
    initial_track_id INT NULL,
    final_track_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_students_initial_track
        FOREIGN KEY (initial_track_id)
        REFERENCES tracks(track_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_students_final_track
        FOREIGN KEY (final_track_id)
        REFERENCES tracks(track_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    question_text VARCHAR(500) NOT NULL,
    question_order INT NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE question_weights (
    weight_id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    track_id INT NOT NULL,
    weight_value DECIMAL(5,2) NOT NULL DEFAULT 0,

    CONSTRAINT uq_question_track
        UNIQUE (question_id, track_id),

    CONSTRAINT chk_weight_value
        CHECK (weight_value >= 0),

    CONSTRAINT fk_weights_question
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_weights_track
        FOREIGN KEY (track_id)
        REFERENCES tracks(track_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE quiz_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    status ENUM('In Progress', 'Completed')
        NOT NULL DEFAULT 'In Progress',
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,

    CONSTRAINT fk_attempts_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE quiz_answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_value TINYINT NOT NULL,

    CONSTRAINT uq_attempt_question
        UNIQUE (attempt_id, question_id),

    CONSTRAINT chk_answer_value
        CHECK (answer_value BETWEEN 1 AND 5),

    CONSTRAINT fk_answers_attempt
        FOREIGN KEY (attempt_id)
        REFERENCES quiz_attempts(attempt_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE quiz_scores (
    score_id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL,
    track_id INT NOT NULL,
    score DECIMAL(8,2) NOT NULL DEFAULT 0,
    match_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,

    CONSTRAINT uq_attempt_track_score
        UNIQUE (attempt_id, track_id),

    CONSTRAINT chk_score
        CHECK (score >= 0),

    CONSTRAINT chk_match_percentage
        CHECK (match_percentage BETWEEN 0 AND 100),

    CONSTRAINT fk_scores_attempt
        FOREIGN KEY (attempt_id)
        REFERENCES quiz_attempts(attempt_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_scores_track
        FOREIGN KEY (track_id)
        REFERENCES tracks(track_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE mini_tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    task_title VARCHAR(150) NOT NULL,
    task_description TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option ENUM('A', 'B', 'C', 'D') NOT NULL,
    explanation TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_tasks_track
        FOREIGN KEY (track_id)
        REFERENCES tracks(track_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE task_attempts (
    task_attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    task_id INT NOT NULL,
    selected_option ENUM('A', 'B', 'C', 'D') NOT NULL,
    is_correct BOOLEAN NOT NULL,
    enjoyment_rating TINYINT NOT NULL,
    wants_to_continue BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_enjoyment_rating
        CHECK (enjoyment_rating BETWEEN 1 AND 5),

    CONSTRAINT fk_task_attempts_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_task_attempts_task
        FOREIGN KEY (task_id)
        REFERENCES mini_tasks(task_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    clarity_rating TINYINT NOT NULL,
    usefulness_rating TINYINT NOT NULL,
    changed_decision BOOLEAN NOT NULL DEFAULT FALSE,
    message VARCHAR(1000) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_clarity_rating
        CHECK (clarity_rating BETWEEN 1 AND 5),

    CONSTRAINT chk_usefulness_rating
        CHECK (usefulness_rating BETWEEN 1 AND 5),

    CONSTRAINT fk_feedback_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);