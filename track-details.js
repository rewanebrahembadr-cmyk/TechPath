const loadingSection = document.getElementById("track-loading");
const contentSection = document.getElementById("track-content");
const errorSection = document.getElementById("track-error");
const errorMessage = document.getElementById("track-error-message");

const trackName = document.getElementById("track-name");

const shortDescription = document.getElementById(
    "track-short-description"
);

const fullDescription = document.getElementById(
    "track-full-description"
);

const codingLevel = document.getElementById("coding-level");
const mathLevel = document.getElementById("math-level");

const creativityLevel = document.getElementById(
    "creativity-level"
);

const dataLevel = document.getElementById("data-level");

const skillsContainer = document.getElementById(
    "track-skills"
);

const toolsContainer = document.getElementById(
    "track-tools"
);

const jobRolesContainer = document.getElementById(
    "track-job-roles"
);

const roadmapContainer = document.getElementById(
    "track-roadmap"
);

const experienceButton = document.getElementById(
    "experience-career-button"
);

const bottomExperienceButton = document.getElementById(
    "bottom-experience-button"
);

const queryParameters = new URLSearchParams(
    window.location.search
);

const trackId = queryParameters.get("track_id");
const studentId = queryParameters.get("student_id");
const attemptId = queryParameters.get("attempt_id");

function showError(message) {
    loadingSection.classList.add("hidden");
    contentSection.classList.add("hidden");
    errorSection.classList.remove("hidden");

    errorMessage.textContent = message;
}

function createTags(container, items) {
    container.innerHTML = "";

    if (!Array.isArray(items) || items.length === 0) {
        container.innerHTML = `
            <p>No information is available yet.</p>
        `;

        return;
    }

    items.forEach((item) => {
        const tag = document.createElement("span");

        tag.className = "track-tag";
        tag.textContent = item;

        container.appendChild(tag);
    });
}

function createJobRoles(items) {
    jobRolesContainer.innerHTML = "";

    if (!Array.isArray(items) || items.length === 0) {
        jobRolesContainer.innerHTML = `
            <p>No job roles are available yet.</p>
        `;

        return;
    }

    items.forEach((item) => {
        const role = document.createElement("article");

        role.className = "job-role-item";

        const icon = document.createElement("span");
        icon.textContent = "💼";

        const text = document.createElement("p");
        text.textContent = item;

        role.appendChild(icon);
        role.appendChild(text);

        jobRolesContainer.appendChild(role);
    });
}

function createRoadmapSteps(steps) {
    roadmapContainer.innerHTML = "";

    if (!Array.isArray(steps) || steps.length === 0) {
        roadmapContainer.innerHTML = `
            <p class="empty-roadmap">
                The roadmap for this track is being prepared.
            </p>
        `;

        return;
    }

    steps.forEach((step) => {
        const roadmapItem = document.createElement("article");

        roadmapItem.className = "roadmap-item";

        const roadmapNumber = document.createElement("span");
        roadmapNumber.className = "roadmap-number";
        roadmapNumber.textContent = step.step_number;

        const roadmapContent = document.createElement("div");

        const roadmapTitle = document.createElement("strong");
        roadmapTitle.textContent = step.step_title;

        const roadmapDescription = document.createElement("p");
        roadmapDescription.textContent =
            step.step_description;

        roadmapContent.appendChild(roadmapTitle);
        roadmapContent.appendChild(roadmapDescription);

        roadmapItem.appendChild(roadmapNumber);
        roadmapItem.appendChild(roadmapContent);

        roadmapContainer.appendChild(roadmapItem);
    });
}

function createMiniTaskUrl(track) {
    const parameters = new URLSearchParams({
        track_id: track.track_id
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

function configureExperienceButtons(track) {
    const buttons = [
        experienceButton,
        bottomExperienceButton
    ];

    if (!track.has_mini_task) {
        buttons.forEach((button) => {
            button.textContent =
                "Career Experience Coming Soon";

            button.classList.add(
                "disabled-button"
            );

            button.removeAttribute("href");
        });

        return;
    }

    if (!studentId) {
        buttons.forEach((button) => {
            button.textContent =
                "Take Quiz Before Experience";

            button.href = "/register";

            button.classList.remove(
                "disabled-button"
            );
        });

        return;
    }

    const miniTaskUrl = createMiniTaskUrl(track);

    buttons.forEach((button) => {
        button.textContent =
            "Experience This Career";

        button.href = miniTaskUrl;

        button.classList.remove(
            "disabled-button"
        );
    });
}

async function loadTrackDetails() {
    if (!trackId) {
        showError("Track ID is missing.");
        return;
    }

    try {
        const response = await fetch(
            `/api/tracks/${trackId}`
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                result.message ||
                "Could not load track details."
            );
        }

        if (!result.track) {
            throw new Error(
                "Track data is missing."
            );
        }

        const track = result.track;

        trackName.textContent =
            track.track_name ||
            "Track Name";

        shortDescription.textContent =
            track.short_description ||
            "No short description is available.";

        fullDescription.textContent =
            track.full_description ||
            "No full description is available.";

        codingLevel.textContent =
            track.coding_level || "-";

        mathLevel.textContent =
            track.math_level || "-";

        creativityLevel.textContent =
            track.creativity_level || "-";

        dataLevel.textContent =
            track.data_level || "-";

        createTags(
            skillsContainer,
            track.skills
        );

        createTags(
            toolsContainer,
            track.tools
        );

        createJobRoles(
            track.job_roles
        );

        createRoadmapSteps(
            track.roadmap_steps
        );

        configureExperienceButtons(track);

        loadingSection.classList.add("hidden");
        errorSection.classList.add("hidden");
        contentSection.classList.remove("hidden");

    } catch (error) {
        console.error(
            "Track page error:",
            error
        );

        showError(error.message);
    }
}

loadTrackDetails();