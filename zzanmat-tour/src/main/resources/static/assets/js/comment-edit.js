document.addEventListener("DOMContentLoaded", () => {
    const commentForm = document.querySelector("#comment-form");
    const contentInput = document.querySelector("#comment-content");
    const commentIdInput = document.querySelector("#comment-edit-id");
    const submitButton = document.querySelector("#comment-submit-button");
    const cancelButton = document.querySelector("#comment-edit-cancel");
    const editButtons = document.querySelectorAll(
        "[data-comment-edit-button]"
    );

    if (
        !commentForm ||
        !contentInput ||
        !commentIdInput ||
        !submitButton ||
        !cancelButton
    ) {
        return;
    }

    function changeToCreateMode() {
        commentForm.action = commentForm.dataset.createAction;

        commentIdInput.value = "";
        commentIdInput.disabled = true;

        contentInput.value = "";
        contentInput.placeholder = "댓글 입력";

        submitButton.textContent = "게시";
        cancelButton.hidden = true;

        commentForm.classList.remove("is-editing");
    }

    editButtons.forEach((editButton) => {
        editButton.addEventListener("click", () => {
            const commentRow =
                editButton.closest(".zt-comment-row");

            const commentContent =
                commentRow.querySelector("[data-comment-content]");

            commentForm.action =
                commentForm.dataset.updateAction;

            commentIdInput.value =
                editButton.dataset.commentId;

            commentIdInput.disabled = false;

            contentInput.value =
                commentContent.textContent.trim();

            contentInput.placeholder = "댓글 수정";

            submitButton.textContent = "수정 완료";
            cancelButton.hidden = false;

            commentForm.classList.add("is-editing");

            contentInput.focus();

        });
    });

    cancelButton.addEventListener("click", () => {
        changeToCreateMode();
        contentInput.focus();
    });
});