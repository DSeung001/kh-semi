document.addEventListener("DOMContentLoaded", () => {
    const commentForm = document.querySelector("#comment-form");
    const contentInput = document.querySelector("#comment-content");
    const commentIdInput = document.querySelector("#comment-edit-id");
    const parentCommentIdInput = document.querySelector("#comment-parent-id")
    const submitButton = document.querySelector("#comment-submit-button");
    const cancelButton = document.querySelector("#comment-edit-cancel");
    const editButtons = document.querySelectorAll(
        "[data-comment-edit-button]"
    );
    const replyButtons = document.querySelectorAll(
        "[data-comment-reply-button]"
    )

    if (
        !commentForm ||
        !contentInput ||
        !commentIdInput ||
        !parentCommentIdInput ||
        !submitButton ||
        !cancelButton
    ) {
        return;
    }

    function changeToCreateMode() {
        commentForm.action = commentForm.dataset.createAction;

        commentIdInput.value = "";
        commentIdInput.disabled = true;

        parentCommentIdInput.value = "";
        parentCommentIdInput.disabled = true;

        contentInput.value = "";
        contentInput.placeholder = "댓글 입력";

        submitButton.textContent = "게시";
        cancelButton.hidden = true;

        commentForm.classList.remove("is-editing");
        commentForm.classList.remove("is-replying");
    }
    replyButtons.forEach((replyButton) => {
        replyButton.addEventListener("click", () => {
            commentForm.action =
                commentForm.dataset.createAction;

            commentIdInput.value = "";
            commentIdInput.disabled = true;

            parentCommentIdInput.value =
                replyButton.dataset.commentId;

            parentCommentIdInput.disabled = false;

            const nickname =
                replyButton.dataset.commentNickname;

            contentInput.value = "";
            contentInput.placeholder =
                nickname + "님에게 답글 입력";

            submitButton.textContent = "답글 게시";
            cancelButton.hidden = false;

            commentForm.classList.remove("is-editing");
            commentForm.classList.add("is-replying");

            contentInput.focus();
        });
    });

    editButtons.forEach((editButton) => {
        editButton.addEventListener("click", () => {
            const commentRow =
                editButton.closest(".zt-comment-row");

            const commentContent =
                commentRow.querySelector("[data-comment-content]");

            commentForm.action =
                commentForm.dataset.updateAction;

            parentCommentIdInput.value = "";
            parentCommentIdInput.disabled = true;

            commentIdInput.value =
                editButton.dataset.commentId;

            commentIdInput.disabled = false;

            contentInput.value =
                commentContent.textContent.trim();

            contentInput.placeholder = "댓글 수정";

            submitButton.textContent = "수정 완료";
            cancelButton.hidden = false;

            commentForm.classList.add("is-editing");
            commentForm.classList.remove("is-replying");


            contentInput.focus();

        });
    });

    cancelButton.addEventListener("click", () => {
        changeToCreateMode();
        contentInput.focus();
    });
});