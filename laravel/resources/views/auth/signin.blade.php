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

    <div class="container">
        <div class="row justify-content-center align-items-center authentication authentication-basic h-100">
            <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-6 col-sm-8 col-12">

                <!-- Start Alerts -->
                @if (session('success'))
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        {{ session('success') }}
                        <button class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif

                {{-- Laravel validation --}}
                @if ($errors->any())
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <ul class="mb-0 ps-3">
                            @foreach ($errors->all() as $e)
                                <li>{{ $e }}</li>
                            @endforeach
                        </ul>
                        <button class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif

                {{-- API errors --}}
                @if (session('error_list'))
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <ul class="mb-0 ps-3">
                            @foreach (session('error_list') as $e)
                                <li>{{ $e }}</li>
                            @endforeach
                        </ul>
                        <button class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @elseif(session('error'))
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        {{ session('error') }}
                        <button class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif
                <!-- End Alerts -->
                <form action="{{ route('auth-user') }}" method="POST">
                    @csrf
                    <div class="card custom-card shadow-sm">
                        <div class="card-body p-5">
                            <p class="h5 fw-semibold mb-2 text-center">Sign In</p>
                            <p class="mb-4 text-muted op-7 fw-normal text-center">Welcome to Pop Quiz !</p>
                            <div class="row gy-3">
                                <div class="col-xl-12">
                                    <label for="signin-username" class="form-label text-default">Username</label>
                                    <input type="text" class="form-control form-control-lg" id="signin-username"
                                        name="username" placeholder="Enter your username" value="{{ old('username') }}">
                                </div>
                                <div class="col-xl-12 mb-4">
                                    <label for="signin-password"
                                        class="form-label text-default d-block">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control form-control-lg" id="signin-password"
                                            name="password" placeholder="Enter your password">
                                        <button class="btn btn-light" type="button"
                                            onclick="createpassword('signin-password',this)" id="button-addon2"><i
                                                class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>
                                <div class="col-xl-12 d-grid mt-2">
                                    <button type="submit" class="btn btn-lg btn-primary">Sign In</button>
                                </div>
                            </div>
                            <div class="text-center">
                                <p class="fs-12 text-muted mt-3">Dont have an account? <a
                                        href="{{ route('signup-page') }}" class="text-primary">Sign Up</a></p>
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
