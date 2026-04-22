# Cách "Nhẹ nhàng": Redirect về phía Front-end (Laravel)
add_action('template_redirect', function() {
    // Nếu không phải là yêu cầu API hoặc Admin, đuổi thẳng về trang chủ Laravel
    if (!is_admin() && !(defined('REST_REQUEST') && REST_REQUEST)) {
        wp_redirect('https://your-laravel-site.com');
        exit;
    }
});

add_action('template_redirect', function() {
    // 1. Kiểm tra nếu là REST API hoặc GraphQL (nếu bạn dùng WPGraphQL)
    if (defined('REST_REQUEST') && REST_REQUEST) return;
    if (strpos($_SERVER['REQUEST_URI'], 'wp-json') !== false) return;

    // 2. Kiểm tra nếu là trang Admin hoặc Login
    if (is_admin() || $GLOBALS['pagenow'] === 'wp-login.php') return;

    // 3. Nếu không phải những ông trên, "tiễn khách" về Laravel
    wp_redirect('https://your-laravel-site.com', 301); // Dùng 301 để tốt cho SEO
    exit;
});