<?php
// database might not exist, so let's try creating it (just to be safe)

error_reporting(E_ERROR | E_PARSE);

$stderr = fopen('php://stderr', 'w');

const RETRY_MAX_ATTEMPTS = 10;

const DB_HOST     = $argv[1];
const DB_USER     = $argv[2];
const DB_PASSWORD = $argv[3];
const DB_NAME     = $argv[4];
const TBL_PREFIX  = $argv[5];
const SSL         = $argv[6];
const APP_DIR     = $argv[7];

$port = 0;
list($host, $socket) = explode(':', DB_HOST, 2);
if (is_numeric($socket)) {
    $port = (int) $socket;
    $socket = null;
}

$maxTries = RETRY_MAX_ATTEMPTS;
do {
    $con = mysqli_init();
    if (isset(SSL) && !empty(SSL)) {
        mysqli_ssl_set($con, NULL, NULL, APP_DIR . SSL, NULL, NULL);
    }
    $mysql = mysqli_real_connect($con, $host, DB_USER, DB_PASSWORD, '', $port, $socket, MYSQLI_CLIENT_SSL_DONT_VERIFY_SERVER_CERT);
    if (!$mysql) {
        fwrite($stderr, "\n" . 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
        $maxTries--;
        if ($maxTries <= 0) {
            exit(1);
        }
        sleep(3);
    }
} while (!$mysql);

if (!$con->query('CREATE DATABASE IF NOT EXISTS `' . $con->real_escape_string(DB_NAME) . '`')) {
    fwrite($stderr, "\n" . 'MySQL "CREATE DATABASE" Error: ' . $con->error . "\n");
    $con->close();
    exit(1);
}

$con->select_db($con->real_escape_string(DB_NAME));

$inst = $con->query("SELECT * FROM `" . $con->real_escape_string(TBL_PREFIX) . "users`");

$con->close();

if ($inst->num_rows > 0) {
        exit("DBEXISTS");
} else {
        exit(0);
}