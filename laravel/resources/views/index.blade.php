<!DOCTYPE html>
<html lang="en" dir="ltr" data-nav-layout="vertical" data-vertical-style="overlay" data-theme-mode="light"
    data-header-styles="light" data-menu-styles="light" data-toggled="close">

<head>

    <!-- Meta Data -->
    <meta charset="UTF-8">
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Pop Quiz</title>
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

                <!-- Start Authentication Card -->
                <div class="card custom-card shadow-sm">
                    <div class="card-body p-5">
                        <p class="h5 fw-semibold mb-2 text-center">Quick Join Quiz</p>
                        <p class="mb-4 text-muted op-7 fw-normal text-center">Already have a quiz code? Fill in the form below and quickly join the quiz!.</p>
                        
                        <form action="{{ route('join-game-guest') }}" method="POST">
                            @csrf
                            <div class="row gy-3">
                                <div class="col-xl-12">
                                    <label for="username" class="form-label">Your Name</label>
                                    <input type="text" class="form-control form-control-lg" id="username" name="username" placeholder="Enter your name" value="{{ old('username') }}">
                                </div>
                                <div class="col-xl-12">
                                    <label for="gameCode" class="form-label">Game Code</label>
                                    <input type="text" class="form-control form-control-lg" id="gameCode" name="gameCode" placeholder="Enter Game Code" value="{{ old('gameCode') }}">
                                </div>
                                <div class="col-xl-12 d-grid mt-2">
                                    <button type="submit" class="btn btn-lg btn-primary">Join Game</button>
                                </div>
                            </div>

                            <div class="text-center">
                                <p class="fs-12 text-muted mt-3">Already Have an account? <a
                                        href="{{ route('signin-page') }}" class="text-primary">Sign In</a></p>
                            </div>
                            
                            <div class="text-center">
                                <p class="fs-12 text-muted mt-3">Don't have an account? <a
                                        href="{{ route('signup-page') }}" class="text-primary">Sign Up</a></p>
                            </div>

                            
                        </form>
                    </div>
                </div>
                <!-- End Join Game Section -->


            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="../assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Show Password JS -->
    <script src="../assets/js/show-password.js"></script>

</body>

</html>
