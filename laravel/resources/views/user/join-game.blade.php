@extends('layouts.main')

@section('content')
    <!-- Start::app-content -->
    <div class="main-content app-content">
        <div class="container-fluid">

            <!-- Page Header -->
            <div class="d-md-flex d-block align-items-center justify-content-between my-4 page-header-breadcrumb">
                <div>
                    <h1 class="page-title fw-semibold fs-18 mb-1">Welcome back,
                        {{ session('api_user.username') }} !</h1>
                </div>
                <div class="ms-md-1 ms-0">
                    <nav>
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item active" aria-current="page">Create Quiz</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- Page Header Close -->

            <!-- Start::Crate Quiz Form -->
           <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-sm border-0 mt-5">
        <div class="card-header bg-primary text-white p-4">
          <h5 class="mb-0">Join Quiz Game</h5>
        </div>
        <div class="card-body">
          @if(session('error'))
            <div class="alert alert-danger">{{ session('error') }}</div>
          @endif
          <form action="{{ route('join-game') }}" method="POST">
            @csrf
            <input type="hidden" name="sessionId" value="{{ $sessionId }}">
            <div class="form-floating mb-3">
              <input type="text"
                     class="form-control @error('participantName') is-invalid @enderror"
                     id="participantName"
                     name="participantName"
                     placeholder="Your Name"
                     value="{{ old('participantName') }}"
                     required>
              <label for="participantName">Your Name</label>
              @error('participantName')
                <div class="invalid-feedback">{{ $message }}</div>
              @enderror
            </div>
            <button type="submit" class="btn btn-primary w-100">Join Game</button>
          </form>
        </div>
      </div>
    </div>
  </div>
            <!--End::Crate Quiz Form -->

        </div>
    </div>
    <!-- End::app-content -->
@endsection
