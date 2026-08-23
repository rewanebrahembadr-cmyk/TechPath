const loadingSection = document.getElementById(
    "admin-loading"
);

const contentSection = document.getElementById(
    "admin-content"
);

const errorSection = document.getElementById(
    "admin-error"
);

const errorMessage = document.getElementById(
    "admin-error-message"
);

const refreshButton = document.getElementById(
    "refresh-dashboard-button"
);

const retryButton = document.getElementById(
    "retry-dashboard-button"
);

const totalStudents = document.getElementById(
    "total-students"
);

const totalQuizAttempts = document.getElementById(
    "total-quiz-attempts"
);

const totalTaskAttempts = document.getElementById(
    "total-task-attempts"
);

const totalTracks = document.getElementById(
    "total-tracks"
);

const averageEnjoyment = document.getElementById(
    "average-enjoyment"
);

const correctTaskPercentage = document.getElementById(
    "correct-task-percentage"
);

const continuePercentage = document.getElementById(
    "continue-percentage"
);

const trackStatistics = document.getElementById(
    "track-statistics"
);

const studentsTableBody = document.getElementById(
    "students-table-body"
);

const activityTableBody = document.getElementById(
    "activity-table-body"
);

const studentSearch = document.getElementById(
    "student-search"
);

let allStudents = [];

function showLoading() {
    loadingSection.classList.remove("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.add("hidden");
}

function showError(message) {
    loadingSection.classList.add("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function showContent() {
    loadingSection.classList.add("hidden");
    errorSection.classList.add("hidden");
    contentSection.classList.remove("hidden");
}

function formatPercentage(value) {
    const number = Number(value);

    if (!Number.isFinite(number)) {
        return "0%";
    }

    return `${number.toFixed(1)}%`;
}

function formatDate(value) {
    if (!value) {
        return "-";
    }

    const date = new Date(value);

    if (Number.isNaN(date.getTime())) {
        return "-";
    }

    return date.toLocaleString();
}

function createTrackStatistics(tracks) {
    trackStatistics.innerHTML = "";

    if (!Array.isArray(tracks) || tracks.length === 0) {
        trackStatistics.innerHTML = `
            <p>No recommendation statistics are available yet.</p>
        `;

        return;
    }

    const highestCount = Math.max(
        ...tracks.map((track) =>
            Number(track.recommendation_count)
        ),
        1
    );

    tracks.forEach((track) => {
        const count = Number(
            track.recommendation_count
        );

        const width =
            (count / highestCount) * 100;

        const item = document.createElement("article");

        item.className = "track-statistic-item";

        item.innerHTML = `
            <div class="track-statistic-heading">
                <strong>${track.track_name}</strong>
                <span>${count} recommendations</span>
            </div>

            <div class="admin-progress-track">
                <div
                    class="admin-progress-value"
                    style="width: ${width}%"
                ></div>
            </div>
        `;

        trackStatistics.appendChild(item);
    });
}

function createStudentsTable(students) {
    studentsTableBody.innerHTML = "";

    if (!Array.isArray(students) || students.length === 0) {
        studentsTableBody.innerHTML = `
            <tr>
                <td colspan="7">
                    No student records were found.
                </td>
            </tr>
        `;

        return;
    }

    students.forEach((student) => {
        const row = document.createElement("tr");

        row.innerHTML = `
            <td>${student.student_id}</td>

            <td>
                <strong>${student.full_name}</strong>
            </td>

            <td>${student.email}</td>

            <td>${student.faculty}</td>

            <td>${student.study_year}</td>

            <td>
                ${
                    student.recommended_track ||
                    "Quiz not completed"
                }
            </td>

            <td>
                ${
                    student.match_percentage !== null
                        ? formatPercentage(
                              student.match_percentage
                          )
                        : "-"
                }
            </td>
        `;

        studentsTableBody.appendChild(row);
    });
}

function createActivityTable(activities) {
    activityTableBody.innerHTML = "";

    if (
        !Array.isArray(activities) ||
        activities.length === 0
    ) {
        activityTableBody.innerHTML = `
            <tr>
                <td colspan="6">
                    No career experiences were found.
                </td>
            </tr>
        `;

        return;
    }

    activities.forEach((activity) => {
        const row = document.createElement("tr");

        row.innerHTML = `
            <td>${activity.full_name}</td>

            <td>${activity.track_name}</td>

            <td>
                ${
                    activity.is_correct
                        ? "Correct"
                        : "Learning Opportunity"
                }
            </td>

            <td>
                ${activity.enjoyment_rating} / 5
            </td>

            <td>
                ${
                    activity.wants_to_continue
                        ? "Yes"
                        : "Not Yet"
                }
            </td>

            <td>
                ${formatDate(activity.created_at)}
            </td>
        `;

        activityTableBody.appendChild(row);
    });
}

function updateDashboard(data) {
    totalStudents.textContent =
        data.summary.total_students;

    totalQuizAttempts.textContent =
        data.summary.total_quiz_attempts;

    totalTaskAttempts.textContent =
        data.summary.total_task_attempts;

    totalTracks.textContent =
        data.summary.total_tracks;

    averageEnjoyment.textContent =
        `${Number(
            data.experience_summary.average_enjoyment
        ).toFixed(1)} / 5`;

    correctTaskPercentage.textContent =
        formatPercentage(
            data.experience_summary.correct_percentage
        );

    continuePercentage.textContent =
        formatPercentage(
            data.experience_summary.continue_percentage
        );

    createTrackStatistics(
        data.track_statistics
    );

    allStudents = data.students;

    createStudentsTable(allStudents);

    createActivityTable(
        data.recent_activities
    );
}

async function loadDashboard() {
    showLoading();

    refreshButton.disabled = true;
    refreshButton.textContent = "Refreshing...";

    try {
        const response = await fetch(
            "/api/admin/dashboard"
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load the admin dashboard."
            );
        }

        updateDashboard(result.dashboard);

        showContent();

    } catch (error) {
        console.error(
            "Admin dashboard error:",
            error
        );

        showError(error.message);

    } finally {
        refreshButton.disabled = false;
        refreshButton.textContent =
            "Refresh Dashboard";
    }
}

studentSearch.addEventListener("input", () => {
    const searchValue =
        studentSearch.value
            .trim()
            .toLowerCase();

    const filteredStudents =
        allStudents.filter((student) => {
            return (
                student.full_name
                    .toLowerCase()
                    .includes(searchValue) ||
                student.email
                    .toLowerCase()
                    .includes(searchValue)
            );
        });

    createStudentsTable(filteredStudents);
});

refreshButton.addEventListener(
    "click",
    loadDashboard
);

retryButton.addEventListener(
    "click",
    loadDashboard
);

loadDashboard();