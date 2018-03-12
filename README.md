# delight-im_php-auth-postgres
postgres sql scheme for using with delight-im/PHP-Auth library. php auth with postgress database

Please find the working version to start with PostgreSQL
create database and copy paste this sql or save in .sql and select as file.

To test: create php file with following code:
Please change host,dbname, user, password as per your setup in following PDO dsn

```
require '../vendor/autoload.php';
//please check with yout db port or leave 


// create pdo instance 
$dbh = new PDO("pgsql:host=localhost;dbname=auth;user=postgres;password=root");
//create auth instance
 $auth = new \Delight\Auth\Auth($dbh);

$email = 'myemail@gmail.com';
$password = 'easy#PWD@123';
$repeatpassword = 'easy#PWD@123';
$username = 'hello';



try {
    $userId = $auth->register($email, $password, $username, function ($selector, $token) {
        // send `$selector` and `$token` to the user (e.g. via email)

        echo '<pre>';
        print_r($userId);

    });

    // we have signed up a new user with the ID `$userId`
}
catch (\Delight\Auth\InvalidEmailException $e) {
    // invalid email address
    echo 'invalid email address: ' ;
}
catch (\Delight\Auth\InvalidPasswordException $e) {
    // invalid password
    echo 'invalid password: ' ;
}
catch (\Delight\Auth\UserAlreadyExistsException $e) {
    // user already exists
    echo 'user already exists: ';
    echo '<pre>';
    print_r($e);
}
catch (\Delight\Auth\TooManyRequestsException $e) {
    // too many requests
    echo 'too many requests: ' ;
}



try {
    $auth->login($email, $password );

    // user is logged in
}
catch (\Delight\Auth\InvalidEmailException $e) {
    // wrong email address
    echo 'wrong email address: ' ;
}
catch (\Delight\Auth\InvalidPasswordException $e) {
    // wrong password
    echo 'wrong password: ' ;
}
catch (\Delight\Auth\EmailNotVerifiedException $e) {
    // email not verified
    echo 'wrong not verified: ' ;
}
catch (\Delight\Auth\TooManyRequestsException $e) {
    // too many requests
    echo 'too many requests: ' ;
}


echo '<pre>';
echo '****************';


if (!$auth->isLoggedIn()) {
    header('HTTP/1.0 403 Forbidden');
    echo "Forbidden";
    exit();

}else{

	echo '**************** Logged In. *********************';
	echo $id = $auth->getUserId();
	echo $email = $auth->getEmail();
	echo $username = $auth->getUsername();
}


```
