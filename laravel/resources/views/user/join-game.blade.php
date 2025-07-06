@extends('layouts.main')

@section('content')
    <!-- Start::app-content -->
    <div class="main-content app-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row align-items-center justify-content-between my-4">
                <div class="mb-3 mb-md-0">
                    <h1 class="page-title fw-semibold fs-3 mb-2">Welcome back, {{ session('api_user.username') }}!</h1>
                    <p class="text-muted mb-0">Ready to join an exciting quiz game?</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="#">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Join Quiz</li>
                    </ol>
                </nav>
            </div>
            <!-- Page Header Close -->

            <!-- Start::Join Quiz Card -->
            <div class="row justify-content-center">
                <div class="col-xl-5 col-lg-6 col-md-8">
                    <div class="card border-0 shadow-lg overflow-hidden mt-4">
                        <div class="card-header bg-gradient-primary p-4 position-relative">
                            <div class="position-absolute top-0 end-0 mt-3 me-3">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-activity text-white opacity-50"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            </div>
                            <h4 class="mb-0 text-dark">Join Quiz Session</h4>
                            <p class="text-dark-50 mb-0">Enter your details to participate</p>
                        </div>
                        <div class="card-body p-4">
                            @if (session('server_response'))
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <pre class="mb-0">{{ session('server_response') }}</pre>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            @endif

                            <form action="{{ route('join-game') }}" method="POST" class="needs-validation" novalidate>
                                @csrf
                                <input type="hidden" name="sessionId" value="{{ $sessionId }}">
                                
                                <div class="mb-4">
                                    <label for="participantName" class="form-label">Your Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-user"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                        </span>
                                        <input type="text" class="form-control form-control-lg @error('participantName') is-invalid @enderror" 
                                               id="participantName" name="participantName" placeholder="Enter your name" 
                                               value="{{ old('participantName') }}" required>
                                        @error('participantName')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                    <small class="text-muted">This name will be visible to other participants</small>
                                </div>
                                
                                <div class="d-grid gap-2 mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <span class="me-2">Join Game</span>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                    </button>
                                </div>
                            </form>
                        </div>
                        <div class="card-footer bg-light text-center py-3">
                            <p class="mb-0 text-muted">Make sure you have the correct session ID from your host</p>
                        </div>
                    </div>
                </div>
            </div>
            <!--End::Join Quiz Card -->

        </div>
    </div>
    <!-- End::app-content -->
@endsection

@push('styles')
<style>
    .bg-gradient-primary {
        background: linear-gradient(135deg, #3f80ea 0%, #1e3a8a 100%);
    }
    .form-control-lg {
        padding: 0.75rem 1rem;
    }
    .card {
        border-radius: 0.75rem;
        overflow: hidden;
    }
    .input-group-text {
        border-right: none;
    }
    .form-control {
        border-left: none;
    }
    .form-control:focus {
        box-shadow: none;
        border-color: #dee2e6;
    }
</style>
@endpush

@push('scripts')
<script>
    // Example form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script>
@endpush