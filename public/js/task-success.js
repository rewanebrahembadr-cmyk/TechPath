const loadingSection = document.getElementById(
    "success-loading"
);

const contentSection = document.getElementById(
    "success-content"
);

const errorSection = document.getElementById(
    "success-error"
);

const errorMessage = document.getElementById(
    "success-error-message"
);

const studentName = document.getElementById(
    "success-student-name"
);

const trackName = document.getElementById(
    "success-track-name"
);

const answerResult = document.getElementById(
    "success-answer-result"
);

const enjoymentRating = document.getElementById(
    "success-enjoyment-rating"
);

const continueChoice = document.getElementById(
    "success-continue-choice"
);

const insightTitle = document.getElementById(
    "success-insight-title"
);

const insightText = document.getElementById(
    "success-insight-text"
);

const roadmapButton = document.getElementById(
    "success-roadmap-button"
);

const recommendationButton = document.getElementById(
    "success-recommendation-button"
);

const queryParameters = new URLSearchParams(
    window.location.search
);

const taskAttemptId = queryParameters.get(
    "task_attempt_id"
);

const attemptId = queryParameters.get(
    "attempt_id"
);

function showError(message) {
    loadingSection.classList.add("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function updateInsight(result) {
    const enjoyedTask =
        result.enjoyment_rating >= 4;

    const wantsToContinue =
        Boolean(result.wants_to_continue);

    if (
        result.is_correct &&
        enjoyedTask &&
        wantsToContinue
    ) {
        insightTitle.textContent =
            "This track deserves deeper exploration.";

        insightText.textContent =
            "You completed the practical decision correctly, enjoyed the task, and chose to continue. This is strong early evidence that the nature of this career may match your interests.";
    } else if (
        enjoyedTask &&
        wantsToContinue
    ) {
        insightTitle.textContent =
            "Interest matters more than one correct answer.";

        insightText.textContent =
            "You enjoyed the experience and want to continue exploring. Technical accuracy improves with learning, so your interest is a valuable reason to review the roadmap and try another task.";
    } else if (
        result.is_correct &&
        !wantsToContinue
    ) {
        insightTitle.textContent =
            "Ability and career preference are different.";

        insightText.textContent =
            "You made the correct decision, but you are not ready to continue with this track. That is useful information because choosing a career should consider both ability and enjoyment.";
    } else {
        insightTitle.textContent =
            "Use this experience as exploration evidence.";

        insightText.textContent =
            "A single task does not define your ability. Compare this experience with another track and notice which type of work feels more engaging and natural to you.";
    }
}

async function loadTaskSuccess() {
    if (!taskAttemptId) {
        showError(
            "Task attempt ID is missing."
        );

        return;
    }

    try {
        const response = await fetch(
            `/api/task-attempts/${taskAttemptId}`
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load the career experience."
            );
        }

        const attempt = result.attempt;

        studentName.textContent =
            attempt.full_name;

        trackName.textContent =
            attempt.track_name;

        answerResult.textContent =
            attempt.is_correct
                ? "Correct Decision"
                : "Learning Opportunity";

        enjoymentRating.textContent =
            attempt.enjoyment_rating;

        continueChoice.textContent =
            attempt.wants_to_continue
                ? "Yes"
                : "Not Yet";

        updateInsight(attempt);

        roadmapButton.href =
            `/track-details?track_id=${attempt.track_id}` +
            `&student_id=${attempt.student_id}`;

        if (attemptId) {
            recommendationButton.href =
                `/recommendation?attempt_id=${attemptId}`;
        } else {
            recommendationButton.href =
                "/register";
        }

        loadingSection.classList.add("hidden");
        errorSection.classList.add("hidden");
        contentSection.classList.remove("hidden");

    } catch (error) {
        console.error(
            "Task success loading error:",
            error
        );

        showError(error.message);
    }
}

loadTaskSuccess();
