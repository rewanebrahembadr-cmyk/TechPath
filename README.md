# TechPath

TechPath is a full-stack career discovery platform designed to help beginners explore technology career paths and discover which track best matches their interests, strengths, and work preferences.

Instead of choosing a field based only on descriptions, users move through a guided journey: registration, a career discovery quiz, personalized recommendations, learning roadmaps, and practical mini-tasks that let them experience the nature of each track.

## Key Features

### Student Experience
- Student registration
- 16-question career discovery quiz
- Weighted recommendation engine
- Best match and second-best match
- Compatibility percentages
- Personal strength profile
- Career track exploration
- Learning roadmaps
- Practical mini-tasks
- Career experience feedback

### Admin Dashboard
- Dashboard overview
- Student management
- Quiz statistics
- Recommendation analysis
- Career experience analytics
- Track statistics

## Technology Stack

**Frontend**
- HTML5
- CSS3
- JavaScript

**Backend**
- Node.js
- Express.js

**Database**
- MySQL

**Main Packages**
- express
- mysql2
- dotenv

## Technology Career Tracks

TechPath currently includes eight technology tracks:

1. AI & Automation
2. Data Analysis
3. Data Science
4. Machine Learning
5. Web Development
6. UI/UX Design
7. Cybersecurity
8. Cloud & DevOps

## Recommendation Engine

The recommendation engine evaluates quiz responses using a weighted scoring system. It calculates compatibility across the available tracks and returns:

- Best Career Match
- Second Career Match
- Compatibility Percentage
- Personal Strength Profile

The strength profile evaluates areas such as:

- Programming Interest
- Logic & Problem Solving
- Automation & Systems Thinking
- Creativity & User Thinking
- Data Orientation

## User Journey

1. Register
2. Complete the Career Discovery Quiz
3. Receive Personalized Recommendations
4. Explore the Suggested Learning Roadmap
5. Try a Practical Mini-Task
6. Reflect on the Career Experience

## Project Structure

```text
TechPath/
├── database/
│   ├── schema.sql
│   └── seed.sql
├── public/
│   ├── css/
│   │   └── style.css
│   └── js/
│       ├── admin.js
│       ├── mini-task.js
│       ├── quiz.js
│       ├── recommendation.js
│       ├── task-success.js
│       ├── track-details.js
│       └── tracks.js
├── views/
│   ├── admin.html
│   ├── index.html
│   ├── mini-task.html
│   ├── quiz.html
│   ├── recommendation.html
│   ├── register.html
│   ├── task-success.html
│   ├── track-details.html
│   └── tracks.html
├── server.js
├── package.json
├── package-lock.json
├── .env.example
├── .gitignore
└── README.md
```

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/rewanebrahembadr-cmyk/TechPath.git
cd TechPath
```

### 2. Install dependencies

```bash
npm install
```

### 3. Prepare the MySQL database

Create the database structure first by importing:

```text
database/schema.sql
```

Then import the reusable application content from:

```text
database/seed.sql
```

`seed.sql` contains only public configuration and learning content such as career tracks, quiz questions, scoring weights, roadmaps, and mini-tasks. It does not contain student accounts, emails, quiz attempts, or other user-generated records.

### 4. Configure environment variables

Create a `.env` file based on `.env.example`:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=techpath_db
PORT=3000
```

> Never commit your real `.env` file or database password to GitHub.

### 5. Run the application

```bash
npm start
```

Then open:

```text
http://localhost:3000
```

## Main Routes

| Route | Purpose |
|---|---|
| `/` | Home page |
| `/register` | Student registration |
| `/quiz` | Career discovery quiz |
| `/recommendation` | Recommendation results |
| `/tracks` | Career tracks |
| `/track-details` | Track details |
| `/mini-task` | Career experience task |
| `/task-success` | Task result |
| `/admin` | Admin dashboard |

## What This Project Demonstrates

- Full-stack web development
- REST-style APIs
- Node.js and Express.js
- MySQL database design
- CRUD operations
- Form validation
- Parameterized SQL queries
- Database transactions
- Weighted recommendation logic
- Responsive web design
- Environment-variable based configuration

## Deployment

The application is structured for deployment on a Node.js hosting platform with a managed MySQL-compatible database. Production database credentials should be configured using the hosting platform's environment-variable settings and should never be committed to the repository.

## Developer

**Rewan Ebrahem Badr Ahmed**

Built as an educational full-stack project focused on combining technology career guidance with practical exploration.
