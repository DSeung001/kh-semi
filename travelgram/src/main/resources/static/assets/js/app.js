document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-demo-form]').forEach(f => f.addEventListener('submit', e => {
        e.preventDefault();
        alert('서버 연동 후 사용할 수 있습니다.')
    }));
    document.querySelectorAll('[data-follow-button]').forEach(b => b.addEventListener('click', () => {
        b.textContent = b.textContent === '팔로우' ? '팔로잉' : '팔로우'
    }));
    document.querySelectorAll('[data-like-button]').forEach(b => b.addEventListener('click', () => {
        const i = b.querySelector('i'), c = document.querySelector(b.dataset.likeTarget),
            liked = i.classList.contains('bi-heart-fill');
        i.className = liked ? 'bi bi-heart' : 'bi bi-heart-fill';
        b.classList.toggle('text-danger', !liked);
        let n = Number(c.dataset.count) + (liked ? -1 : 1);
        c.dataset.count = n;
        c.textContent = `좋아요 ${n.toLocaleString()}개`
    }));
    document.querySelectorAll('[data-comment-form]').forEach(f => f.addEventListener('submit', e => {
        e.preventDefault();
        const i = f.querySelector('input');
        if (!i.value.trim()) return;
        const p = document.createElement('p');
        p.textContent = `나 ${i.value.trim()}`;
        f.closest('.tg-post').querySelector('[data-comment-list]').append(p);
        i.value = ''
    }))
});
