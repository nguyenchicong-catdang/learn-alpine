# user

reset db
> wp db reset --yes

> wp core install --url=127.0.0.1:8080 --title="WP-CLI" --admin_user=test --admin_password=123456 --admin_email=info@wp-cli.org

doi mat khau neu user co san
> wp user update test --user_pass=123456

database: utf8mb4_unicode_ci

create user

wp user create test test@example.com --role=administrator --user_pass=123456