TechPath

TechPath is a web-based career discovery platform that helps students identify the most suitable technology career path based on their interests, strengths, and work preferences.

The system guides students through a complete journey starting with registration, followed by a career discovery quiz, personalized recommendations, learning roadmaps, and practical career experience tasks.

--------------------------------------------------

Project Features

Student Module

- Student Registration
- Career Discovery Quiz
- Personalized Recommendation
- Best Match and Second Match
- Personal Strength Analysis
- Career Roadmaps
- Career Details
- Practical Mini Tasks
- Career Experience Feedback

Admin Module

- Dashboard Overview
- Student Management
- Quiz Statistics
- Career Recommendation Analysis
- Career Experience Analytics
- Track Statistics

--------------------------------------------------

Technology Stack

Frontend

- HTML5
- CSS3
- JavaScript

Backend

- Node.js
- Express.js

Database

- MySQL

Packages

- express
- mysql2
- dotenv

--------------------------------------------------

Technology Career Tracks

The system currently includes eight technology career tracks:

1. AI & Automation
2. Data Analysis
3. Data Science
4. Machine Learning
5. Web Development
6. UI/UX Design
7. Cybersecurity
8. Cloud & DevOps

--------------------------------------------------

Recommendation Engine

The recommendation engine evaluates student answers using a weighted scoring system.

The final result includes:

- Best Career Match
- Second Career Match
- Compatibility Percentage
- Personal Strength Profile

The strength profile evaluates:

- Programming Interest
- Logic and Problem Solving
- Automation and Systems Thinking
- Creativity and User Thinking
- Data Orientation

--------------------------------------------------

Career Journey

Students complete the following steps:

1. Registration
2. Career Discovery Quiz
3. Career Recommendation
4. Learning Roadmap
5. Career Experience

--------------------------------------------------

Project Structure

TechPath
│
├── database
│   ├── techpath_db.sql
│   └── schema.sql
│
├── public
│   ├── css
│   ├── js
│   └── images
│
├── views
│
├── server.js
├── package.json
├── package-lock.json
├── .env.example
├── .gitignore
└── README.md

--------------------------------------------------

Database

The application uses a MySQL database.

Main database tables include:

- Students
- Career Tracks
- Quiz Questions
- Quiz Answers
- Quiz Attempts
- Recommendations
- Career Roadmaps
- Skills
- Tools
- Job Roles
- Mini Tasks
- Career Experience Results

Database file:

database/techpath_db.sql

--------------------------------------------------

Installation

Install project dependencies

npm install

Import the database

Open MySQL Workbench and import:

database/techpath_db.sql

Configure environment variables

Create a file named `.env` using `.env.example` and update the database settings.

Example:

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=techpath_db
PORT=3000

Run the project

node server.js

Open the application in your browser:

http://localhost:3000

--------------------------------------------------

Available Pages

/                  Home Page
/register          Student Registration
/quiz              Career Discovery Quiz
/recommendation    Recommendation Results
/tracks            Career Tracks
/track-details     Track Details
/mini-task         Career Experience
/task-success      Task Result
/admin             Admin Dashboard

--------------------------------------------------

Learning Outcomes

This project demonstrates practical experience with:

- Full Stack Web Development
- Node.js
- Express.js
- REST APIs
- MySQL Database Design
- CRUD Operations
- Recommendation Systems
- Responsive Web Design

--------------------------------------------------

Developer

Rewan Ebrahem Badr Ahmed

Business Administration Student

AI & Data Science Trainee

--------------------------------------------------

Notes

This project was developed as an educational academic project.