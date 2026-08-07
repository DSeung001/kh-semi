document.addEventListener("DOMContentLoaded", () => {
    const likeForms = document.querySelectorAll(
        'form[action$="/post-like"]'
    );

    likeForms.forEach((likeForm) => {
        const postContainer =
            likeForm.closest(".zt-post") ?? document;

        const likeButton = likeForm.querySelector("button");
        const likeIcon = likeForm.querySelector(
            "[data-like-icon]"
        );
        const likeCount = postContainer.querySelector(
            "[data-like-count]"
        );

        if (!likeButton || !likeIcon || !likeCount) {
            return;
        }

        likeForm.addEventListener("submit", async (event) => {
            event.preventDefault();

            likeButton.disabled = true;

            try {
                const response = await fetch(
                    likeForm.action,
                    {
                        method: "POST",
                        headers: {
                            "Accept": "application/json",
                            "X-Requested-With": "XMLHttpRequest"
                        },
                        body: new FormData(likeForm)
                    }
                );

                const responseBody = await response.json();

                if (!response.ok || !responseBody.success) {
                    throw new Error(
                        responseBody.message
                        ?? "좋아요 처리에 실패했습니다."
                    );
                }

                const result = responseBody.data;

                if (result.liked) {
                    likeIcon.className =
                        "bi bi-heart-fill text-danger";
                } else {
                    likeIcon.className = "bi bi-heart";
                }

                likeCount.textContent = result.likeCount;
            } catch (error) {
                console.error(error);
                alert(error.message);
            } finally {
                likeButton.disabled = false;
            }
        });
    });
});