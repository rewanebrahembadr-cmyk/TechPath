-- TechPath public seed data
-- Contains configuration/demo content only. No user records or personal data are included.

USE techpath_db;

-- Additional tables used by the recommendation and track-details APIs.
CREATE TABLE IF NOT EXISTS strength_dimensions (
    dimension_id INT AUTO_INCREMENT PRIMARY KEY,
    dimension_name VARCHAR(100) NOT NULL UNIQUE,
    dimension_description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS question_dimension_weights (
    question_id INT NOT NULL,
    dimension_id INT NOT NULL,
    weight_value DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (question_id, dimension_id),
    CONSTRAINT fk_dimension_question
        FOREIGN KEY (question_id) REFERENCES questions(question_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_question_dimension
        FOREIGN KEY (dimension_id) REFERENCES strength_dimensions(dimension_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS track_skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    skill_name VARCHAR(150) NOT NULL,
    UNIQUE KEY unique_track_skill (track_id, skill_name),
    CONSTRAINT fk_track_skills_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS track_tools (
    tool_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    tool_name VARCHAR(150) NOT NULL,
    UNIQUE KEY unique_track_tool (track_id, tool_name),
    CONSTRAINT fk_track_tools_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS track_job_roles (
    job_role_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    job_role_name VARCHAR(150) NOT NULL,
    UNIQUE KEY unique_track_job_role (track_id, job_role_name),
    CONSTRAINT fk_track_job_roles_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS track_roadmap_steps (
    step_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    step_number INT NOT NULL,
    step_title VARCHAR(150) NOT NULL,
    step_description TEXT NOT NULL,
    UNIQUE KEY uq_track_step_number (track_id, step_number),
    CONSTRAINT fk_roadmap_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Career tracks
INSERT INTO tracks
(track_id, track_name, short_description, full_description, skills, tools, job_roles, roadmap, coding_level, math_level, creativity_level, data_level, has_mini_task, is_active)
VALUES
(1,'AI & Automation','Build smart workflows that automate repetitive tasks.','AI & Automation combines artificial intelligence, APIs, workflow automation, and intelligent agents to build systems that can understand tasks and automate business processes.','AI fundamentals, prompt engineering, Python, APIs, workflow design','ChatGPT, Python, n8n, Make, LangChain','AI Automation Engineer, AI Agent Developer, AI Solutions Engineer','AI foundations, Python, APIs, workflow automation, agents, RAG, deployment','Medium','Low','Medium','Medium',1,1),
(2,'Data Analysis','Transform data into meaningful business insights.','Data Analysis focuses on collecting, cleaning, exploring, and interpreting data to discover useful patterns and support business decisions.','Excel, SQL, statistics, visualization, analytical thinking','Excel, SQL, Python, Power BI','Data Analyst, BI Analyst, Reporting Analyst','Excel, SQL, statistics, Python, visualization, dashboards','Medium','Medium','Medium','High',1,1),
(3,'Data Science','Use data, statistics, and programming to solve complex problems.','Data Science combines programming, statistics, analysis, machine learning, and business understanding to solve complex problems using data.','Python, statistics, data preparation, experimentation','Python, Pandas, Jupyter, Scikit-learn','Data Scientist, Junior Data Scientist, Decision Scientist','Python, statistics, SQL, EDA, feature engineering, ML, deployment','High','High','Medium','High',1,1),
(4,'Machine Learning','Create models that learn patterns from data.','Machine Learning focuses on designing, training, evaluating, and deploying models that learn patterns from data and make predictions or decisions.','Python, mathematics, algorithms, model evaluation','Python, Scikit-learn, TensorFlow, PyTorch','Machine Learning Engineer, AI Engineer, MLOps Engineer','Python, math, preprocessing, supervised learning, evaluation, deep learning, MLOps','High','High','Medium','High',1,1),
(5,'Web Development','Build websites and interactive web applications.','Web Development focuses on building responsive interfaces, backend logic, databases, APIs, validation, security, and deploying complete web applications.','HTML, CSS, JavaScript, backend development, databases','HTML, CSS, JavaScript, Node.js, Express, MySQL','Front-End Developer, Back-End Developer, Full-Stack Developer','HTML, CSS, JavaScript, Git, backend development, databases, deployment','High','Low','High','Medium',1,1),
(6,'UI/UX Design','Design clear and enjoyable digital experiences.','UI/UX Design focuses on understanding users and creating digital products that are useful, clear, accessible, and visually consistent.','User research, wireframing, visual design, prototyping','Figma, FigJam, Maze, Miro','UI Designer, UX Designer, Product Designer','Research, information architecture, wireframes, visual design, prototypes, testing','Low','Low','High','Low',1,1),
(7,'Cybersecurity','Protect systems, networks, and information from threats.','Cybersecurity focuses on identifying risks, monitoring suspicious activity, securing infrastructure, testing vulnerabilities, and responding to incidents.','Networking, Linux, security monitoring, incident response','Linux, Wireshark, Nmap, Burp Suite','Security Analyst, SOC Analyst, Security Engineer','Networking, Linux, security monitoring, vulnerabilities, web security, incident response','Medium','Low','Medium','Medium',1,1),
(8,'Cloud & DevOps','Build, deploy, and maintain reliable software systems.','Cloud & DevOps focuses on cloud infrastructure, automation, CI/CD, containers, infrastructure as code, monitoring, and reliability.','Linux, automation, CI/CD, containers, cloud infrastructure','Linux, Docker, GitHub Actions, AWS, Kubernetes','DevOps Engineer, Cloud Engineer, Site Reliability Engineer','Linux, networking, Git, CI/CD, Docker, cloud, IaC, monitoring','High','Low','Medium','Medium',1,1);

-- Quiz questions
INSERT INTO questions (question_id, question_text, question_order, is_active) VALUES
(1,'I enjoy examining numbers and finding patterns that help explain a problem.',1,1),
(2,'I enjoy writing code and solving technical problems step by step.',2,1),
(3,'I care about how digital products look and how easy they are to use.',3,1),
(4,'I like finding faster ways to complete repetitive tasks automatically.',4,1),
(5,'I am interested in discovering risks and protecting systems from threats.',5,1),
(6,'I enjoy turning raw information into clear charts and useful conclusions.',6,1),
(7,'I am interested in servers, cloud systems, deployment, and how applications stay online.',7,1),
(8,'I enjoy understanding people needs before designing a solution.',8,1),
(9,'I am comfortable learning mathematical concepts to solve technical problems.',9,1),
(10,'I would enjoy building websites or web applications that people can interact with.',10,1),
(11,'I am curious about how systems can learn from data and make predictions.',11,1),
(12,'I stay patient when diagnosing a technical problem with several possible causes.',12,1),
(13,'I like using evidence and data to support business decisions.',13,1),
(14,'I pay attention to colors, typography, spacing, and visual consistency.',14,1),
(15,'I enjoy investigating unusual activity and identifying its cause.',15,1),
(16,'I enjoy connecting different tools together to create one complete workflow.',16,1);

-- Weighted mapping between quiz questions and tracks
INSERT INTO question_weights (question_id, track_id, weight_value) VALUES
(1,2,3.00),(1,3,2.00),(1,4,2.00),
(2,5,3.00),(2,4,2.00),(2,8,2.00),
(3,6,3.00),(3,5,1.00),
(4,1,3.00),(4,8,2.00),
(5,7,3.00),(5,8,1.00),
(6,2,3.00),(6,3,2.00),
(7,8,3.00),(7,7,1.00),
(8,6,3.00),(8,5,1.00),
(9,4,3.00),(9,3,3.00),(9,2,1.00),
(10,5,3.00),(10,6,1.00),
(11,4,3.00),(11,3,3.00),(11,1,1.00),
(12,8,3.00),(12,7,2.00),(12,5,1.00),
(13,2,3.00),(13,3,2.00),
(14,6,3.00),(14,5,1.00),
(15,7,3.00),(15,2,1.00),
(16,1,3.00),(16,8,2.00),(16,5,1.00);

-- Strength profile dimensions
INSERT INTO strength_dimensions (dimension_id, dimension_name, dimension_description) VALUES
(1,'Logic & Problem Solving','Interest in patterns, diagnosis, reasoning, and solving structured problems.'),
(2,'Programming Interest','Interest in coding, software development, and building technical applications.'),
(3,'Data Orientation','Interest in numbers, evidence, analysis, statistics, and data-driven decisions.'),
(4,'Creativity & User Thinking','Interest in visual design, user needs, usability, and creative digital experiences.'),
(5,'Automation & Systems Thinking','Interest in workflows, tools, systems, infrastructure, automation, and integration.');

INSERT INTO question_dimension_weights (question_id, dimension_id, weight_value) VALUES
(1,1,2.00),(1,3,3.00),(2,1,2.00),(2,2,3.00),(3,4,3.00),(4,5,3.00),
(5,1,2.00),(5,5,3.00),(6,3,3.00),(7,2,1.00),(7,5,3.00),(8,4,3.00),
(9,1,2.00),(9,3,3.00),(10,2,3.00),(10,4,1.00),(11,2,2.00),(11,3,3.00),
(12,1,3.00),(12,5,1.00),(13,1,1.00),(13,3,3.00),(14,4,3.00),(15,1,1.00),
(15,5,3.00),(16,2,1.00),(16,5,3.00);

-- Practical mini-tasks
INSERT INTO mini_tasks
(task_id, track_id, task_title, task_description, option_a, option_b, option_c, option_d, correct_option, explanation, is_active)
VALUES
(1,1,'Design an AI Customer Email Workflow','Choose the best automated workflow for classifying customer emails and routing them to the correct team.','Notify every team before classification.','Send the email to an AI model, classify it, store the result, and notify the correct team.','Assign a random category.','Handle every email manually.','B','A reliable AI workflow uses a trigger, model classification, structured storage, and routing.',1),
(2,3,'Choose the Best Data Science Approach','A company wants to understand customer churn and predict which customers may leave next.','Ask customers to guess whether they will leave.','Collect and clean data, explore it, engineer features, build and evaluate a model, then communicate findings.','Delete incomplete records and use personal opinion.','Use a random formula without validation.','B','A complete data science workflow includes preparation, exploration, modeling, evaluation, and communication.',1),
(3,4,'Select the Best Machine Learning Process','A business wants to predict whether a loan applicant is likely to repay a loan.','Train on unprepared data and deploy immediately.','Choose the most complex model only.','Prepare labeled data, split train/test sets, train models, compare performance, and select the best fit.','Predict manually without historical data.','C','Supervised ML requires labeled data, preprocessing, proper evaluation, and model comparison.',1),
(4,7,'Respond to a Suspicious Login Attempt','Repeated failed logins are followed by a successful login from an unfamiliar location.','Ignore it because the login succeeded.','Disable every company system permanently.','Investigate logs, secure the account, verify the user, reset credentials if needed, and review related activity.','Publish the password for the team.','C','Incident response should contain risk, verify the event, protect the account, and investigate related activity.',1),
(5,8,'Design a Reliable Deployment Workflow','A team wants approved code changes to be tested and deployed consistently.','Upload files manually to production without tests.','Push to version control, run automated tests, build, deploy through a controlled pipeline, and monitor the service.','Deploy unfinished changes directly.','Keep the code only on one computer.','B','Reliable DevOps uses version control, automated testing, controlled deployment, and monitoring.',1),
(6,2,'Analyze a Drop in Monthly Sales','Monthly sales decreased. Choose the best analysis process.','Look at one number and blame one team.','Collect and clean sales data, compare periods, segment by product and region, visualize patterns, and summarize findings.','Delete the data and guess.','Create a chart without validating data.','B','Data analysis requires clean data, comparisons, segmentation, visualization, and evidence-based conclusions.',1),
(7,5,'Build a Reliable Registration Form','A website needs a student registration form that saves valid information and gives clear feedback.','Accept every value and store the database password in HTML.','Build the form, validate input, send it to the server, use parameterized SQL, handle errors, and show success feedback.','Save data only in the browser console.','Submit even if required fields are empty.','B','A reliable web app validates input, uses safe database queries, handles errors, and gives clear feedback.',1),
(8,6,'Improve a Confusing Checkout Screen','Users frequently leave an online checkout before completing payment.','Change colors randomly.','Add more fields and instructions.','Study behavior, identify usability problems, simplify the flow, prototype, test with users, and iterate.','Copy another website exactly.','C','UI/UX improvement starts with understanding users, testing solutions, and iterating from evidence.',1);

-- Compact track detail data used by /api/tracks/:trackId
INSERT INTO track_skills (track_id, skill_name) VALUES
(1,'Prompt engineering'),(1,'Python'),(1,'Workflow design'),(1,'REST APIs'),
(2,'Excel analysis'),(2,'SQL querying'),(2,'Data visualization'),(2,'Data storytelling'),
(3,'Python programming'),(3,'Statistical analysis'),(3,'Feature engineering'),(3,'Model evaluation'),
(4,'Python programming'),(4,'Data preprocessing'),(4,'Supervised learning'),(4,'Model deployment'),
(5,'HTML & CSS'),(5,'JavaScript'),(5,'Backend development'),(5,'Database integration'),
(6,'User research'),(6,'Wireframing'),(6,'Prototyping'),(6,'Usability testing'),
(7,'Networking fundamentals'),(7,'Linux fundamentals'),(7,'Security monitoring'),(7,'Incident response'),
(8,'Linux administration'),(8,'CI/CD'),(8,'Containerization'),(8,'Cloud infrastructure');

INSERT INTO track_tools (track_id, tool_name) VALUES
(1,'Python'),(1,'n8n'),(1,'LangChain'),(1,'Postman'),
(2,'Excel'),(2,'SQL'),(2,'Power BI'),(2,'Python'),
(3,'Python'),(3,'Pandas'),(3,'Jupyter Notebook'),(3,'Scikit-learn'),
(4,'Python'),(4,'Scikit-learn'),(4,'TensorFlow'),(4,'MLflow'),
(5,'HTML'),(5,'CSS'),(5,'JavaScript'),(5,'Node.js'),(5,'MySQL'),
(6,'Figma'),(6,'FigJam'),(6,'Maze'),(6,'Miro'),
(7,'Linux'),(7,'Wireshark'),(7,'Nmap'),(7,'Burp Suite'),
(8,'Linux'),(8,'Docker'),(8,'GitHub Actions'),(8,'AWS');

INSERT INTO track_job_roles (track_id, job_role_name) VALUES
(1,'AI Automation Engineer'),(1,'AI Agent Developer'),(1,'AI Solutions Engineer'),
(2,'Data Analyst'),(2,'Business Intelligence Analyst'),(2,'Reporting Analyst'),
(3,'Data Scientist'),(3,'Junior Data Scientist'),(3,'Decision Scientist'),
(4,'Machine Learning Engineer'),(4,'AI Engineer'),(4,'MLOps Engineer'),
(5,'Front-End Developer'),(5,'Back-End Developer'),(5,'Full-Stack Developer'),
(6,'UI Designer'),(6,'UX Designer'),(6,'Product Designer'),
(7,'Security Analyst'),(7,'SOC Analyst'),(7,'Security Engineer'),
(8,'DevOps Engineer'),(8,'Cloud Engineer'),(8,'Site Reliability Engineer');

INSERT INTO track_roadmap_steps (track_id, step_number, step_title, step_description) VALUES
(1,1,'AI Foundations','Learn core AI, LLM, and responsible-AI concepts.'),(1,2,'Programming & APIs','Build Python fundamentals and work with JSON, REST APIs, and webhooks.'),(1,3,'Automation & Agents','Create workflows and learn tool-calling, memory, and agent design.'),(1,4,'Build & Deploy','Create portfolio automations, test them, secure credentials, and deploy.'),
(2,1,'Spreadsheet Foundations','Learn Excel formulas, cleaning, pivot tables, and charts.'),(2,2,'SQL & Statistics','Query relational data and understand core descriptive statistics.'),(2,3,'Python & Visualization','Use Pandas and visualization tools to explore data.'),(2,4,'Dashboards & Storytelling','Build dashboards and communicate evidence-based recommendations.'),
(3,1,'Python & Statistics','Build solid programming and statistical foundations.'),(3,2,'Data Preparation & EDA','Clean, transform, and explore real datasets.'),(3,3,'Machine Learning','Learn feature engineering, supervised learning, and model evaluation.'),(3,4,'End-to-End Projects','Build reproducible projects and deploy selected models.'),
(4,1,'Math & Python','Learn the mathematics and programming used in machine learning.'),(4,2,'Core ML','Study regression, classification, clustering, and preprocessing.'),(4,3,'Evaluation & Optimization','Use proper metrics, cross-validation, tuning, and error analysis.'),(4,4,'Deep Learning & MLOps','Explore neural networks, deployment, experiment tracking, and monitoring.'),
(5,1,'Web Foundations','Learn how browsers, servers, HTTP, and full-stack applications work.'),(5,2,'Frontend','Build responsive interfaces with HTML, CSS, and JavaScript.'),(5,3,'Backend & Databases','Build Express APIs, validate input, and work with MySQL.'),(5,4,'Security & Deployment','Apply safe configuration, test the app, use Git, and deploy it.'),
(6,1,'UX Foundations','Learn human-centered design, accessibility, and product thinking.'),(6,2,'Research & Structure','Practice user research, personas, journeys, and information architecture.'),(6,3,'Wireframes & Visual Design','Design flows, wireframes, layout, typography, and color systems.'),(6,4,'Prototype & Test','Build interactive prototypes, run usability tests, and iterate.'),
(7,1,'Networking & Linux','Understand networking, operating systems, permissions, and logs.'),(7,2,'Security Monitoring','Learn threats, vulnerabilities, SIEM concepts, and log analysis.'),(7,3,'Web Security & IAM','Study secure access, web vulnerabilities, and common security controls.'),(7,4,'Incident Response','Practice investigation, containment, remediation, and security reporting.'),
(8,1,'Linux & Networking','Build strong infrastructure and command-line foundations.'),(8,2,'Git & CI/CD','Use collaborative version control and automated delivery pipelines.'),(8,3,'Containers & Cloud','Learn Docker, orchestration concepts, and cloud services.'),(8,4,'IaC & Monitoring','Use infrastructure as code, metrics, logs, alerts, and reliability practices.');
