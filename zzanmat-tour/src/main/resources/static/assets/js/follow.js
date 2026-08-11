const followButtons = document.querySelectorAll(
    "[data-follow-button]"
);

followButtons.forEach((followButton) => {
    followButton.addEventListener("click", async () => {
        const contextPath =
            followButton.dataset.contextPath;

        const followingId =
            followButton.dataset.followingId;

        const isLoggedIn =
            followButton.dataset.loggedIn === "true";

        const moveToLogin = () => {
            const wantsToLogin = confirm(
                "팔로우하려면 로그인이 필요합니다. 로그인하시겠습니까?"
            );

            if (!wantsToLogin) {
                return;
            }

            const currentURL =
                window.location.pathname
                + window.location.search;

            window.location.href =
                contextPath
                + "/member/login?redirectURL="
                + encodeURIComponent(currentURL);
        };

        if (!isLoggedIn) {
            moveToLogin();
            return;
        }

        const isFollowing =
            followButton.dataset.following === "true";

        followButton.disabled = true;

        try {
            const response = await fetch(
                contextPath
                + "/api/member/follow/"
                + followingId,
                {
                    method: isFollowing
                        ? "DELETE"
                        : "POST",
                    headers: {
                        "Accept": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    }
                }
            );

            if (response.status === 401) {
                moveToLogin();
                return;
            }

            const result = await response.json();

            if (!response.ok || !result.success) {
                alert(
                    result.message
                    || "팔로우 처리에 실패했습니다."
                );
                return;
            }

            const newFollowingState =
                Boolean(result.data);

            followButton.dataset.following =
                String(newFollowingState);

            followButton.textContent =
                newFollowingState
                    ? "팔로잉"
                    : "팔로우";

            followButton.classList.toggle(
                "is-following",
                newFollowingState
            );
        } catch (error) {
            console.error(error);

            alert(
                "팔로우 처리 중 오류가 발생했습니다."
            );
        } finally {
            followButton.disabled = false;
        }
    });
});
