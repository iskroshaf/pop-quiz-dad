@extends('layouts.main')

@php
    use Carbon\Carbon;
@endphp

@section('content')
    <!-- Start::app-content -->
    <div class="main-content app-content">
        <div class="container-fluid">

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row align-items-center justify-content-between my-4">
                <div class="mb-3 mb-md-0">
                    <h1 class="page-title fw-semibold fs-3 mb-2">Welcome back, {{ session('api_user.username') }}!</h1>
                    <p class="text-muted mb-0">Quiz Game Session</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="{{ route('user-home') }}" class="text-decoration-none">
                                <i class="bi bi-arrow-left me-1"></i>Back
                            </a>
                        </li>
                    </ol>
                </nav>
            </div>
            <!-- Page Header Close -->

            <!-- Main Content -->
            <div class="row g-4">
                {{-- Participants Sidebar --}}
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-gradient-primary text-white p-3">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-people-fill me-2 fs-5"></i>
                                <h6 class="mb-0">Participants</h6>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            @if (empty($allResults))
                                <div class="text-center p-4 text-muted">
                                    <i class="bi bi-info-circle fs-4"></i>
                                    <p class="mb-0">No participants yet</p>
                                </div>
                            @else
                                <div class="list-group list-group-flush">
                                    @foreach ($allResults as $r)
                                        <div class="list-group-item list-group-item-action 
                                            {{ $r['participantName'] === $me ? 'active' : '' }}">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-3">
                                                        <span class="badge bg-white text-dark rounded-circle p-2">
                                                            {{ $loop->iteration }}
                                                        </span>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0">{{ $r['participantName'] }}</h6>
                                                        <small class="text-muted">
                                                            Progress: {{ $r['progress'] }}/{{ $r['progress'] }}
                                                        </small>
                                                    </div>
                                                </div>
                                                <div class="text-end">
                                                    <span class="badge bg-success rounded-pill">
                                                        {{ $r['correctCount'] }} ✔️
                                                    </span>
                                                    <div class="mt-1">
                                                        <small class="{{ $r['participantName'] === $me ? 'text-white' : 'text-muted' }}">
                                                            {{ number_format($r['accuracy'] * 100, 0) }}% accuracy
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>
                            @endif
                        </div>
                    </div>
                </div>

                {{-- Main Quiz Content --}}
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            @if (array_key_exists('result', $question))
                                {{-- Game Over Screen --}}
                                <div class="text-center py-4">
                                    <div class="mb-4">
                                        <i class="bi bi-trophy-fill text-warning fs-1"></i>
                                        <h3 class="mt-3">Game Over!</h3>
                                    </div>
                                    
                                    @if ($myResult)
                                        <div class="card bg-gradient-primary text-white mb-4 border-0 overflow-hidden">
                                            <div class="card-body p-4 position-relative">
                                                <div class="position-absolute top-0 end-0 m-3">
                                                    <span class="badge bg-white text-primary rounded-pill fs-6">
                                                        #{{ $myResult['ranking'] }}
                                                    </span>
                                                </div>
                                                <h5 class="card-title">Your Results</h5>
                                                <div class="d-flex justify-content-between mt-3">
                                                    <div>
                                                        <h6 class="mb-1">Correct Answers</h6>
                                                        <p class="fs-3 mb-0">{{ $myResult['correctCount'] }}</p>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">Time</h6>
                                                        <p class="fs-3 mb-0">{{ $myResult['time'] }}s</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    @endif

                                    <div class="alert alert-success" role="alert">
                                        <h4 class="alert-heading">Well done!</h4>
                                        <p>{{ $question['result'] }}</p>
                                    </div>
                                </div>
                            @else
                                {{-- Active Question --}}
                                <div class="d-flex align-items-center mb-3">
                                    <span class="badge bg-primary rounded-pill me-2">
                                        Question {{ $question['questionNo'] }}
                                    </span>
                                    <small class="text-muted">Select the correct answer</small>
                                </div>
                                
                                <h4 class="mb-4">{{ $question['question'] }}</h4>
                                
                                <form action="{{ route('submit-answer', ['sessionId' => $sessionId]) }}" method="POST">
                                    @csrf
                                    <input type="hidden" name="gametaskId" value="{{ $question['id'] }}">

                                    <div class="list-group mb-4">
                                        @foreach (['A', 'B', 'C', 'D'] as $opt)
                                            @php $txt = $question['option'.$opt]; @endphp
                                            <label class="list-group-item list-group-item-action rounded mb-2 p-3">
                                                <div class="form-check d-flex align-items-center">
                                                    <input class="form-check-input flex-shrink-0 me-3" 
                                                           type="radio" name="selectedAnswer" 
                                                           id="opt{{ $opt }}" value="{{ $txt }}" required>
                                                    <span class="form-check-label flex-grow-1">
                                                        {{ $txt }}
                                                    </span>
                                                </div>
                                            </label>
                                        @endforeach
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-lg w-100 py-3">
                                        <i class="bi bi-send-fill me-2"></i>Submit Answer
                                    </button>
                                </form>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End::app-content -->
@endsection

@push('styles')
<style>
    .bg-gradient-primary {
        background: linear-gradient(135deg, #3f80ea 0%, #1e3a8a 100%);
    }
    .card {
        border-radius: 0.75rem;
        overflow: hidden;
    }
    .list-group-item.active {
        background-color: #3f80ea;
        border-color: #3f80ea;
    }
    .form-check-input {
        width: 1.25em;
        height: 1.25em;
    }
    .list-group-item-action:hover {
        background-color: #f8f9fa;
    }
    .list-group-item-action.active:hover {
        background-color: #3f80ea;
    }
</style>
@endpush