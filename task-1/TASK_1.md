# Task goal

Analyze log `somesite.log` file for possible security threats.

# Investigation flow

1. At first, I checked the log file by eye. Straight away spotted few suspicious requests made from not common user agents like "Go-http-client", "wordpress" etc. so I filtered out requests:
    ```
    cat somesite.log | egrep -v "Mozilla/5.0|Mozilla/5.1|Virusdie crawler/3.0|Nuhk/2.4|WordPress/5.2.3"
    ```
    - `Mozilla/5.0`/`Mozilla/5.1` - general mozilla compatible browsers
    - `Nuhk/2.4` - seems to be related to neti.ee search engine
    - `WordPress/5.2.3` - Wordpress cron 
    <details>
    <summary>Results:</summary>
    <pre>
    198.71.235.46 - - [02/Oct/2019:03:45:09 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    54.201.2.170 - - [02/Oct/2019:04:27:21 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.201.2.170 - - [02/Oct/2019:04:27:23 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    50.62.208.202 - - [02/Oct/2019:10:18:48 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    106.75.25.223 - - [02/Oct/2019:10:28:53 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    117.18.65.22 - - [02/Oct/2019:17:56:10 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    94.124.93.186 - - [03/Oct/2019:00:28:43 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    106.75.104.107 - - [03/Oct/2019:06:54:56 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    148.72.92.137 - - [03/Oct/2019:07:29:37 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    117.50.2.17 - - [03/Oct/2019:16:16:16 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    106.75.22.46 - - [03/Oct/2019:18:52:02 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    54.213.250.160 - - [04/Oct/2019:02:51:25 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.213.250.160 - - [04/Oct/2019:02:51:26 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    106.75.104.107 - - [04/Oct/2019:09:56:57 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    54.148.145.38 - - [05/Oct/2019:10:08:03 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.148.145.38 - - [05/Oct/2019:10:08:04 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    117.50.19.93 - - [05/Oct/2019:10:19:28 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    54.70.146.251 - - [06/Oct/2019:10:20:35 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.70.146.251 - - [06/Oct/2019:10:20:36 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    117.50.19.93 - - [06/Oct/2019:11:22:32 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    107.180.109.9 - - [06/Oct/2019:17:37:12 +0300] "POST /xmlrpc.php HTTP/1.1" 200 402 "-" "Poster"
    117.50.19.93 - - [07/Oct/2019:12:38:05 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    34.216.172.162 - - [07/Oct/2019:14:14:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.216.172.162 - - [07/Oct/2019:14:14:13 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    43.229.213.74 - - [07/Oct/2019:23:55:21 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "http://somepage.co.uk" "-"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../index.php HTTP/1.1" 403 - "-" "Chrome"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php HTTP/1.1" 403 - "-" "Chrome"
    117.50.19.93 - - [08/Oct/2019:08:39:45 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    54.190.91.150 - - [09/Oct/2019:10:34:36 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.190.91.150 - - [09/Oct/2019:10:34:37 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    106.75.22.46 - - [09/Oct/2019:10:57:05 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    72.167.190.205 - - [10/Oct/2019:03:49:57 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    85.95.237.209 - - [10/Oct/2019:07:53:35 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    34.214.89.88 - - [10/Oct/2019:11:34:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.214.89.88 - - [10/Oct/2019:11:34:16 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    91.82.85.66 - - [10/Oct/2019:18:42:30 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    35.238.192.153 - - [11/Oct/2019:00:16:35 +0300] "GET /robots.txt HTTP/1.1" 403 - "-" "python-requests/2.22.0"
    35.238.192.153 - - [11/Oct/2019:00:16:37 +0300] "GET / HTTP/1.1" 302 227 "-" "python-requests/2.22.0"
    35.238.192.153 - - [11/Oct/2019:00:16:40 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "python-requests/2.22.0"
    190.107.177.45 - - [11/Oct/2019:01:14:10 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    148.66.145.166 - - [11/Oct/2019:05:15:27 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    34.217.135.125 - - [11/Oct/2019:12:34:53 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.217.135.125 - - [11/Oct/2019:12:34:54 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    60.205.228.21 - - [11/Oct/2019:21:29:31 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    148.66.146.40 - - [12/Oct/2019:09:10:18 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    89.46.106.229 - - [12/Oct/2019:14:56:34 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    204.101.161.11 - - [13/Oct/2019:02:45:30 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    204.101.161.11 - - [13/Oct/2019:02:45:30 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "http://somepage.co.uk" "Go-http-client/1.1"
    104.238.120.6 - - [13/Oct/2019:12:21:41 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    50.62.177.214 - - [13/Oct/2019:16:20:05 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    93.188.2.5 - - [13/Oct/2019:21:00:34 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    89.46.108.90 - - [14/Oct/2019:01:41:14 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    160.153.153.1 - - [14/Oct/2019:06:48:54 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    </pre>
    </details>

2. In the results, I've quickly spotted lots of suspicious POST requests to `/xmlrpc.php`, as it is commonly used for exploits. Investigated it further:

    ```
    cat somesite.log | egrep -v "Mozilla/5.0|Mozilla/5.1|Virusdie crawler/3.0|Nuhk/2.4|WordPress/5.2.3"  | egrep "/xmlrpc.php"
    ```
    <details>
    <summary>Results:</summary>
    <pre>
    198.71.235.46 - - [02/Oct/2019:03:45:09 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    50.62.208.202 - - [02/Oct/2019:10:18:48 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    117.18.65.22 - - [02/Oct/2019:17:56:10 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    94.124.93.186 - - [03/Oct/2019:00:28:43 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    148.72.92.137 - - [03/Oct/2019:07:29:37 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    107.180.109.9 - - [06/Oct/2019:17:37:12 +0300] "POST /xmlrpc.php HTTP/1.1" 200 402 "-" "Poster"
    43.229.213.74 - - [07/Oct/2019:23:55:21 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "http://somepage.co.uk" "-"
    72.167.190.205 - - [10/Oct/2019:03:49:57 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    85.95.237.209 - - [10/Oct/2019:07:53:35 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    91.82.85.66 - - [10/Oct/2019:18:42:30 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    190.107.177.45 - - [11/Oct/2019:01:14:10 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Windows Live Writter"
    148.66.145.166 - - [11/Oct/2019:05:15:27 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    60.205.228.21 - - [11/Oct/2019:21:29:31 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    148.66.146.40 - - [12/Oct/2019:09:10:18 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    89.46.106.229 - - [12/Oct/2019:14:56:34 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    104.238.120.6 - - [13/Oct/2019:12:21:41 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    50.62.177.214 - - [13/Oct/2019:16:20:05 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    93.188.2.5 - - [13/Oct/2019:21:00:34 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "WordPress"
    89.46.108.90 - - [14/Oct/2019:01:41:14 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    160.153.153.1 - - [14/Oct/2019:06:48:54 +0300] "POST /xmlrpc.php HTTP/1.1" 403 - "-" "Poster"
    </pre>
    </details>

    All of those requests seem to be a targeted attack trying to get remote access to WordPress, all of them are coming from weird UserAgents like `Poster` or `WordPress`. But one of the requests was successful, which may mean that system was exploited:

    ```
    107.180.109.9 - - [06/Oct/2019:17:37:12 +0300] "POST /xmlrpc.php HTTP/1.1" 200 402 "-" "Poster"
    ```

3. Continued investigation by filtering out requests made to `xmlrpc.php`.
    ```
    cat somesite.log | egrep -v "Mozilla/5.0|Mozilla/5.1|Virusdie crawler/3.0|Nuhk/2.4|WordPress/5.2.3|/xmlrpc.php"
    ```
    <details>
    <summary>Results:</summary>
    <pre>
    54.201.2.170 - - [02/Oct/2019:04:27:21 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.201.2.170 - - [02/Oct/2019:04:27:23 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    106.75.25.223 - - [02/Oct/2019:10:28:53 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    106.75.104.107 - - [03/Oct/2019:06:54:56 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    117.50.2.17 - - [03/Oct/2019:16:16:16 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    106.75.22.46 - - [03/Oct/2019:18:52:02 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    54.213.250.160 - - [04/Oct/2019:02:51:25 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.213.250.160 - - [04/Oct/2019:02:51:26 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    106.75.104.107 - - [04/Oct/2019:09:56:57 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_181"
    54.148.145.38 - - [05/Oct/2019:10:08:03 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.148.145.38 - - [05/Oct/2019:10:08:04 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    117.50.19.93 - - [05/Oct/2019:10:19:28 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    54.70.146.251 - - [06/Oct/2019:10:20:35 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.70.146.251 - - [06/Oct/2019:10:20:36 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    117.50.19.93 - - [06/Oct/2019:11:22:32 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    117.50.19.93 - - [07/Oct/2019:12:38:05 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    34.216.172.162 - - [07/Oct/2019:14:14:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.216.172.162 - - [07/Oct/2019:14:14:13 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../index.php HTTP/1.1" 403 - "-" "Chrome"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php HTTP/1.1" 403 - "-" "Chrome"
    117.50.19.93 - - [08/Oct/2019:08:39:45 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_222"
    54.190.91.150 - - [09/Oct/2019:10:34:36 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.190.91.150 - - [09/Oct/2019:10:34:37 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    106.75.22.46 - - [09/Oct/2019:10:57:05 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Java/1.8.0_151"
    34.214.89.88 - - [10/Oct/2019:11:34:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.214.89.88 - - [10/Oct/2019:11:34:16 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    35.238.192.153 - - [11/Oct/2019:00:16:35 +0300] "GET /robots.txt HTTP/1.1" 403 - "-" "python-requests/2.22.0"
    35.238.192.153 - - [11/Oct/2019:00:16:37 +0300] "GET / HTTP/1.1" 302 227 "-" "python-requests/2.22.0"
    35.238.192.153 - - [11/Oct/2019:00:16:40 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "python-requests/2.22.0"
    34.217.135.125 - - [11/Oct/2019:12:34:53 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.217.135.125 - - [11/Oct/2019:12:34:54 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "-" "Go-http-client/1.1"
    204.101.161.11 - - [13/Oct/2019:02:45:30 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    204.101.161.11 - - [13/Oct/2019:02:45:30 +0300] "GET /cgi-sys/suspendedpage.cgi HTTP/1.1" 200 7568 "http://somepage.co.uk" "Go-http-client/1.1"
    </pre>
    </details>

    Found lots of successful GET requests made to `/cgi-sys/suspendedpage.cgi`, it may signalize that website was down at that time (maybe maintenance). Doesn't seem harmful security-wise.

4. As a next step, I've filtered out requests made to `/cgi-sys/suspendedpage.cgi` 
    ```
    cat somesite.log | egrep -v "Mozilla/5.0|Mozilla/5.1|Virusdie crawler/3.0|Nuhk/2.4|WordPress/5.2.3|/xmlrpc.php|/cgi-sys/suspendedpage.cgi"
    ```
    <details>
    <summary>Results:</summary>
    <pre>
    54.201.2.170 - - [02/Oct/2019:04:27:21 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.213.250.160 - - [04/Oct/2019:02:51:25 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.148.145.38 - - [05/Oct/2019:10:08:03 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    54.70.146.251 - - [06/Oct/2019:10:20:35 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.216.172.162 - - [07/Oct/2019:14:14:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../index.php HTTP/1.1" 403 - "-" "Chrome"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php HTTP/1.1" 403 - "-" "Chrome"
    54.190.91.150 - - [09/Oct/2019:10:34:36 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    34.214.89.88 - - [10/Oct/2019:11:34:12 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    35.238.192.153 - - [11/Oct/2019:00:16:35 +0300] "GET /robots.txt HTTP/1.1" 403 - "-" "python-requests/2.22.0"
    35.238.192.153 - - [11/Oct/2019:00:16:37 +0300] "GET / HTTP/1.1" 302 227 "-" "python-requests/2.22.0"
    34.217.135.125 - - [11/Oct/2019:12:34:53 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    204.101.161.11 - - [13/Oct/2019:02:45:30 +0300] "GET / HTTP/1.1" 302 227 "-" "Go-http-client/1.1"
    </pre>
    </details>

    And two GET requests stood out straight away with directory traversal attempts:

    ```
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../index.php HTTP/1.1" 403 - "-" "Chrome"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php HTTP/1.1" 403 - "-" "Chrome"
    ```

5. Next, I've investigated requests which were filtered out in step `1` and made from `Mozilla/5.0`/`Mozilla/5.1` compatible UserAgents (`Nuhk/2.4` and `WordPress/5.2.3` intentionally left aside since there were only several not harmful requests from those UserAgents). 
    ```
    cat somesite.log |egrep -v "Nuhk/2.4|WordPress/5.2.3" |egrep "Mozilla/5.(0|1)"
    ```

    Since the result was still too big decided to manually check for SQL injection attempts.

    ```
    cat somesite.log |egrep -v "Nuhk/2.4|WordPress/5.2.3" |egrep "Mozilla/5.(0|1)" | egrep -i "drop|update|insert|sql"
    ```

    <details>
    <summary>Results:</summary>
    <pre>
    165.227.133.145 - - [03/Oct/2019:11:14:14 +0300] "GET //base.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    77.102.75.238 - - [03/Oct/2019:12:38:47 +0300] "GET //bdata.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    77.96.223.91 - - [03/Oct/2019:13:20:51 +0300] "GET //blog.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    139.59.14.115 - - [03/Oct/2019:14:06:10 +0300] "GET //blogs.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.243.236.16 - - [03/Oct/2019:14:52:36 +0300] "GET //cms.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    85.27.188.207 - - [03/Oct/2019:15:21:33 +0300] "GET //c.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    77.98.205.223 - - [03/Oct/2019:15:51:07 +0300] "GET //table.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    50.62.30.20 - - [03/Oct/2019:16:21:10 +0300] "GET //tables.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    67.207.94.61 - - [03/Oct/2019:17:19:47 +0300] "GET //admin.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    134.209.248.194 - - [03/Oct/2019:17:50:27 +0300] "GET //administrator/sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    37.77.239.38 - - [03/Oct/2019:18:21:07 +0300] "GET //http.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    108.28.124.224 - - [03/Oct/2019:18:49:25 +0300] "GET //posts.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    42.200.106.20 - - [03/Oct/2019:19:18:50 +0300] "GET //post.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    198.46.160.173 - - [03/Oct/2019:19:48:28 +0300] "GET //schema.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    92.92.211.166 - - [03/Oct/2019:20:17:58 +0300] "GET //webdata.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    77.96.223.91 - - [03/Oct/2019:20:46:47 +0300] "GET //webapp.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.23.77.149 - - [03/Oct/2019:21:17:08 +0300] "GET //website.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.247.153.73 - - [03/Oct/2019:21:46:18 +0300] "GET //weblog.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    202.161.117.92 - - [03/Oct/2019:22:17:09 +0300] "GET //work.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    46.20.4.154 - - [03/Oct/2019:22:47:46 +0300] "GET //test.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    142.93.157.155 - - [03/Oct/2019:23:19:33 +0300] "GET //x.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    50.62.30.20 - - [04/Oct/2019:00:20:16 +0300] "GET //xsql.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.37.248.189 - - [04/Oct/2019:00:51:14 +0300] "GET //xdb.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    85.27.188.207 - - [04/Oct/2019:01:21:32 +0300] "GET //~www.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    91.69.163.85 - - [04/Oct/2019:01:53:23 +0300] "GET //reserv.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    136.36.8.172 - - [04/Oct/2019:02:24:24 +0300] "GET //res.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    139.59.14.115 - - [04/Oct/2019:03:26:35 +0300] "GET //script.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    24.133.104.90 - - [04/Oct/2019:03:57:53 +0300] "GET //a.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    120.150.28.188 - - [04/Oct/2019:05:28:59 +0300] "GET //admin.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.23.77.149 - - [04/Oct/2019:06:31:42 +0300] "GET //backend.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    86.52.9.103 - - [04/Oct/2019:07:02:13 +0300] "GET //bak.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    109.19.160.172 - - [04/Oct/2019:08:05:28 +0300] "GET //back-up.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    50.62.30.20 - - [04/Oct/2019:08:37:35 +0300] "GET //audit.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    152.165.53.192 - - [04/Oct/2019:09:09:52 +0300] "GET //b.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    69.140.173.85 - - [04/Oct/2019:09:41:20 +0300] "GET //1.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    194.42.111.204 - - [04/Oct/2019:10:45:41 +0300] "GET //123.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    124.158.6.218 - - [04/Oct/2019:11:16:30 +0300] "GET //111.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    58.108.219.32 - - [04/Oct/2019:11:47:16 +0300] "GET //sql.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    42.200.106.20 - - [04/Oct/2019:12:50:31 +0300] "GET //web.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    85.27.188.207 - - [04/Oct/2019:15:27:54 +0300] "GET //somepage1.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    93.54.88.248 - - [04/Oct/2019:17:06:21 +0300] "GET //somepage.co.uk1.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.72.253.167 - - [04/Oct/2019:19:16:47 +0300] "GET //wordpress.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    24.133.104.90 - - [04/Oct/2019:20:22:15 +0300] "GET //w.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    73.158.78.102 - - [04/Oct/2019:21:27:09 +0300] "GET //phpmyadmin.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    106.167.77.23 - - [04/Oct/2019:22:00:19 +0300] "GET //export.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    176.79.14.72 - - [04/Oct/2019:22:34:16 +0300] "GET //exp.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.202.183.69 - - [04/Oct/2019:23:06:35 +0300] "GET //tables.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    206.189.154.111 - - [05/Oct/2019:00:12:53 +0300] "GET //123.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    128.199.208.71 - - [05/Oct/2019:01:18:44 +0300] "GET //my.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    165.227.83.167 - - [05/Oct/2019:02:25:10 +0300] "GET //back.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.202.183.69 - - [05/Oct/2019:03:31:00 +0300] "GET //mysql.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    157.245.33.57 - - [05/Oct/2019:04:03:31 +0300] "GET //sql.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    50.62.30.20 - - [05/Oct/2019:04:36:21 +0300] "GET //dump.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    128.199.208.71 - - [05/Oct/2019:06:14:04 +0300] "GET //somepage.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    2.237.242.230 - - [05/Oct/2019:07:19:51 +0300] "GET //somepage.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    109.25.0.137 - - [05/Oct/2019:08:58:42 +0300] "GET //somepage.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.28.250.184 - - [05/Oct/2019:10:11:49 +0300] "GET //somepage.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    220.75.179.116 - - [05/Oct/2019:10:45:48 +0300] "GET //somepage.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    165.227.133.145 - - [06/Oct/2019:10:04:49 +0300] "GET //base.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    93.113.111.197 - - [06/Oct/2019:10:37:21 +0300] "GET //data.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    139.59.14.115 - - [06/Oct/2019:11:11:27 +0300] "GET //bdata.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    68.148.138.240 - - [06/Oct/2019:11:45:02 +0300] "GET //blog.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    77.96.223.91 - - [06/Oct/2019:12:19:07 +0300] "GET //blogs.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.202.183.69 - - [06/Oct/2019:13:24:51 +0300] "GET //c.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    93.113.111.197 - - [06/Oct/2019:13:58:45 +0300] "GET //table.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    24.160.118.61 - - [06/Oct/2019:15:49:35 +0300] "GET //admin.sql HTTP/1.1" 301 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    24.160.118.61 - - [06/Oct/2019:15:49:44 +0300] "GET /admin.sql HTTP/1.1" 404 29469 "http://www.somepage.co.uk:80//admin.sql" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    87.119.182.21 - - [06/Oct/2019:16:12:01 +0300] "GET /wp-content/themes/daycare/assets/images/dropdownhanger.png HTTP/1.1" 200 6170 "http://www.somepage.co.uk/wp-content/themes/daycare/assets/css/style.css" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
    27.109.156.24 - - [06/Oct/2019:16:23:34 +0300] "GET //administrator/sql HTTP/1.1" 301 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    27.109.156.24 - - [06/Oct/2019:16:23:36 +0300] "GET /administrator/sql HTTP/1.1" 404 29469 "http://www.somepage.co.uk:80//administrator/sql" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    213.180.22.96 - - [06/Oct/2019:16:30:04 +0300] "GET /wp-content/themes/daycare/assets/images/dropdownhanger.png HTTP/1.1" 200 6170 "http://www.somepage.co.uk/wp-content/themes/daycare/assets/css/style.css" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
    2.237.242.230 - - [06/Oct/2019:16:59:11 +0300] "GET //http.sql HTTP/1.1" 301 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    31.27.1.147 - - [06/Oct/2019:17:32:37 +0300] "GET //posts.sql HTTP/1.1" 301 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    31.27.1.147 - - [06/Oct/2019:17:32:41 +0300] "GET /posts.sql HTTP/1.1" 404 29469 "http://www.somepage.co.uk:80//posts.sql" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    108.48.14.13 - - [06/Oct/2019:18:05:41 +0300] "GET //post.sql HTTP/1.1" 301 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    128.199.208.71 - - [06/Oct/2019:18:30:53 +0300] "GET //schema.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    73.202.228.48 - - [06/Oct/2019:20:13:02 +0300] "GET //website.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    42.200.106.20 - - [06/Oct/2019:20:44:49 +0300] "GET //weblog.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.202.183.69 - - [06/Oct/2019:21:17:44 +0300] "GET //work.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    73.158.78.102 - - [06/Oct/2019:21:51:02 +0300] "GET //test.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    73.70.125.47 - - [06/Oct/2019:22:24:52 +0300] "GET //x.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    27.109.156.24 - - [06/Oct/2019:22:56:48 +0300] "GET //xxx.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    93.113.111.197 - - [06/Oct/2019:23:30:03 +0300] "GET //xsql.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    24.11.216.231 - - [07/Oct/2019:00:03:51 +0300] "GET //xdb.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    139.59.14.115 - - [07/Oct/2019:00:36:38 +0300] "GET //~www.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    219.250.29.108 - - [07/Oct/2019:01:10:51 +0300] "GET //reserv.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    120.150.28.188 - - [07/Oct/2019:02:15:26 +0300] "GET //r.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.247.153.73 - - [07/Oct/2019:02:48:24 +0300] "GET //script.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    124.158.6.218 - - [07/Oct/2019:03:21:51 +0300] "GET //a.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    86.52.9.103 - - [07/Oct/2019:03:55:17 +0300] "GET //reserve.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    37.77.239.38 - - [07/Oct/2019:04:28:52 +0300] "GET //backups.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    69.140.173.85 - - [07/Oct/2019:05:01:43 +0300] "GET //admin.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    5.172.218.82 - - [07/Oct/2019:06:07:58 +0300] "GET //backend.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    211.176.125.70 - - [07/Oct/2019:06:16:05 +0300] "GET /reserv.sql HTTP/1.0" 403 - "-" "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)"
    42.200.129.213 - - [07/Oct/2019:07:13:57 +0300] "GET //back.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    73.70.125.47 - - [07/Oct/2019:08:55:19 +0300] "GET //b.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    42.200.106.20 - - [07/Oct/2019:09:27:37 +0300] "GET //1.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    96.54.244.117 - - [07/Oct/2019:10:00:04 +0300] "GET //2.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    84.195.232.248 - - [07/Oct/2019:10:30:34 +0300] "GET //123.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    35.202.183.69 - - [07/Oct/2019:11:58:37 +0300] "GET //site.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    46.20.4.154 - - [07/Oct/2019:13:27:03 +0300] "GET //config.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    84.195.232.248 - - [07/Oct/2019:14:25:58 +0300] "GET //user.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    157.245.33.57 - - [07/Oct/2019:15:32:28 +0300] "GET //somepage123.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    27.109.156.24 - - [07/Oct/2019:16:05:49 +0300] "GET //somepage.co.uk1.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    5.172.218.82 - - [07/Oct/2019:17:14:26 +0300] "GET //s.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    67.207.94.61 - - [07/Oct/2019:17:49:19 +0300] "GET //db.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    70.72.180.42 - - [07/Oct/2019:18:25:06 +0300] "GET //database.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    81.170.128.115 - - [07/Oct/2019:20:42:10 +0300] "GET //dba.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    37.77.239.38 - - [07/Oct/2019:21:49:39 +0300] "GET //export.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    68.148.138.240 - - [07/Oct/2019:22:22:42 +0300] "GET //exp.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    68.148.138.240 - - [07/Oct/2019:23:29:22 +0300] "GET //table.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    157.245.33.57 - - [08/Oct/2019:00:02:48 +0300] "GET //123.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    46.20.4.154 - - [08/Oct/2019:00:36:04 +0300] "GET //111.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    82.23.77.149 - - [08/Oct/2019:01:10:25 +0300] "GET //my.sql HTTP/1.1" 403 - "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
    </pre>
    </details>

    We can see lots of GET requests made to `*.sql` files which indicate on SQL injection attack.


# Results 
 
As a result of a log file security threat analysis, several attacks were spotted:

1. `xmlrpc.php` exploit attempts, and most likely 1 of the attempts was successful (see `2.` in `Investigation flow` for more detailed results):
    ```
    107.180.109.9 - - [06/Oct/2019:17:37:12 +0300] "POST /xmlrpc.php HTTP/1.1" 200 402 "-" "Poster"
    ```
2. directory traversal attempts (see `4.` in `Investigation flow` for more detailed results):
    ```
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../index.php HTTP/1.1" 403 - "-" "Chrome"
    176.9.71.213 - - [08/Oct/2019:05:13:29 +0300] "GET /wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php HTTP/1.1" 403 - "-" "Chrome"
    ```
3. lots of SQL injection attack attempts (see `5.` in `Investigation flow` for more detailed results)

Out of them all, 1st threat with a successful POST request to `xmlrpc.php` from `Poster` UserAgent seem to be the most dangerous one. Since it was a successful request and attacker may potentially get access to WordPress. 
