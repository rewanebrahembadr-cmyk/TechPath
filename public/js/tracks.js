const loadingSection = document.getElementById(
    "tracks-loading"
);

const contentSection = document.getElementById(
    "tracks-content"
);

const errorSection = document.getElementById(
    "tracks-error"
);

const errorMessage = document.getElementById(
    "tracks-error-message"
);

const tracksGrid = document.getElementById(
    "tracks-grid"
);

const queryParameters = new URLSearchParams(
    window.location.search
);

const studentId = queryParameters.get("student_id");
const attemptId = queryParameters.get("attempt_id");

function showError(message) {
    loadingSection.classList.add("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function createLevelItem(label, value) {
    return `
        <div class="track-level-item">
            <span>${label}</span>
            <strong>${value || "Not specified"}</strong>
        </div>
    `;
}

function createTrackCard(track) {
    const card = document.createElement("article");

    card.className = "explore-track-card";

    const detailsParameters = new URLSearchParams({
        track_id: track.track_id
    });

    if (studentId) {
        detailsParameters.set(
            "student_id",
            studentId
        );
    }

    if (attemptId) {
        detailsParameters.set(
            "attempt_id",
            attemptId
        );
    }

    const detailsUrl =
        `/track-details?${detailsParameters.toString()}`;

    const taskParameters = new URLSearchParams({
        track_id: track.track_id
    });

    if (studentId) {
        taskParameters.set(
            "student_id",
            studentId
        );
    }

    if (attemptId) {
        taskParameters.set(
            "attempt_id",
            attemptId
        );
    }

    const taskUrl =
        `/mini-task?${taskParameters.toString()}`;

    let experienceButton;

    if (track.has_mini_task && studentId) {
        experienceButton = `
            <a
                href="${taskUrl}"
                class="secondary-button"
            >
                Try Career Experience
            </a>
        `;
    } else if (track.has_mini_task) {
        experienceButton = `
            <a
                href="/register"
                class="secondary-button"
            >
                Take Quiz Before Experience
            </a>
        `;
    } else {
        experienceButton = `
            <span class="coming-soon-button">
                Experience Coming Soon
            </span>
        `;
    }

    card.innerHTML = `
        <div class="explore-card-header">
            <span class="track-number">
                ${String(track.track_id).padStart(2, "0")}
            </span>

            <span class="availability-badge">
                ${
                    track.has_mini_task
                        ? "Career Experience Available"
                        : "Roadmap Available"
                }
            </span>
        </div>

        <h3>${track.track_name}</h3>

        <p class="explore-track-description">
            ${track.short_description}
        </p>

        <div class="track-levels-grid">
            ${createLevelItem(
                "Coding",
                track.coding_level
            )}

            ${createLevelItem(
                "Math",
                track.math_level
            )}

            ${createLevelItem(
                "Creativity",
                track.creativity_level
            )}

            ${createLevelItem(
                "Data",
                track.data_level
            )}
        </div>

        <div class="explore-track-actions">
            <a
                href="${detailsUrl}"
                class="primary-button"
            >
                View Career Roadmap
            </a>

            ${experienceButton}
        </div>
    `;

    tracksGrid.appendChild(card);
}

async function loadTracks() {
    try {
        const response = await fetch(
            "/api/tracks"
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load the technology tracks."
            );
        }

        if (
            !Array.isArray(result.tracks) ||
            result.tracks.length === 0
        ) {
            throw new Error(
                "No technology tracks are available."
            );
        }

        tracksGrid.innerHTML = "";

        result.tracks.forEach((track) => {
            createTrackCard(track);
        });

        loadingSection.classList.add("hidden");
        errorSection.classList.add("hidden");
        contentSection.classList.remove("hidden");

    } catch (error) {
        console.error(
            "Tracks loading error:",
            error
        );

        showError(error.message);
    }
}

loadTracks();