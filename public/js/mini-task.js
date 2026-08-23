const loadingSection = document.getElementById("task-loading");
const contentSection = document.getElementById("task-content");
const errorSection = document.getElementById("task-error");
const errorMessage = document.getElementById("task-error-message");

const trackName = document.getElementById("task-track-name");
const taskTitle = document.getElementById("task-title");

const taskDescription = document.getElementById(
    "task-description"
);

const taskForm = document.getElementById("task-form");
const taskOptions = document.getElementById("task-options");
const taskMessage = document.getElementById("task-message");

const checkAnswerButton = document.getElementById(
    "check-answer-button"
);

const answerResult = document.getElementById("answer-result");
const answerStatus = document.getElementById("answer-status");
const answerTitle = document.getElementById("answer-title");

const answerExplanation = document.getElementById(
    "answer-explanation"
);

const feedbackForm = document.getElementById("feedback-form");

const enjoymentRating = document.getElementById(
    "enjoyment-rating"
);

const feedbackMessage = document.getElementById(
    "feedback-message"
);

const saveExperienceButton = document.getElementById(
    "save-experience-button"
);

const returnRoadmapButton = document.getElementById(
    "return-roadmap-button"
);

const queryParameters = new URLSearchParams(
    window.location.search
);

const trackId = queryParameters.get("track_id");
const studentId = queryParameters.get("student_id");
const attemptId = queryParameters.get("attempt_id");

let currentTask = null;
let selectedOption = null;
let answerIsCorrect = false;

function showError(message) {
    loadingSection.classList.add("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function createTaskOptions(task) {
    taskOptions.innerHTML = "";

    const options = [
        {
            letter: "A",
            text: task.option_a
        },
        {
            letter: "B",
            text: task.option_b
        },
        {
            letter: "C",
            text: task.option_c
        },
        {
            letter: "D",
            text: task.option_d
        }
    ];

    options.forEach((option) => {
        const label = document.createElement("label");

        label.className = "task-option";

        label.innerHTML = `
            <input
                type="radio"
                name="selected_option"
                value="${option.letter}"
            >

            <span class="option-letter">
                ${option.letter}
            </span>

            <span class="option-text">
                ${option.text}
            </span>
        `;

        taskOptions.appendChild(label);
    });
}

async function loadTask() {
    if (!trackId) {
        showError("Track ID is missing.");
        return;
    }

    if (!studentId) {
        showError(
            "Student ID is missing. Please complete the quiz again."
        );

        return;
    }

    try {
        const response = await fetch(
            `/api/mini-task/${trackId}`
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load the career experience."
            );
        }

        currentTask = result.task;

        trackName.textContent =
            currentTask.track_name;

        taskTitle.textContent =
            currentTask.task_title;

        taskDescription.textContent =
            currentTask.task_description;

        createTaskOptions(currentTask);

        returnRoadmapButton.href =
            `/track-details?track_id=${trackId}` +
            `&student_id=${studentId}` +
            `&attempt_id=${attemptId || ""}`;

        loadingSection.classList.add("hidden");
        errorSection.classList.add("hidden");
        contentSection.classList.remove("hidden");

    } catch (error) {
        console.error(
            "Task loading error:",
            error
        );

        showError(error.message);
    }
}

taskForm.addEventListener("submit", (event) => {
    event.preventDefault();

    const selectedInput = document.querySelector(
        'input[name="selected_option"]:checked'
    );

    if (!selectedInput) {
        taskMessage.textContent =
            "Please choose one workflow before continuing.";

        return;
    }

    selectedOption = selectedInput.value;

    answerIsCorrect =
        selectedOption === currentTask.correct_option;

    taskMessage.textContent = "";

    if (answerIsCorrect) {
        answerStatus.textContent =
            "Correct Decision";

        answerStatus.className =
            "answer-status correct-answer";

        answerTitle.textContent =
            "Excellent workflow thinking!";
    } else {
        answerStatus.textContent =
            "Learning Opportunity";

        answerStatus.className =
            "answer-status incorrect-answer";

        answerTitle.textContent =
            `The stronger decision was option ` +
            `${currentTask.correct_option}.`;
    }

    answerExplanation.textContent =
        currentTask.explanation;

    checkAnswerButton.disabled = true;

    document
        .querySelectorAll(
            'input[name="selected_option"]'
        )
        .forEach((input) => {
            input.disabled = true;
        });

    answerResult.classList.remove("hidden");

    answerResult.scrollIntoView({
        behavior: "smooth"
    });
});

feedbackForm.addEventListener(
    "submit",
    async (event) => {
        event.preventDefault();

        const wantsToContinueInput =
            document.querySelector(
                'input[name="wants_to_continue"]:checked'
            );

        if (!enjoymentRating.value) {
            feedbackMessage.textContent =
                "Please rate how much you enjoyed the task.";

            return;
        }

        if (!wantsToContinueInput) {
            feedbackMessage.textContent =
                "Please tell us whether you want to continue.";

            return;
        }

        saveExperienceButton.disabled = true;
        saveExperienceButton.textContent = "Saving...";
        feedbackMessage.textContent = "";

        try {
            const response = await fetch(
                "/api/mini-task/submit",
                {
                    method: "POST",

                    headers: {
                        "Content-Type":
                            "application/json"
                    },

                    body: JSON.stringify({
                        student_id:
                            Number(studentId),

                        task_id:
                            currentTask.task_id,

                        selected_option:
                            selectedOption,

                        enjoyment_rating:
                            Number(
                                enjoymentRating.value
                            ),

                        wants_to_continue:
                            Number(
                                wantsToContinueInput.value
                            )
                    })
                }
            );

            const result =
                await response.json();

            if (!response.ok) {
                throw new Error(
                    result.message ||
                    "Could not save your experience."
                );
            }

            window.location.href =
                `/task-success?task_attempt_id=${result.task_attempt_id}` +
                `&attempt_id=${attemptId || ""}`;

        } catch (error) {
            feedbackMessage.textContent =
                error.message;

            saveExperienceButton.disabled = false;

            saveExperienceButton.textContent =
                "Save My Experience";
        }
    }
);

loadTask();