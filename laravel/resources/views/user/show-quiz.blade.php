@extends('layouts.main')


@section('content')
    <!-- Start::app-content -->
    <div class="main-content app-content">
        <div class="container-fluid">

            <!-- Page Header -->
            <div class="d-md-flex d-block align-items-center justify-content-between my-4 page-header-breadcrumb">
                <div>
                    <h2>Your Quiz is Ready!</h2>
                </div>
                <div class="ms-md-1 ms-0">
                    <nav>
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item active" aria-current="page">Show Quiz</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- Page Header Close -->

            <!-- Start::Show Quiz -->
            <div class="row">
                <div class="col-sm-12">
                    <div class="card shadow-sm">
                        <div class="card-body">

                            <h3 class="mb-3">Quiz: {{ $quiz['title'] }}</h3>
                            <p><strong>Description:</strong> {{ $quiz['description'] }}</p>
                            <p><strong>Start:</strong> {{ $quiz['startTime'] }}</p>
                            <p><strong>End:</strong> {{ $quiz['endTime'] }}</p>

                            <p><strong>Access URL:</strong>
                                <a href="{{ $domainUrl }}" target="_blank">{{ $domainUrl }}</a>
                            </p>

                            <div class="mt-3">
                                <img src="data:image/png;base64,{{ $qr }}" alt="QR Code">
                            </div>
                        </div>
                    </div>

                </div>
                <!--End::Show Quiz -->

            </div>
        </div>
        <!-- End::app-content -->
    @endsection
