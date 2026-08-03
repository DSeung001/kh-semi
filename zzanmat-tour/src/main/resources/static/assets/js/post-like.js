document.addEventListener("DOMContentLoaded", () => {
    const  likeForm = document.querySelector(
        'form[action$="/post-like"]'
    );

    if (!likeForm){
        return;
    }

    const likeButton = likeForm.querySelector("button");
    const likeIcon = likeButton.querySelector("i");
    const likeCount = document.querySelector("#detail-likes");

    likeForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        likeButton.disabled = true;

        try {
            const response = await fetch(
                likeForm.action,
                {
                    method: "POST",
                    body: new FormData(likeForm)
                }
            );

            if (!response.ok) {
                throw new Error("좋아요 처리에 실패했습니다.");
            }

            const  result = await  response.json();

            if (result.liked) {
                likeIcon.className =
                    "bi bi-heart-fill text-danger";
            } else {
                likeIcon.className = "bi bi-heart";
            }

            likeCount.textContent =
                "좋아요 " + result.likeCount + "개";
        } catch (error) {
            console.error(error);
            alert("좋아요 처리 중 오류가 발생했습니다.");
        } finally {
            likeButton.disabled = false;
        }
    });
});