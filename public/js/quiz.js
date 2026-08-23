const questionCards = document.querySelectorAll(".question-card");

const previousButton = document.getElementById("previous-button");
const nextButton = document.getElementById("next-button");
const submitButton = document.getElementById("submit-button");

const questionNumber = document.getElementById("question-number");
const progressPercentage = document.getElementById(
    "progress-percentage"
);
const progressBar = document.getElementById("progress-bar");
const quizMessage = document.getElementById("quiz-message");
const studentIdInput = document.getElementById("student-id");
const quizForm = document.getElementById("quiz-form");

let currentQuestionIndex = 0;

const queryParameters = new URLSearchParams(
    window.location.search
);

const studentId = queryParameters.get("student_id");

studentIdInput.value = studentId || "";

function showQuestion() {
    questionCards.forEach((card, index) => {
        card.classList.toggle(
            "active-question",
            index === currentQuestionIndex
        );
    });

    const currentQuestionNumber = currentQuestionIndex + 1;
    const totalQuestions = questionCards.length;

    const percentage = Math.round(
        (currentQuestionNumber / totalQuestions) * 100
    );

    questionNumber.textContent =
        `Question ${currentQuestionNumber} of ${totalQuestions}`;

    progressPercentage.textContent = `${percentage}%`;
    progressBar.style.width = `${percentage}%`;

    previousButton.disabled = currentQuestionIndex === 0;

    const isLastQuestion =
        currentQuestionIndex === totalQuestions - 1;

    nextButton.style.display = isLastQuestion
        ? "none"
        : "inline-block";

    submitButton.style.display = isLastQuestion
        ? "inline-block"
        : "none";

    quizMessage.textContent = "";
}

function currentQuestionIsAnswered() {
    const currentCard = questionCards[currentQuestionIndex];

    return Boolean(
        currentCard.querySelector(
            'input[type="radio"]:checked'
        )
    );
}

nextButton.addEventListener("click", () => {
    if (!currentQuestionIsAnswered()) {
        quizMessage.textContent =
            "Please choose an answer before continuing.";

        return;
    }

    currentQuestionIndex += 1;
    showQuestion();
});

previousButton.addEventListener("click", () => {
    if (currentQuestionIndex > 0) {
        currentQuestionIndex -= 1;
        showQuestion();
    }
});

quizForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    if (!currentQuestionIsAnswered()) {
        quizMessage.textContent =
            "Please choose an answer before viewing your result.";

        return;
    }

    if (!studentId) {
        quizMessage.textContent =
            "Student ID is missing. Please register again.";

        return;
    }

    const answers = {};

    for (let questionIndex = 1; questionIndex <= 16; questionIndex++) {
        const selectedAnswer = document.querySelector(
            `input[name="question_${questionIndex}"]:checked`
        );

        if (!selectedAnswer) {
            quizMessage.textContent =
                `Please answer question ${questionIndex}.`;

            return;
        }

        answers[questionIndex] = Number(selectedAnswer.value);
    }

    submitButton.disabled = true;
    submitButton.textContent = "Calculating...";
    quizMessage.textContent = "";

    try {
        const response = await fetch("/api/quiz/submit", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                student_id: Number(studentId),
                answers
            })
        });

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message || "Could not submit the quiz."
            );
        }

        sessionStorage.setItem(
            "techpathResult",
            JSON.stringify(result)
        );

       window.location.href =
    `/recommendation?attempt_id=${result.attempt_id}`;
    } catch (error) {
        quizMessage.textContent = error.message;

        submitButton.disabled = false;
        submitButton.textContent = "View My Result";
    }
});

showQuestion();
