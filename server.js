const express = require("express");
const mysql = require("mysql2");
const path = require("path");
require("dotenv").config();

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect((error) => {
    if (error) {
        console.error(
            "Database connection failed:",
            error.message
        );

        return;
    }

    console.log("Connected to MySQL successfully");
});

/* =========================
   Pages
========================= */

app.get("/", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "index.html")
    );
});

app.get("/register", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "register.html")
    );
});

app.get("/quiz", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "quiz.html")
    );
});

app.get("/recommendation", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "recommendation.html")
    );
});

app.get("/track-details", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "track-details.html")
    );
});

app.get("/mini-task", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "mini-task.html")
    );
});

app.get("/task-success", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "task-success.html")
    );
});

app.get("/tracks", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "tracks.html")
    );
});
app.get("/admin", (req, res) => {
    res.sendFile(
        path.join(__dirname, "views", "admin.html")
    );
});

/* =========================
   Student Registration
========================= */

app.post("/register", (req, res) => {
    const {
        full_name,
        email,
        faculty,
        study_year,
        experience_level,
        initial_track_id
    } = req.body;

    if (
        !full_name ||
        !email ||
        !faculty ||
        !study_year ||
        !experience_level
    ) {
        return res.status(400).send(
            "Please complete all required fields."
        );
    }

    const selectedTrack = initial_track_id || null;

    const sql = `
        INSERT INTO students (
            full_name,
            email,
            faculty,
            study_year,
            experience_level,
            initial_track_id
        )
        VALUES (?, ?, ?, ?, ?, ?)
    `;

    const values = [
        full_name.trim(),
        email.trim().toLowerCase(),
        faculty.trim(),
        study_year,
        experience_level,
        selectedTrack
    ];

    db.execute(sql, values, (error, result) => {
        if (error) {
            if (error.code === "ER_DUP_ENTRY") {
                return res.status(409).send(
                    "This email address is already registered."
                );
            }

            console.error(
                "Registration error:",
                error.message
            );

            return res.status(500).send(
                "An error occurred while saving the student."
            );
        }

        res.redirect(
            `/quiz?student_id=${result.insertId}`
        );
    });
});

/* =========================
   Quiz Submission
========================= */

app.post("/api/quiz/submit", (req, res) => {
    const { student_id, answers } = req.body;

    const numericStudentId = Number(student_id);

    if (
        !Number.isInteger(numericStudentId) ||
        numericStudentId <= 0
    ) {
        return res.status(400).json({
            success: false,
            message: "Invalid student ID."
        });
    }

    if (!answers || typeof answers !== "object") {
        return res.status(400).json({
            success: false,
            message: "Quiz answers are missing."
        });
    }

    const answerEntries = Object.entries(answers);

    if (answerEntries.length !== 16) {
        return res.status(400).json({
            success: false,
            message: "Please answer all 16 questions."
        });
    }

    const invalidAnswer = answerEntries.some(
        ([questionOrder, answerValue]) => {
            const order = Number(questionOrder);
            const value = Number(answerValue);

            return (
                !Number.isInteger(order) ||
                order < 1 ||
                order > 16 ||
                !Number.isInteger(value) ||
                value < 1 ||
                value > 5
            );
        }
    );

    if (invalidAnswer) {
        return res.status(400).json({
            success: false,
            message:
                "One or more quiz answers are invalid."
        });
    }

    db.beginTransaction((transactionError) => {
        if (transactionError) {
            console.error(
                "Transaction start error:",
                transactionError.message
            );

            return res.status(500).json({
                success: false,
                message:
                    "Could not start quiz submission."
            });
        }

        const studentCheckSql = `
            SELECT student_id
            FROM students
            WHERE student_id = ?
        `;

        db.execute(
            studentCheckSql,
            [numericStudentId],
            (studentError, studentRows) => {
                if (
                    studentError ||
                    studentRows.length === 0
                ) {
                    return db.rollback(() => {
                        res.status(404).json({
                            success: false,
                            message:
                                "Student was not found."
                        });
                    });
                }

                const attemptSql = `
                    INSERT INTO quiz_attempts (
                        student_id,
                        status
                    )
                    VALUES (?, 'In Progress')
                `;

                db.execute(
                    attemptSql,
                    [numericStudentId],
                    (attemptError, attemptResult) => {
                        if (attemptError) {
                            console.error(
                                "Quiz attempt error:",
                                attemptError.message
                            );

                            return db.rollback(() => {
                                res.status(500).json({
                                    success: false,
                                    message:
                                        "Could not create quiz attempt."
                                });
                            });
                        }

                        const attemptId =
                            attemptResult.insertId;

                        const questionSql = `
                            SELECT
                                question_id,
                                question_order
                            FROM questions
                            WHERE is_active = TRUE
                            ORDER BY question_order
                        `;

                        db.execute(
                            questionSql,
                            (
                                questionError,
                                questionRows
                            ) => {
                                if (
                                    questionError ||
                                    questionRows.length !== 16
                                ) {
                                    console.error(
                                        "Questions loading error:",
                                        questionError
                                            ? questionError.message
                                            : "Expected 16 questions."
                                    );

                                    return db.rollback(() => {
                                        res.status(500).json({
                                            success: false,
                                            message:
                                                "Quiz questions are not configured correctly."
                                        });
                                    });
                                }

                                const answerValues =
                                    questionRows.map(
                                        (question) => [
                                            attemptId,
                                            question.question_id,
                                            Number(
                                                answers[
                                                    question.question_order
                                                ]
                                            )
                                        ]
                                    );

                                const insertAnswersSql = `
                                    INSERT INTO quiz_answers (
                                        attempt_id,
                                        question_id,
                                        answer_value
                                    )
                                    VALUES ?
                                `;

                                db.query(
                                    insertAnswersSql,
                                    [answerValues],
                                    (answersError) => {
                                        if (answersError) {
                                            console.error(
                                                "Answers saving error:",
                                                answersError.message
                                            );

                                            return db.rollback(
                                                () => {
                                                    res.status(
                                                        500
                                                    ).json({
                                                        success:
                                                            false,
                                                        message:
                                                            "Could not save quiz answers."
                                                    });
                                                }
                                            );
                                        }

                                        const scoreSql = `
                                            SELECT
                                                t.track_id,
                                                t.track_name,

                                                COALESCE(
                                                    SUM(
                                                        qa.answer_value *
                                                        qw.weight_value
                                                    ),
                                                    0
                                                ) AS total_score,

                                                COALESCE(
                                                    SUM(
                                                        5 *
                                                        qw.weight_value
                                                    ),
                                                    0
                                                ) AS maximum_score

                                            FROM tracks t

                                            LEFT JOIN question_weights qw
                                                ON t.track_id =
                                                   qw.track_id

                                            LEFT JOIN quiz_answers qa
                                                ON qw.question_id =
                                                   qa.question_id
                                                AND qa.attempt_id = ?

                                            WHERE t.is_active = TRUE

                                            GROUP BY
                                                t.track_id,
                                                t.track_name

                                            ORDER BY total_score DESC
                                        `;

                                        db.execute(
                                            scoreSql,
                                            [attemptId],
                                            (
                                                scoreError,
                                                scoreRows
                                            ) => {
                                                if (scoreError) {
                                                    console.error(
                                                        "Score calculation error:",
                                                        scoreError.message
                                                    );

                                                    return db.rollback(
                                                        () => {
                                                            res.status(
                                                                500
                                                            ).json({
                                                                success:
                                                                    false,
                                                                message:
                                                                    "Could not calculate quiz result."
                                                            });
                                                        }
                                                    );
                                                }

                                                const scoreValues =
                                                    scoreRows.map(
                                                        (track) => {
                                                            const totalScore =
                                                                Number(
                                                                    track.total_score
                                                                );

                                                            const maximumScore =
                                                                Number(
                                                                    track.maximum_score
                                                                );

                                                            const percentage =
                                                                maximumScore > 0
                                                                    ? (
                                                                          (totalScore /
                                                                              maximumScore) *
                                                                          100
                                                                      ).toFixed(
                                                                          2
                                                                      )
                                                                    : 0;

                                                            return [
                                                                attemptId,
                                                                track.track_id,
                                                                totalScore,
                                                                percentage
                                                            ];
                                                        }
                                                    );

                                                const insertScoresSql = `
                                                    INSERT INTO quiz_scores (
                                                        attempt_id,
                                                        track_id,
                                                        score,
                                                        match_percentage
                                                    )
                                                    VALUES ?
                                                `;

                                                db.query(
                                                    insertScoresSql,
                                                    [scoreValues],
                                                    (
                                                        saveScoresError
                                                    ) => {
                                                        if (
                                                            saveScoresError
                                                        ) {
                                                            console.error(
                                                                "Scores saving error:",
                                                                saveScoresError.message
                                                            );

                                                            return db.rollback(
                                                                () => {
                                                                    res.status(
                                                                        500
                                                                    ).json({
                                                                        success:
                                                                            false,
                                                                        message:
                                                                            "Could not save quiz scores."
                                                                    });
                                                                }
                                                            );
                                                        }

                                                        const completeSql = `
                                                            UPDATE quiz_attempts
                                                            SET
                                                                status = 'Completed',
                                                                completed_at =
                                                                    CURRENT_TIMESTAMP
                                                            WHERE attempt_id = ?
                                                        `;

                                                        db.execute(
                                                            completeSql,
                                                            [attemptId],
                                                            (
                                                                completeError
                                                            ) => {
                                                                if (
                                                                    completeError
                                                                ) {
                                                                    console.error(
                                                                        "Attempt completion error:",
                                                                        completeError.message
                                                                    );

                                                                    return db.rollback(
                                                                        () => {
                                                                            res.status(
                                                                                500
                                                                            ).json({
                                                                                success:
                                                                                    false,
                                                                                message:
                                                                                    "Could not complete quiz attempt."
                                                                            });
                                                                        }
                                                                    );
                                                                }

                                                                db.commit(
                                                                    (
                                                                        commitError
                                                                    ) => {
                                                                        if (
                                                                            commitError
                                                                        ) {
                                                                            console.error(
                                                                                "Commit error:",
                                                                                commitError.message
                                                                            );

                                                                            return db.rollback(
                                                                                () => {
                                                                                    res.status(
                                                                                        500
                                                                                    ).json({
                                                                                        success:
                                                                                            false,
                                                                                        message:
                                                                                            "Could not complete quiz submission."
                                                                                    });
                                                                                }
                                                                            );
                                                                        }

                                                                        const rankedTracks =
                                                                            scoreRows.map(
                                                                                (
                                                                                    track
                                                                                ) => {
                                                                                    const totalScore =
                                                                                        Number(
                                                                                            track.total_score
                                                                                        );

                                                                                    const maximumScore =
                                                                                        Number(
                                                                                            track.maximum_score
                                                                                        );

                                                                                    const matchPercentage =
                                                                                        maximumScore > 0
                                                                                            ? Number(
                                                                                                  (
                                                                                                      (totalScore /
                                                                                                          maximumScore) *
                                                                                                      100
                                                                                                  ).toFixed(
                                                                                                      2
                                                                                                  )
                                                                                              )
                                                                                            : 0;

                                                                                    return {
                                                                                        track_id:
                                                                                            track.track_id,

                                                                                        track_name:
                                                                                            track.track_name,

                                                                                        score:
                                                                                            totalScore,

                                                                                        match_percentage:
                                                                                            matchPercentage
                                                                                    };
                                                                                }
                                                                            );

                                                                        rankedTracks.sort(
                                                                            (
                                                                                a,
                                                                                b
                                                                            ) =>
                                                                                b.match_percentage -
                                                                                a.match_percentage
                                                                        );

                                                                        res.json({
                                                                            success:
                                                                                true,

                                                                            message:
                                                                                "Quiz completed successfully.",

                                                                            attempt_id:
                                                                                attemptId,

                                                                            best_match:
                                                                                rankedTracks[0],

                                                                            second_match:
                                                                                rankedTracks[1],

                                                                            all_tracks:
                                                                                rankedTracks
                                                                        });
                                                                    }
                                                                );
                                                            }
                                                        );
                                                    }
                                                );
                                            }
                                        );
                                    }
                                );
                            }
                        );
                    }
                );
            }
        );
    });
});

/* =========================
   Recommendation API
========================= */

app.get(
    "/api/recommendation/:attemptId",
    (req, res) => {
        const attemptId = Number(
            req.params.attemptId
        );

        if (
            !Number.isInteger(attemptId) ||
            attemptId <= 0
        ) {
            return res.status(400).json({
                success: false,
                message:
                    "Invalid quiz attempt ID."
            });
        }

        const attemptSql = `
            SELECT
                qa.attempt_id,
                qa.status,
                s.student_id,
                s.full_name,
                s.email,
                s.faculty,
                s.study_year

            FROM quiz_attempts qa

            JOIN students s
                ON qa.student_id =
                   s.student_id

            WHERE qa.attempt_id = ?
              AND qa.status = 'Completed'
        `;

        db.execute(
            attemptSql,
            [attemptId],
            (
                attemptError,
                attemptRows
            ) => {
                if (attemptError) {
                    console.error(
                        "Recommendation attempt error:",
                        attemptError.message
                    );

                    return res.status(500).json({
                        success: false,
                        message:
                            "Could not load quiz attempt."
                    });
                }

                if (attemptRows.length === 0) {
                    return res.status(404).json({
                        success: false,
                        message:
                            "Completed quiz attempt was not found."
                    });
                }

                const scoresSql = `
                    SELECT
                        t.track_id,
                        t.track_name,
                        t.short_description,
                        t.has_mini_task,
                        qs.score,
                        qs.match_percentage

                    FROM quiz_scores qs

                    JOIN tracks t
                        ON qs.track_id =
                           t.track_id

                    WHERE qs.attempt_id = ?

                    ORDER BY
                        qs.match_percentage DESC,
                        qs.score DESC,
                        t.track_name ASC
                `;

                db.execute(
                    scoresSql,
                    [attemptId],
                    (
                        scoresError,
                        scoreRows
                    ) => {
                        if (scoresError) {
                            console.error(
                                "Recommendation scores error:",
                                scoresError.message
                            );

                            return res.status(500).json({
                                success: false,
                                message:
                                    "Could not load recommendation scores."
                            });
                        }

                        if (scoreRows.length !== 8) {
                            return res
                                .status(500)
                                .json({
                                    success: false,
                                    message:
                                        "The recommendation result is incomplete."
                                });
                        }

                        const strengthSql = `
                            SELECT
                                d.dimension_id,
                                d.dimension_name,
                                d.dimension_description,

                                ROUND(
                                    (
                                        SUM(
                                            qa.answer_value *
                                            qdw.weight_value
                                        )
                                        /
                                        SUM(
                                            5 *
                                            qdw.weight_value
                                        )
                                    ) * 100,
                                    2
                                ) AS percentage

                            FROM strength_dimensions d

                            JOIN question_dimension_weights qdw
                                ON d.dimension_id =
                                   qdw.dimension_id

                            JOIN quiz_answers qa
                                ON qdw.question_id =
                                   qa.question_id

                            WHERE qa.attempt_id = ?

                            GROUP BY
                                d.dimension_id,
                                d.dimension_name,
                                d.dimension_description

                            ORDER BY
                                percentage DESC,
                                d.dimension_name ASC
                        `;

                        db.execute(
                            strengthSql,
                            [attemptId],
                            (
                                strengthError,
                                strengthRows
                            ) => {
                                if (strengthError) {
                                    console.error(
                                        "Strength profile error:",
                                        strengthError.message
                                    );

                                    return res
                                        .status(500)
                                        .json({
                                            success:
                                                false,

                                            message:
                                                "Could not load the student strength profile."
                                        });
                                }

                                const tracks =
                                    scoreRows.map(
                                        (track) => ({
                                            track_id:
                                                track.track_id,

                                            track_name:
                                                track.track_name,

                                            short_description:
                                                track.short_description,

                                            has_mini_task:
                                                Boolean(
                                                    track.has_mini_task
                                                ),

                                            score:
                                                Number(
                                                    track.score
                                                ),

                                            match_percentage:
                                                Number(
                                                    track.match_percentage
                                                )
                                        })
                                    );

                                const strengthProfile =
                                    strengthRows.map(
                                        (dimension) => ({
                                            dimension_id:
                                                dimension.dimension_id,

                                            dimension_name:
                                                dimension.dimension_name,

                                            dimension_description:
                                                dimension.dimension_description,

                                            percentage:
                                                Number(
                                                    dimension.percentage
                                                )
                                        })
                                    );

                                res.json({
                                    success: true,

                                    attempt_id:
                                        attemptId,

                                    student: {
                                        student_id:
                                            attemptRows[0]
                                                .student_id,

                                        full_name:
                                            attemptRows[0]
                                                .full_name,

                                        email:
                                            attemptRows[0]
                                                .email,

                                        faculty:
                                            attemptRows[0]
                                                .faculty,

                                        study_year:
                                            attemptRows[0]
                                                .study_year
                                    },

                                    tracks,

                                    strength_profile:
                                        strengthProfile
                                });
                            }
                        );
                    }
                );
            }
        );
    }
);

/* =========================
   All Tracks API
========================= */

app.get("/api/tracks", (req, res) => {
    const sql = `
        SELECT
            track_id,
            track_name,
            short_description,
            coding_level,
            math_level,
            creativity_level,
            data_level,
            has_mini_task
        FROM tracks
        WHERE is_active = TRUE
        ORDER BY track_id
    `;

    db.execute(sql, (error, rows) => {
        if (error) {
            console.error(
                "Tracks loading error:",
                error.message
            );

            return res.status(500).json({
                success: false,
                message:
                    "Could not load the technology tracks."
            });
        }

        const tracks = rows.map((track) => ({
            track_id:
                track.track_id,

            track_name:
                track.track_name,

            short_description:
                track.short_description,

            coding_level:
                track.coding_level,

            math_level:
                track.math_level,

            creativity_level:
                track.creativity_level,

            data_level:
                track.data_level,

            has_mini_task:
                Boolean(track.has_mini_task)
        }));

        res.json({
            success: true,
            tracks
        });
    });
});

/* =========================
   Track Details API
========================= */

app.get("/api/tracks/:trackId", (req, res) => {
    const trackId = Number(req.params.trackId);

    if (
        !Number.isInteger(trackId) ||
        trackId <= 0
    ) {
        return res.status(400).json({
            success: false,
            message: "Invalid track ID."
        });
    }

    const trackSql = `
        SELECT
            track_id,
            track_name,
            short_description,
            full_description,
            coding_level,
            math_level,
            creativity_level,
            data_level,
            has_mini_task
        FROM tracks
        WHERE track_id = ?
          AND is_active = TRUE
    `;

    db.execute(
        trackSql,
        [trackId],
        (trackError, trackRows) => {
            if (trackError) {
                console.error(
                    "Track details error:",
                    trackError.message
                );

                return res.status(500).json({
                    success: false,
                    message:
                        "Could not load track details."
                });
            }

            if (trackRows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message:
                        "Track was not found."
                });
            }

            const skillsSql = `
                SELECT
                    skill_id,
                    skill_name
                FROM track_skills
                WHERE track_id = ?
                ORDER BY skill_id
            `;

            db.execute(
                skillsSql,
                [trackId],
                (skillsError, skillRows) => {
                    if (skillsError) {
                        console.error(
                            "Track skills error:",
                            skillsError.message
                        );

                        return res.status(500).json({
                            success: false,
                            message:
                                "Could not load track skills."
                        });
                    }

                    const toolsSql = `
                        SELECT
                            tool_id,
                            tool_name
                        FROM track_tools
                        WHERE track_id = ?
                        ORDER BY tool_id
                    `;

                    db.execute(
                        toolsSql,
                        [trackId],
                        (toolsError, toolRows) => {
                            if (toolsError) {
                                console.error(
                                    "Track tools error:",
                                    toolsError.message
                                );

                                return res.status(500).json({
                                    success: false,
                                    message:
                                        "Could not load track tools."
                                });
                            }

                            const rolesSql = `
                                SELECT
                                    job_role_id,
                                    job_role_name
                                FROM track_job_roles
                                WHERE track_id = ?
                                ORDER BY job_role_id
                            `;

                            db.execute(
                                rolesSql,
                                [trackId],
                                (
                                    rolesError,
                                    roleRows
                                ) => {
                                    if (rolesError) {
                                        console.error(
                                            "Track job roles error:",
                                            rolesError.message
                                        );

                                        return res
                                            .status(500)
                                            .json({
                                                success: false,
                                                message:
                                                    "Could not load track job roles."
                                            });
                                    }

                                    const roadmapSql = `
                                        SELECT
                                            step_id,
                                            step_number,
                                            step_title,
                                            step_description
                                        FROM track_roadmap_steps
                                        WHERE track_id = ?
                                        ORDER BY step_number
                                    `;

                                    db.execute(
                                        roadmapSql,
                                        [trackId],
                                        (
                                            roadmapError,
                                            roadmapRows
                                        ) => {
                                            if (roadmapError) {
                                                console.error(
                                                    "Roadmap loading error:",
                                                    roadmapError.message
                                                );

                                                return res
                                                    .status(500)
                                                    .json({
                                                        success: false,
                                                        message:
                                                            "Could not load the track roadmap."
                                                    });
                                            }

                                            const track =
                                                trackRows[0];

                                            res.json({
                                                success: true,

                                                track: {
                                                    track_id:
                                                        track.track_id,

                                                    track_name:
                                                        track.track_name,

                                                    short_description:
                                                        track.short_description,

                                                    full_description:
                                                        track.full_description,

                                                    coding_level:
                                                        track.coding_level,

                                                    math_level:
                                                        track.math_level,

                                                    creativity_level:
                                                        track.creativity_level,

                                                    data_level:
                                                        track.data_level,

                                                    has_mini_task:
                                                        Boolean(
                                                            track.has_mini_task
                                                        ),

                                                    skills:
                                                        skillRows.map(
                                                            (skill) =>
                                                                skill.skill_name
                                                        ),

                                                    tools:
                                                        toolRows.map(
                                                            (tool) =>
                                                                tool.tool_name
                                                        ),

                                                    job_roles:
                                                        roleRows.map(
                                                            (role) =>
                                                                role.job_role_name
                                                        ),

                                                    roadmap_steps:
                                                        roadmapRows
                                                }
                                            });
                                        }
                                    );
                                }
                            );
                        }
                    );
                }
            );
        }
    );
});




/* =========================
   Mini Task API
========================= */

app.get(
    "/api/mini-task/:trackId",
    (req, res) => {
        const trackId = Number(
            req.params.trackId
        );

        if (
            !Number.isInteger(trackId) ||
            trackId <= 0
        ) {
            return res.status(400).json({
                success: false,
                message: "Invalid track ID."
            });
        }

        const sql = `
            SELECT
                mt.task_id,
                mt.track_id,
                mt.task_title,
                mt.task_description,
                mt.option_a,
                mt.option_b,
                mt.option_c,
                mt.option_d,
                mt.correct_option,
                mt.explanation,
                t.track_name
            FROM mini_tasks mt
            JOIN tracks t
                ON mt.track_id = t.track_id
            WHERE mt.track_id = ?
              AND t.is_active = TRUE
            ORDER BY mt.task_id
            LIMIT 1
        `;

        db.execute(
            sql,
            [trackId],
            (error, rows) => {
                if (error) {
                    console.error(
                        "Mini task loading error:",
                        error.message
                    );

                    return res.status(500).json({
                        success: false,
                        message:
                            "Could not load the career experience."
                    });
                }

                if (rows.length === 0) {
                    return res.status(404).json({
                        success: false,
                        message:
                            "No career experience is available for this track yet."
                    });
                }

                res.json({
                    success: true,
                    task: rows[0]
                });
            }
        );
    }
);

app.post(
    "/api/mini-task/submit",
    (req, res) => {
        const {
            student_id,
            task_id,
            selected_option,
            enjoyment_rating,
            wants_to_continue
        } = req.body;

        const studentId =
            Number(student_id);

        const taskId =
            Number(task_id);

        const rating =
            Number(enjoyment_rating);

        const continueChoice =
            Number(wants_to_continue);

        const normalizedOption =
            typeof selected_option === "string"
                ? selected_option
                      .trim()
                      .toUpperCase()
                : "";

        const allowedOptions = [
            "A",
            "B",
            "C",
            "D"
        ];

        if (
            !Number.isInteger(studentId) ||
            studentId <= 0
        ) {
            return res.status(400).json({
                success: false,
                message: "Invalid student ID."
            });
        }

        if (
            !Number.isInteger(taskId) ||
            taskId <= 0
        ) {
            return res.status(400).json({
                success: false,
                message: "Invalid task ID."
            });
        }

        if (
            !allowedOptions.includes(
                normalizedOption
            )
        ) {
            return res.status(400).json({
                success: false,
                message:
                    "Invalid selected option."
            });
        }

        if (
            !Number.isInteger(rating) ||
            rating < 1 ||
            rating > 5
        ) {
            return res.status(400).json({
                success: false,
                message:
                    "Enjoyment rating must be between 1 and 5."
            });
        }

        if (
            ![0, 1].includes(
                continueChoice
            )
        ) {
            return res.status(400).json({
                success: false,
                message:
                    "Invalid continuation choice."
            });
        }

        const studentSql = `
            SELECT student_id
            FROM students
            WHERE student_id = ?
        `;

        db.execute(
            studentSql,
            [studentId],
            (
                studentError,
                studentRows
            ) => {
                if (studentError) {
                    console.error(
                        "Student validation error:",
                        studentError.message
                    );

                    return res.status(500).json({
                        success: false,
                        message:
                            "Could not validate the student."
                    });
                }

                if (
                    studentRows.length === 0
                ) {
                    return res.status(404).json({
                        success: false,
                        message:
                            "Student was not found."
                    });
                }

                const taskSql = `
                    SELECT
                        task_id,
                        correct_option
                    FROM mini_tasks
                    WHERE task_id = ?
                `;

                db.execute(
                    taskSql,
                    [taskId],
                    (
                        taskError,
                        taskRows
                    ) => {
                        if (taskError) {
                            console.error(
                                "Task validation error:",
                                taskError.message
                            );

                            return res
                                .status(500)
                                .json({
                                    success:
                                        false,

                                    message:
                                        "Could not validate the task."
                                });
                        }

                        if (
                            taskRows.length === 0
                        ) {
                            return res
                                .status(404)
                                .json({
                                    success:
                                        false,

                                    message:
                                        "Task was not found."
                                });
                        }

                        const correctOption =
                            String(
                                taskRows[0]
                                    .correct_option
                            ).toUpperCase();

                        const isCorrect =
                            normalizedOption ===
                            correctOption;

                        const insertSql = `
                            INSERT INTO task_attempts (
                                student_id,
                                task_id,
                                selected_option,
                                is_correct,
                                enjoyment_rating,
                                wants_to_continue
                            )
                            VALUES (?, ?, ?, ?, ?, ?)
                        `;

                        const values = [
                            studentId,
                            taskId,
                            normalizedOption,
                            isCorrect ? 1 : 0,
                            rating,
                            continueChoice
                        ];

                        db.execute(
                            insertSql,
                            values,
                            (
                                insertError,
                                insertResult
                            ) => {
                                if (
                                    insertError
                                ) {
                                    console.error(
                                        "Task attempt saving error:",
                                        insertError.message
                                    );

                                    return res
                                        .status(500)
                                        .json({
                                            success:
                                                false,

                                            message:
                                                "Could not save the career experience."
                                        });
                                }

                                res.json({
                                    success: true,

                                    message:
                                        "Career experience saved successfully.",

                                    task_attempt_id:
                                        insertResult.insertId,

                                    is_correct:
                                        isCorrect
                                });
                            }
                        );
                    }
                );
            }
        );
    }
);

/* =========================
   Task Attempt Result API
========================= */

app.get(
    "/api/task-attempts/:taskAttemptId",
    (req, res) => {
        const taskAttemptId = Number(
            req.params.taskAttemptId
        );

        if (
            !Number.isInteger(taskAttemptId) ||
            taskAttemptId <= 0
        ) {
            return res.status(400).json({
                success: false,
                message:
                    "Invalid task attempt ID."
            });
        }

        const sql = `
            SELECT
                ta.task_attempt_id,
                ta.student_id,
                ta.task_id,
                ta.selected_option,
                ta.is_correct,
                ta.enjoyment_rating,
                ta.wants_to_continue,
                ta.created_at,

                s.full_name,
                s.email,

                mt.task_title,
                mt.correct_option,

                t.track_id,
                t.track_name,
                t.short_description

            FROM task_attempts ta

            JOIN students s
                ON ta.student_id =
                   s.student_id

            JOIN mini_tasks mt
                ON ta.task_id =
                   mt.task_id

            JOIN tracks t
                ON mt.track_id =
                   t.track_id

            WHERE ta.task_attempt_id = ?
        `;

        db.execute(
            sql,
            [taskAttemptId],
            (error, rows) => {
                if (error) {
                    console.error(
                        "Task attempt loading error:",
                        error.message
                    );

                    return res.status(500).json({
                        success: false,
                        message:
                            "Could not load the career experience result."
                    });
                }

                if (rows.length === 0) {
                    return res.status(404).json({
                        success: false,
                        message:
                            "Task attempt was not found."
                    });
                }

                const row = rows[0];

                res.json({
                    success: true,

                    attempt: {
                        task_attempt_id:
                            row.task_attempt_id,

                        student_id:
                            row.student_id,

                        full_name:
                            row.full_name,

                        email:
                            row.email,

                        task_id:
                            row.task_id,

                        task_title:
                            row.task_title,

                        track_id:
                            row.track_id,

                        track_name:
                            row.track_name,

                        short_description:
                            row.short_description,

                        selected_option:
                            row.selected_option,

                        correct_option:
                            row.correct_option,

                        is_correct:
                            Boolean(row.is_correct),

                        enjoyment_rating:
                            Number(
                                row.enjoyment_rating
                            ),

                        wants_to_continue:
                            Boolean(
                                row.wants_to_continue
                            ),

                        created_at:
                            row.created_at
                    }
                });
            }
        );
    }
);
/* =========================
   Admin Dashboard API
========================= */

app.get("/api/admin/dashboard", async (req, res) => {
    try {
        const database = db.promise();

        const [summaryRows] = await database.query(`
            SELECT
                (
                    SELECT COUNT(*)
                    FROM students
                ) AS total_students,

                (
                    SELECT COUNT(*)
                    FROM quiz_attempts
                    WHERE status = 'Completed'
                ) AS total_quiz_attempts,

                (
                    SELECT COUNT(*)
                    FROM task_attempts
                ) AS total_task_attempts,

                (
                    SELECT COUNT(*)
                    FROM tracks
                    WHERE is_active = TRUE
                ) AS total_tracks
        `);

        const [experienceRows] = await database.query(`
            SELECT
                COALESCE(
                    ROUND(
                        AVG(enjoyment_rating),
                        2
                    ),
                    0
                ) AS average_enjoyment,

                COALESCE(
                    ROUND(
                        AVG(is_correct) * 100,
                        2
                    ),
                    0
                ) AS correct_percentage,

                COALESCE(
                    ROUND(
                        AVG(wants_to_continue) * 100,
                        2
                    ),
                    0
                ) AS continue_percentage

            FROM task_attempts
        `);

        const [trackStatisticRows] =
            await database.query(`
                SELECT
                    t.track_id,
                    t.track_name,
                    COUNT(*) AS recommendation_count

                FROM quiz_scores qs

                JOIN tracks t
                    ON qs.track_id = t.track_id

                JOIN quiz_attempts qa
                    ON qs.attempt_id = qa.attempt_id

                WHERE qa.status = 'Completed'

                AND NOT EXISTS (
                    SELECT 1

                    FROM quiz_scores better_qs

                    JOIN tracks better_t
                        ON better_qs.track_id =
                           better_t.track_id

                    WHERE better_qs.attempt_id =
                          qs.attempt_id

                    AND (
                        better_qs.match_percentage >
                        qs.match_percentage

                        OR (
                            better_qs.match_percentage =
                            qs.match_percentage

                            AND better_qs.score >
                                qs.score
                        )

                        OR (
                            better_qs.match_percentage =
                            qs.match_percentage

                            AND better_qs.score =
                                qs.score

                            AND better_t.track_name <
                                t.track_name
                        )
                    )
                )

                GROUP BY
                    t.track_id,
                    t.track_name

                ORDER BY
                    recommendation_count DESC,
                    t.track_name ASC
            `);

        const [studentRows] =
            await database.query(`
                SELECT
                    s.student_id,
                    s.full_name,
                    s.email,
                    s.faculty,
                    s.study_year,

                    (
                        SELECT
                            t.track_name

                        FROM quiz_attempts qa

                        JOIN quiz_scores qs
                            ON qa.attempt_id =
                               qs.attempt_id

                        JOIN tracks t
                            ON qs.track_id =
                               t.track_id

                        WHERE qa.student_id =
                              s.student_id

                        AND qa.status =
                            'Completed'

                        ORDER BY
                            qa.completed_at DESC,
                            qa.attempt_id DESC,
                            qs.match_percentage DESC,
                            qs.score DESC,
                            t.track_name ASC

                        LIMIT 1
                    ) AS recommended_track,

                    (
                        SELECT
                            qs.match_percentage

                        FROM quiz_attempts qa

                        JOIN quiz_scores qs
                            ON qa.attempt_id =
                               qs.attempt_id

                        JOIN tracks t
                            ON qs.track_id =
                               t.track_id

                        WHERE qa.student_id =
                              s.student_id

                        AND qa.status =
                            'Completed'

                        ORDER BY
                            qa.completed_at DESC,
                            qa.attempt_id DESC,
                            qs.match_percentage DESC,
                            qs.score DESC,
                            t.track_name ASC

                        LIMIT 1
                    ) AS match_percentage

                FROM students s

                ORDER BY
                    s.student_id DESC

                LIMIT 50
            `);

        const [activityRows] =
            await database.query(`
                SELECT
                    ta.task_attempt_id,
                    s.full_name,
                    t.track_name,
                    ta.is_correct,
                    ta.enjoyment_rating,
                    ta.wants_to_continue,
                    ta.created_at

                FROM task_attempts ta

                JOIN students s
                    ON ta.student_id =
                       s.student_id

                JOIN mini_tasks mt
                    ON ta.task_id =
                       mt.task_id

                JOIN tracks t
                    ON mt.track_id =
                       t.track_id

                ORDER BY
                    ta.created_at DESC,
                    ta.task_attempt_id DESC

                LIMIT 20
            `);

        const summary =
            summaryRows[0] || {};

        const experienceSummary =
            experienceRows[0] || {};

        res.json({
            success: true,

            dashboard: {
                summary: {
                    total_students:
                        Number(
                            summary.total_students || 0
                        ),

                    total_quiz_attempts:
                        Number(
                            summary.total_quiz_attempts || 0
                        ),

                    total_task_attempts:
                        Number(
                            summary.total_task_attempts || 0
                        ),

                    total_tracks:
                        Number(
                            summary.total_tracks || 0
                        )
                },

                experience_summary: {
                    average_enjoyment:
                        Number(
                            experienceSummary
                                .average_enjoyment || 0
                        ),

                    correct_percentage:
                        Number(
                            experienceSummary
                                .correct_percentage || 0
                        ),

                    continue_percentage:
                        Number(
                            experienceSummary
                                .continue_percentage || 0
                        )
                },

                track_statistics:
                    trackStatisticRows.map(
                        (track) => ({
                            track_id:
                                track.track_id,

                            track_name:
                                track.track_name,

                            recommendation_count:
                                Number(
                                    track.recommendation_count
                                )
                        })
                    ),

                students:
                    studentRows.map(
                        (student) => ({
                            student_id:
                                student.student_id,

                            full_name:
                                student.full_name,

                            email:
                                student.email,

                            faculty:
                                student.faculty,

                            study_year:
                                student.study_year,

                            recommended_track:
                                student.recommended_track,

                            match_percentage:
                                student.match_percentage === null
                                    ? null
                                    : Number(
                                          student.match_percentage
                                      )
                        })
                    ),

                recent_activities:
                    activityRows.map(
                        (activity) => ({
                            task_attempt_id:
                                activity.task_attempt_id,

                            full_name:
                                activity.full_name,

                            track_name:
                                activity.track_name,

                            is_correct:
                                Boolean(
                                    activity.is_correct
                                ),

                            enjoyment_rating:
                                Number(
                                    activity.enjoyment_rating
                                ),

                            wants_to_continue:
                                Boolean(
                                    activity.wants_to_continue
                                ),

                            created_at:
                                activity.created_at
                        })
                    )
            }
        });

    } catch (error) {
        console.error(
            "Admin dashboard error:",
            error.message
        );

        res.status(500).json({
            success: false,
            message:
                "Could not load the admin dashboard."
        });
    }
});

/* =========================
   Start Server
========================= */

const PORT =
    process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(
        `Server is running on http://localhost:${PORT}`
    );
});
