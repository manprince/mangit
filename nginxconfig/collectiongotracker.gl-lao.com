server {
        client_max_body_size 50M;
proxy_connect_timeout 600;
proxy_send_timeout 600;
proxy_read_timeout 600;
send_timeout 600;
  listen 80;
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        server_name collectiongotracker.gl-lao.com;
        access_log  /var/log/nginx/collectiongo.access.log;
        error_log   /var/log/nginx/collectiongo.error.log;

        ssl_session_cache shared:SSL:20m;
        ssl_session_timeout 120m;
        ssl_prefer_server_ciphers on;
        ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DHE+AES128:!ADH:!AECDH:!MD5;
        #ssl_dhparam /etc/nginx/cert/dhparam.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_stapling on;
        ssl_stapling_verify on;
        resolver 8.8.8.8 8.8.4.4;
        add_header Strict-Transport-Security "max-age=63072000" always;
        root /opt/collectiongo/prod/running/;
        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html phoneno.php;
        
#  more_set_headers 'Access-Control-Allow-Origin: *';
#  more_set_headers 'Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE';
#  more_set_headers 'Access-Control-Allow-Credentials: true';
#  more_set_headers 'Access-Control-Allow-Headers: Origin,Content-Type,Accept,Authorization,App-Token,Session-Token,app_token';
  location / {
try_files $uri $uri/ /index.php?q=$uri&$args;
 #     try_files $uri $uri/ =404;
#      autoindex on;
  auth_basic  "Authorized personnel only.";
  auth_basic_user_file  /etc/nginx/.htpasswd;
}
   location ~ [^/]\.php(/|$) {
      fastcgi_pass unix:/run/php/php7.2-fpm.sock;

      # regex to split $uri to $fastcgi_script_name and $fastcgi_path
      fastcgi_split_path_info ^(.+\.php)(/.+)$;

      # Check that the PHP script exists before passing it
      try_files $fastcgi_script_name =404;

      # Bypass the fact that try_files resets $fastcgi_path_info
      # # see: http://trac.nginx.org/nginx/ticket/321
      set $path_info $fastcgi_path_info;
      fastcgi_param  PATH_INFO $path_info;

      fastcgi_param  PATH_TRANSLATED    $document_root$fastcgi_script_name;
      fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
     fastcgi_send_timeout 300;
      fastcgi_read_timeout 300;
      include fastcgi_params;

      # allow directory index
      fastcgi_index index.php;
  auth_basic  "Authorized personnel only.";
  auth_basic_user_file  /etc/nginx/.htpasswd;
   }

    ssl_certificate /etc/letsencrypt/live/collectiongotracker.gl-lao.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/collectiongotracker.gl-lao.com/privkey.pem; # managed by Certbot
}