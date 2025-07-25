<!DOCTYPE html>
<html lang="en" dir="ltr" data-nav-layout="vertical" data-vertical-style="overlay" data-theme-mode="light"
    data-header-styles="light" data-menu-styles="light" data-toggled="close">

<head>
    <!-- Meta Data -->
    <meta charset="UTF-8">
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title> Pop Quiz - {{ $title }} </title>
    <meta name="Description" content="DAD-PROJECT">
    <meta name="Author" content="MX GROUP">
    <meta name="keywords" content="distributed,pop-quiz,game,question">

    <!-- Favicon -->
    <link rel="icon" href="../assets/images/brand-logos/favicon.ico" type="image/x-icon">

    <!-- Main Theme Js -->
    <script src="../assets/js/authentication-main.js"></script>

    <!-- Bootstrap Css -->
    <link id="style" href="../assets/libs/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Style Css -->
    <link href="../assets/css/styles.min.css" rel="stylesheet">

    <!-- Icons Css -->
    <link href="../assets/css/icons.min.css" rel="stylesheet">


</head>

<body>
    <div class="container-lg">
        <div class="row justify-content-center align-items-center authentication authentication-basic h-100">
            <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-6 col-sm-8 col-12">
                <!-- Start Alert -->

                <!-- Success Message -->
                @if (session('success'))
                    <div class="alert alert-success d-flex align-items-center alert-dismissible fade show"
                        role="alert">
                        <i class="bi bi-check-circle-fill fs-3 me-2"></i>
                        <div>
                            {{ session('success') }}
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                @endif

                <!-- Laravel Validation Errors -->
                @if ($errors->any())
                    <div class="alert alert-danger d-flex align-items-start alert-dismissible fade show" role="alert">
                        <div>
                            <strong>Whoops! Something went wrong:</strong>
                            <ul class="mt-2 mb-0 ps-3">
                                @foreach ($errors->all() as $msg)
                                    <li>{{ $msg }}</li>
                                @endforeach
                            </ul>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                @endif

                <!-- API Validation Errors -->
                @if (session('error_list'))
                    <div class="alert alert-warning d-flex align-items-start alert-dismissible fade show"
                        role="alert">
                        <div>
                            <strong>API Errors:</strong>
                            <ul class="mt-2 mb-0 ps-3">
                                @foreach (session('error_list') as $msg)
                                    <li>{{ $msg }}</li>
                                @endforeach
                            </ul>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                @elseif(session('error'))
                    <div class="alert alert-warning d-flex align-items-center alert-dismissible fade show"
                        role="alert">
                        <div>{{ session('error') }}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                @endif

                <!-- End Alert -->
                <form action="{{ route('signup-user') }}" method="POST">
                    @csrf
                    <div class="card custom-card">
                        <div class="card-body p-5">
                            <p class="h5 fw-semibold mb-2 text-center">Sign Up</p>
                            <p class="mb-4 text-muted op-7 fw-normal text-center">Welcome to Pop Quiz ! Join us by
                                creating
                                a free account !</p>
                            <div class="row gy-3">
                                <div class="col-xl-12">
                                    <label for="signup-username" class="form-label text-default">Username</label>
                                    <input type="text" class="form-control form-control-lg" name="username"
                                        id="signup-username" placeholder="Enter your username" value="{{ old('username') }}">
                                </div>
                                <div class="col-xl-12">
                                    <label for="signup-email" class="form-label text-default">Email</label>
                                    <input type="email" class="form-control form-control-lg" name="email"
                                        id="signup-email" placeholder="Enter your email" value="{{ old('email') }}">
                                </div>
                                <div class="col-xl-12 mb-3">
                                    <label for="signup-password" class="form-label text-default">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control form-control-lg" id="signup-password"
                                            name="password" placeholder="Enter your password">
                                        <button class="btn btn-light" onclick="createpassword('signup-password',this)"
                                            type="button" id="button-addon2"><i
                                                class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>

                                <div class="col-xl-12 d-grid mt-2">
                                    <button type="submit" class="btn btn-lg btn-primary">Create Account</button>
                                </div>
                            </div>
                            <div class="text-center">
                                <p class="fs-12 text-muted mt-3">Already have an account? <a
                                        href="{{ route('signin-page') }}" class="text-primary">Sign In</a></p>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="../assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Show Password JS -->
    <script src="../assets/js/show-password.js"></script>

</body>

</html>
