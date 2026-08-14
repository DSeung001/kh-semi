document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", async (event) => {
        const likeButton = event.target.closest(
            "[data-comment-like-button]"
        );

        if (!likeButton) {
            return;
        }

        const loggedIn =
            likeButton.dataset.loggedIn === "true";

        if (!loggedIn) {
            alert("로그인이 필요한 기능입니다.");
            window.location.href = likeButton.dataset.loginUrl;
            return;
        }

        const likeIcon = likeButton.querySelector(
            "[data-comment-like-icon]"
        );

        const commentRow = likeButton.closest(
            ".zt-comment-row"
        );

        const likeCount = commentRow
            ? commentRow.querySelector("[data-comment-like-count]")
            : null;

        likeButton.disabled = true;

        try {
            const requestBody = new URLSearchParams({
                commentId: likeButton.dataset.commentId,
                postId: likeButton.dataset.postId
            });

            const response = await fetch(
                likeButton.dataset.likeAction,
                {
                    method: "POST",
                    headers: {
                        "Accept": "application/json",
                        "Content-Type":
                            "application/x-www-form-urlencoded;charset=UTF-8",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: requestBody.toString()
                }
            );

            const responseBody = await response.json();

            if (!response.ok || !responseBody.success) {
                throw new Error(
                    responseBody.message
                    ?? "댓글 좋아요 처리에 실패했습니다."
                );
            }

            const result = responseBody.data;

            likeButton.classList.toggle(
                "is-liked",
                result.liked
            );

            if (likeIcon) {
                likeIcon.className = result.liked
                    ? "bi bi-heart-fill"
                    : "bi bi-heart";
            }

            if (likeCount) {
                likeCount.textContent = result.likeCount;
            }
        } catch (error) {
            console.error(error);
            alert(error.message);
        } finally {
            likeButton.disabled = false;
        }
    });
});