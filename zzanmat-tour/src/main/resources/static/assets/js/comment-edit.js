document.addEventListener("DOMContentLoaded", () => {
    const commentForm = document.querySelector("#comment-form");
    const contentInput = document.querySelector("#comment-content");
    const commentIdInput = document.querySelector("#comment-edit-id");
    const parentCommentIdInput = document.querySelector("#comment-parent-id")
    const submitButton = document.querySelector("#comment-submit-button");
    const cancelButton = document.querySelector("#comment-edit-cancel");
    const commentList =
        document.querySelector("[data-comment-list]");

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

    if (commentList) {
        commentList.addEventListener("click", (event) => {
            const replyButton = event.target.closest(
                "[data-comment-reply-button]"
            );

            if (replyButton) {
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
                return;
            }

            const editButton = event.target.closest(
                "[data-comment-edit-button]"
            );

            if (editButton) {
                const commentRow =
                    editButton.closest(".zt-comment-row");

                const commentContent =
                    commentRow.querySelector(
                        "[data-comment-content]"
                    );

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
            }
        });
    }
    cancelButton.addEventListener("click", () => {
        changeToCreateMode();
        contentInput.focus();
    });

    if (commentList) {
        commentList.addEventListener("submit", async (event) => {
            const deleteForm = event.target.closest(
                'form[action$="/comments/delete"]'
            );

            if (!deleteForm) {
                return;
            }

            event.preventDefault();

            const confirmed = window.confirm(
                "댓글을 삭제하시겠습니까?"
            );

            if (!confirmed) {
                return;
            }

            const commentRow =
                deleteForm.closest(".zt-comment-row");

            const deleteButton =
                deleteForm.querySelector("button[type='submit']");

            deleteButton.disabled = true;

            try {
                const response = await fetch(deleteForm.action, {
                    method: "POST",
                    body: new FormData(deleteForm)
                });

                if (!response.ok) {
                    throw new Error("댓글을 삭제하지 못했습니다.");
                }

                const result = await response.json();

                if (!result.success) {
                    throw new Error(
                        result.message || "댓글을 삭제하지 못했습니다."
                    );
                }

                const content =
                    commentRow.querySelector("[data-comment-content]");

                if (content) {
                    content.textContent = "삭제된 댓글입니다.";
                    content.classList.add("zt-deleted-comment");
                }

                commentRow
                    .querySelector(".zt-comment-like-count")
                    ?.remove();

                commentRow
                    .querySelector("[data-comment-reply-button]")
                    ?.remove();

                commentRow
                    .querySelector(".zt-comment-actions")
                    ?.remove();

                commentRow
                    .querySelector("[data-comment-like-button]")
                    ?.remove();

                changeToCreateMode();
            } catch (error) {
                alert(error.message);
                deleteButton.disabled = false;
            }
        });
    }

    commentForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const isEditing = !commentIdInput.disabled;
        const editingCommentId = commentIdInput.value;

        const requestUrl = isEditing
            ? commentForm.dataset.updateAction
            : commentForm.dataset.createAction;

        const formData = new FormData(commentForm);

        submitButton.disabled = true;

        try {
            const response = await fetch(requestUrl, {
                method: "POST",
                body: formData
            });

            if (!response.ok) {
                throw new Error("댓글을 저장하지 못했습니다");
            }

            const result = await response.json();

            if (!result.success) {
                throw new Error(
                    result.message || "댓글을 저장하지 못했습니다."
                );
            }

            if (isEditing) {
                updateCommentOnScreen(
                    editingCommentId,
                    result.data.content
                );
            } else {
                appendComment(result.data);
            }

            changeToCreateMode();

            const commentList =
                document.querySelector("[data-comment-list]");

            const commentToggleButton =
                document.querySelector("[data-comment-toggle]");

            if (commentList) {
                commentList.hidden = false;
            }

            if (commentToggleButton) {
                commentToggleButton.setAttribute(
                    "aria-expanded",
                    "true"
                );

                commentToggleButton.classList.add("is-active");
            }
        } catch (error) {
            alert(error.message);
        } finally {
            submitButton.disabled = false;
        }
    });

    function updateCommentOnScreen(commentId, content) {
        const editButton = document.querySelector(
            `[data-comment-edit-button][data-comment-id="${commentId}"]`
        );

        if (!editButton) {
            return;
        }

        const commentRow =
            editButton.closest(".zt-comment-row");

        const commentContent =
            commentRow.querySelector("[data-comment-content]");

        if (commentContent) {
            commentContent.textContent = " " + content;
        }
    }

    function appendComment(comment) {
        const commentList =
                document.querySelector("[data-comment-list]");

            if (!commentList) {
                return;
            }

            if (
                commentList.children.length === 1 &&
                commentList.firstElementChild.tagName === "P"
            ) {
                commentList.innerHTML = "";
            }

            const commentRow = document.createElement("div");

            commentRow.className = "zt-comment-row";
            commentRow.dataset.commentRow = "";
            commentRow.dataset.commentId = comment.commentId;

            if (comment.parentCommentId) {
                commentRow.dataset.parentCommentId =
                    comment.parentCommentId;
            }

            if (comment.parentCommentId) {
                commentRow.classList.add("is-reply");
            }

            const profileImage = document.createElement("img");

            profileImage.className = "zt-avatar zt-avatar-sm";
            profileImage.src = commentForm.dataset.profileImage;
            profileImage.alt = "댓글 작성자 프로필";

            const commentBody = document.createElement("div");

            commentBody.className = "flex-grow-1";

            const commentText = document.createElement("p");

            commentText.className = "small mb-1";

            const nickname = document.createElement("strong");

            nickname.textContent =
                comment.nickname || "사용자";

            const content = document.createElement("span");

            content.setAttribute("data-comment-content", "");
            content.textContent = " " + comment.content;

            const likeCount = document.createElement("div");

            likeCount.className = "zt-comment-like-count";

            const likeCountNumber = document.createElement("span");

            likeCountNumber.setAttribute("data-comment-like-count", "");
            likeCountNumber.textContent = String(comment.likeCount ?? 0);

            likeCount.append("좋아요 ");
            likeCount.append(likeCountNumber);
            likeCount.append("개");

            const commentActions = document.createElement("div");

            commentActions.className = "zt-comment-actions";

            const editButton = document.createElement("button");

            editButton.className = "zt-comment-action-button";
            editButton.type = "button";
            editButton.dataset.commentEditButton = "";
            editButton.dataset.commentId = comment.commentId;
            editButton.textContent = "수정";

        const deleteForm = document.createElement("form");

        deleteForm.action = commentForm.dataset.deleteAction;
        deleteForm.method = "post";

        const deleteCommentIdInput = document.createElement("input");

        deleteCommentIdInput.type = "hidden";
        deleteCommentIdInput.name = "commentId";
        deleteCommentIdInput.value = comment.commentId;

        const deletePostIdInput = document.createElement("input");

        deletePostIdInput.type = "hidden";
        deletePostIdInput.name = "postId";
        deletePostIdInput.value =
            commentForm.querySelector('input[name="postId"]').value;

        const deleteButton = document.createElement("button");

        deleteButton.className =
            "zt-comment-action-button zt-comment-delete-button";
        deleteButton.type = "submit";
        deleteButton.textContent = "삭제";

        deleteForm.append(deleteCommentIdInput);
        deleteForm.append(deletePostIdInput);
        deleteForm.append(deleteButton);

        if (!comment.parentCommentId) {
            const replyButton = document.createElement("button");

            replyButton.className = "zt-comment-action-button";
            replyButton.type = "button";
            replyButton.dataset.commentReplyButton = "";
            replyButton.dataset.commentId = comment.commentId;
            replyButton.dataset.commentNickname =
                comment.nickname || "사용자";
            replyButton.textContent = "답글 달기";

            commentActions.append(replyButton);
        }

            commentActions.append(editButton);
            commentActions.append(deleteForm);

        const likeButton = document.createElement("button");

        likeButton.className = "zt-comment-like-button";
        likeButton.type = "button";
        likeButton.dataset.commentLikeButton = "";
        likeButton.dataset.commentId = comment.commentId;
        likeButton.dataset.postId =
            commentForm.querySelector('input[name="postId"]').value;
        likeButton.dataset.loggedIn = "true";
        likeButton.dataset.likeAction =
            commentForm.dataset.likeAction;
        likeButton.dataset.loginUrl =
            commentForm.dataset.loginUrl;

        const likeIcon = document.createElement("i");

        likeIcon.className = "bi bi-heart";
        likeIcon.dataset.commentLikeIcon = "";

        likeButton.append(likeIcon);

            commentText.append(nickname);
            commentText.append(content);

            commentBody.append(commentText);
            commentBody.append(likeCount);
            commentBody.append(commentActions);

            commentRow.append(profileImage);
            commentRow.append(commentBody);
            commentRow.append(likeButton);

            if (comment.parentCommentId) {
                const parentCommentRow = commentList.querySelector(
                    `[data-comment-id="${comment.parentCommentId}"]`
                );

                if (parentCommentRow) {
                    let lastReplyRow = parentCommentRow;
                    let nextRow = parentCommentRow.nextElementSibling;

                    while (
                        nextRow &&
                        nextRow.dataset.parentCommentId ===
                            String(comment.parentCommentId)
                    ) {
                        lastReplyRow = nextRow;
                        nextRow = nextRow.nextElementSibling;
                    }

                    lastReplyRow.after(commentRow);
                } else {
                    commentList.append(commentRow);
                }
            } else {
                commentList.append(commentRow);
            }
        }
});
