# Store
sudo rabbitmqctl add_user ai_scanner_store FPT2025innova
sudo rabbitmqctl set_permissions -p / ai_scanner_store ".*" ".*" ".*"
sudo rabbitmqctl set_user_tags ai_scanner_store administrator

# AI cam
sudo rabbitmqctl add_user ai_camera FPT2025aicam
sudo rabbitmqctl set_permissions -p / ai_camera ".*" ".*" ".*"
sudo rabbitmqctl set_user_tags ai_camera administrator

# smart menu
sudo rabbitmqctl add_user smart_menu FPT2025menu
sudo rabbitmqctl set_permissions -p / smart_menu ".*" ".*" ".*"
sudo rabbitmqctl set_user_tags smart_menu administrator
