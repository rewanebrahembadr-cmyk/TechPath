const loadingSection = document.getElementById(
    "loading-section"
);

const resultSection = document.getElementById(
    "result-section"
);

const errorSection = document.getElementById(
    "error-section"
);

const errorMessage = document.getElementById(
    "result-error-message"
);

const studentName = document.getElementById(
    "student-name"
);

const bestTrackName = document.getElementById(
    "best-track-name"
);

const bestTrackPercentage = document.getElementById(
    "best-track-percentage"
);

const bestTrackDescription = document.getElementById(
    "best-track-description"
);

const bestTrackDetails = document.getElementById(
    "best-track-details"
);

const bestTrackTask = document.getElementById(
    "best-track-task"
);

const secondTrackName = document.getElementById(
    "second-track-name"
);

const secondTrackPercentage = document.getElementById(
    "second-track-percentage"
);

const secondTrackDescription = document.getElementById(
    "second-track-description"
);

const secondTrackDetails = document.getElementById(
    "second-track-details"
);

const recommendationReason = document.getElementById(
    "recommendation-reason"
);

const allTrackResults = document.getElementById(
    "all-track-results"
);

const strengthProfileContainer = document.getElementById(
    "strength-profile"
);

const queryParameters = new URLSearchParams(
    window.location.search
);

const attemptId = queryParameters.get("attempt_id");

function showError(message) {
    loadingSection.classList.add("hidden");
    resultSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function formatPercentage(value) {
    const number = Number(value);

    if (!Number.isFinite(number)) {
        return "0%";
    }

    return `${number.toFixed(2)}%`;
}

function createTrackDetailsUrl(trackId, studentId) {
    const parameters = new URLSearchParams({
        track_id: trackId
    });

    if (studentId) {
        parameters.set(
            "student_id",
            studentId
        );
    }

    if (attemptId) {
        parameters.set(
            "attempt_id",
            attemptId
        );
    }

    return `/track-details?${parameters.toString()}`;
}

function createMiniTaskUrl(trackId, studentId) {
    const parameters = new URLSearchParams({
        track_id: trackId
    });

    if (studentId) {
        parameters.set(
            "student_id",
            studentId
        );
    }

    if (attemptId) {
        parameters.set(
            "attempt_id",
            attemptId
        );
    }

    return `/mini-task?${parameters.toString()}`;
}

function configureBestTrackButtons(
    track,
    studentId
) {
    bestTrackDetails.href =
        createTrackDetailsUrl(
            track.track_id,
            studentId
        );

    if (track.has_mini_task && studentId) {
        bestTrackTask.href =
            createMiniTaskUrl(
                track.track_id,
                studentId
            );

        bestTrackTask.textContent =
            "Experience This Career";

        bestTrackTask.classList.remove(
            "disabled-button"
        );

        return;
    }

    if (!studentId) {
        bestTrackTask.href = "/register";

        bestTrackTask.textContent =
            "Take Quiz Before Experience";

        bestTrackTask.classList.remove(
            "disabled-button"
        );

        return;
    }

    bestTrackTask.textContent =
        "Career Experience Coming Soon";

    bestTrackTask.classList.add(
        "disabled-button"
    );

    bestTrackTask.removeAttribute("href");
}

function createRecommendationReason(
    bestTrack,
    secondTrack,
    strengthProfile
) {
    const strongestDimension =
        Array.isArray(strengthProfile) &&
        strengthProfile.length > 0
            ? strengthProfile[0]
            : null;

    let reason =
        `${bestTrack.track_name} was recommended because it received ` +
        `your highest compatibility score of ` +
        `${formatPercentage(bestTrack.match_percentage)}.`;

    if (strongestDimension) {
        reason +=
            ` Your strongest measured area was ` +
            `${strongestDimension.dimension_name} at ` +
            `${formatPercentage(strongestDimension.percentage)}, ` +
            `which supports this recommendation.`;
    }

    if (secondTrack) {
        reason +=
            ` ${secondTrack.track_name} was your second match at ` +
            `${formatPercentage(secondTrack.match_percentage)}, ` +
            `so it may also be worth exploring.`;
    }

    recommendationReason.textContent = reason;
}

function createStrengthProfile(items) {
    strengthProfileContainer.innerHTML = "";

    if (!Array.isArray(items) || items.length === 0) {
        strengthProfileContainer.innerHTML = `
            <p>
                No strength analysis is available yet.
            </p>
        `;

        return;
    }

    items.forEach((dimension) => {
        const percentage = Math.min(
            Math.max(
                Number(dimension.percentage) || 0,
                0
            ),
            100
        );

        const item = document.createElement("article");

        item.className = "strength-profile-item";

        const heading = document.createElement("div");

        heading.className = "strength-profile-heading";

        const title = document.createElement("strong");

        title.textContent =
            dimension.dimension_name;

        const value = document.createElement("span");

        value.textContent =
            formatPercentage(percentage);

        heading.appendChild(title);
        heading.appendChild(value);

        const progressTrack = document.createElement("div");

        progressTrack.className =
            "strength-progress-track";

        const progressValue = document.createElement("div");

        progressValue.className =
            "strength-progress-value";

        progressValue.style.width =
            `${percentage}%`;

        progressTrack.appendChild(
            progressValue
        );

        const description =
            document.createElement("p");

        description.className =
            "strength-description";

        description.textContent =
            dimension.dimension_description ||
            "This score reflects your quiz responses.";

        item.appendChild(heading);
        item.appendChild(progressTrack);
        item.appendChild(description);

        strengthProfileContainer.appendChild(
            item
        );
    });
}

function createAllTrackResults(
    tracks,
    studentId
) {
    allTrackResults.innerHTML = "";

    if (!Array.isArray(tracks) || tracks.length === 0) {
        allTrackResults.innerHTML = `
            <p>
                No compatibility results are available.
            </p>
        `;

        return;
    }

    tracks.forEach((track, index) => {
        const item = document.createElement("article");

        item.className = "track-result-item";

        const rank = document.createElement("span");

        rank.className = "track-result-rank";
        rank.textContent = index + 1;

        const content = document.createElement("div");

        content.className = "track-result-content";

        const heading = document.createElement("div");

        heading.className = "track-result-heading";

        const name = document.createElement("strong");

        name.textContent = track.track_name;

        const percentage = document.createElement("span");

        percentage.textContent =
            formatPercentage(
                track.match_percentage
            );

        heading.appendChild(name);
        heading.appendChild(percentage);

        const description = document.createElement("p");

        description.textContent =
            track.short_description ||
            "No description is available.";

        const progressTrack = document.createElement("div");

        progressTrack.className =
            "track-result-progress";

        const progressValue = document.createElement("div");

        progressValue.className =
            "track-result-progress-value";

        progressValue.style.width =
            `${Math.min(
                Math.max(
                    Number(
                        track.match_percentage
                    ) || 0,
                    0
                ),
                100
            )}%`;

        progressTrack.appendChild(
            progressValue
        );

        const detailsLink =
            document.createElement("a");

        detailsLink.className = "text-link";

        detailsLink.textContent =
            "View Career Roadmap";

        detailsLink.href =
            createTrackDetailsUrl(
                track.track_id,
                studentId
            );

        content.appendChild(heading);
        content.appendChild(description);
        content.appendChild(progressTrack);
        content.appendChild(detailsLink);

        item.appendChild(rank);
        item.appendChild(content);

        allTrackResults.appendChild(item);
    });
}

async function loadRecommendation() {
    if (!attemptId) {
        showError(
            "Quiz attempt ID is missing. Please complete the quiz again."
        );

        return;
    }

    try {
        const response = await fetch(
            `/api/recommendation/${attemptId}`
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load your recommendation."
            );
        }

        if (
            !result.student ||
            !Array.isArray(result.tracks) ||
            result.tracks.length === 0
        ) {
            throw new Error(
                "Recommendation data is incomplete."
            );
        }

        const bestTrack = result.tracks[0];
        const secondTrack = result.tracks[1];
        const studentId =
            result.student.student_id;

        studentName.textContent =
            result.student.full_name ||
            "Student";

        bestTrackName.textContent =
            bestTrack.track_name;

        bestTrackPercentage.textContent =
            formatPercentage(
                bestTrack.match_percentage
            );

        bestTrackDescription.textContent =
            bestTrack.short_description ||
            "No description is available.";

        configureBestTrackButtons(
            bestTrack,
            studentId
        );

        if (secondTrack) {
            secondTrackName.textContent =
                secondTrack.track_name;

            secondTrackPercentage.textContent =
                formatPercentage(
                    secondTrack.match_percentage
                );

            secondTrackDescription.textContent =
                secondTrack.short_description ||
                "No description is available.";

            secondTrackDetails.href =
                createTrackDetailsUrl(
                    secondTrack.track_id,
                    studentId
                );
        }

        createStrengthProfile(
            result.strength_profile
        );

        createRecommendationReason(
            bestTrack,
            secondTrack,
            result.strength_profile
        );

        createAllTrackResults(
            result.tracks,
            studentId
        );

        loadingSection.classList.add("hidden");
        errorSection.classList.add("hidden");
        resultSection.classList.remove("hidden");

    } catch (error) {
        console.error(
            "Recommendation page error:",
            error
        );

        showError(error.message);
    }
}

loadRecommendation();
