// 等待DOM完全加载
document.addEventListener('DOMContentLoaded', function() {
    // 平滑滚动
    const smoothScroll = (target, duration) => {
        const targetElement = document.querySelector(target);
        const targetPosition = targetElement.getBoundingClientRect().top;
        const startPosition = window.pageYOffset;
        const distance = targetPosition;
        let startTime = null;

        function animation(currentTime) {
            if (startTime === null) startTime = currentTime;
            const timeElapsed = currentTime - startTime;
            const run = ease(timeElapsed, startPosition, distance, duration);
            window.scrollTo(0, run);
            if (timeElapsed < duration) requestAnimationFrame(animation);
        }

        function ease(t, b, c, d) {
            t /= d / 2;
            if (t < 1) return c / 2 * t * t + b;
            t--;
            return -c / 2 * (t * (t - 2) - 1) + b;
        }

        requestAnimationFrame(animation);
    };

    // 为所有导航链接添加平滑滚动
    const navLinks = document.querySelectorAll('a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = this.getAttribute('href');
            if (target !== '#') {
                smoothScroll(target, 800);
            }
        });
    });

    // 简单的截图轮播
    const screenshots = document.querySelectorAll('.screenshot');
    if (screenshots.length > 0) {
        let currentIndex = 0;

        // 设置自动滚动
        setInterval(() => {
            currentIndex = (currentIndex + 1) % screenshots.length;
            const carousel = document.querySelector('.screenshot-carousel');
            const scrollPosition = screenshots[currentIndex].offsetLeft - (carousel.offsetWidth - screenshots[currentIndex].offsetWidth) / 2;
            carousel.scrollTo({
                left: scrollPosition,
                behavior: 'smooth'
            });
        }, 3000);
    }

    // 移动设备菜单切换（如有需要）
    const createMobileMenu = () => {
        // 创建汉堡菜单元素
        const hamburger = document.createElement('div');
        hamburger.className = 'hamburger';
        for (let i = 0; i < 3; i++) {
            const bar = document.createElement('span');
            hamburger.appendChild(bar);
        }

        // 将汉堡菜单添加到导航
        const nav = document.querySelector('nav');
        nav.appendChild(hamburger);

        // 点击事件处理
        hamburger.addEventListener('click', () => {
            const navLinks = document.querySelector('.nav-links');
            navLinks.classList.toggle('active');
            hamburger.classList.toggle('active');
        });
    };

    // 如果窗口宽度小于768px，添加移动菜单
    if (window.innerWidth < 768) {
        createMobileMenu();
    }

    // 窗口大小改变时处理
    window.addEventListener('resize', () => {
        if (window.innerWidth < 768) {
            if (!document.querySelector('.hamburger')) {
                createMobileMenu();
            }
        } else {
            const hamburger = document.querySelector('.hamburger');
            if (hamburger) {
                hamburger.remove();
                document.querySelector('.nav-links').classList.remove('active');
            }
        }
    });

    // 添加移动菜单的CSS
    if (window.innerWidth < 768) {
        const style = document.createElement('style');
        style.innerHTML = `
            .hamburger {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                width: 30px;
                height: 21px;
                cursor: pointer;
                z-index: 10;
            }
            
            .hamburger span {
                display: block;
                height: 3px;
                width: 100%;
                background-color: var(--primary-color);
                border-radius: 3px;
                transition: all 0.3s ease;
            }
            
            .hamburger.active span:nth-child(1) {
                transform: translateY(9px) rotate(45deg);
            }
            
            .hamburger.active span:nth-child(2) {
                opacity: 0;
            }
            
            .hamburger.active span:nth-child(3) {
                transform: translateY(-9px) rotate(-45deg);
            }
            
            .nav-links.active {
                display: flex;
                flex-direction: column;
                position: absolute;
                top: 80px;
                left: 0;
                width: 100%;
                background-color: var(--light-color);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                padding: 20px;
                z-index: 9;
            }
            
            .nav-links.active li {
                margin: 10px 0;
            }
        `;
        document.head.appendChild(style);
    }

    // 滚动动画
    const fadeInElements = () => {
        const elements = document.querySelectorAll('.feature-card, .testimonial-card, .screenshot');
        elements.forEach(element => {
            const position = element.getBoundingClientRect();
            
            // 如果元素在视口中
            if (position.top < window.innerHeight && position.bottom >= 0) {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }
        });
    };

    // 添加滚动动画CSS
    const animationStyle = document.createElement('style');
    animationStyle.innerHTML = `
        .feature-card, .testimonial-card, .screenshot {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }
    `;
    document.head.appendChild(animationStyle);

    // 页面加载和滚动时触发动画
    window.addEventListener('load', fadeInElements);
    window.addEventListener('scroll', fadeInElements);
}); 