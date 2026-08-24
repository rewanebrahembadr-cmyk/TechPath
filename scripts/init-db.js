const fs = require("fs");
const path = require("path");
const mysql = require("mysql2/promise");
require("dotenv").config();

async function initializeDatabase() {
    const requiredVariables = [
        "DB_HOST",
        "DB_USER",
        "DB_PASSWORD",
        "DB_NAME"
    ];

    const missingVariables = requiredVariables.filter(
        (name) => !process.env[name]
    );

    if (missingVariables.length > 0) {
        throw new Error(
            `Missing database environment variables: ${missingVariables.join(", ")}`
        );
    }

    const connection = await mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        multipleStatements: true
    });

    try {
        const [trackTables] = await connection.query(
            "SHOW TABLES LIKE 'tracks'"
        );
        const [roadmapTables] = await connection.query(
            "SHOW TABLES LIKE 'track_roadmap_steps'"
        );

        if (trackTables.length > 0 && roadmapTables.length > 0) {
            const [trackRows] = await connection.query(
                "SELECT COUNT(*) AS count FROM tracks"
            );
            const [questionRows] = await connection.query(
                "SELECT COUNT(*) AS count FROM questions"
            );

            if (
                Number(trackRows[0].count) >= 8 &&
                Number(questionRows[0].count) >= 16
            ) {
                console.log("Database is already initialized.");
                return;
            }
        }

        console.log("Initializing TechPath database...");

        const schemaPath = path.join(
            __dirname,
            "..",
            "database",
            "schema.sql"
        );
        const seedPath = path.join(
            __dirname,
            "..",
            "database",
            "seed.sql"
        );

        let schemaSql = fs.readFileSync(schemaPath, "utf8");
        let seedSql = fs.readFileSync(seedPath, "utf8");

        // Railway creates and selects the database for us. Remove the
        // local-only database creation statements before executing SQL.
        schemaSql = schemaSql.replace(
            /DROP DATABASE IF EXISTS techpath_db;[\s\S]*?USE techpath_db;/i,
            ""
        );
        seedSql = seedSql.replace(/USE techpath_db;/i, "");

        await connection.query(schemaSql);
        await connection.query(seedSql);

        console.log("TechPath database initialized successfully.");
    } finally {
        await connection.end();
    }
}

initializeDatabase().catch((error) => {
    console.error("Database initialization failed:", error.message);
    process.exit(1);
});
