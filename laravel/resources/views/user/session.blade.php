@extends('layouts.main')

@php

    use Carbon\Carbon;

@endphp
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
                            <li class="breadcrumb-item">
                                 <a href="{{ route('user-home') }}" class="text-decoration-none">Back</a>
                            </li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- Page Header Close -->

            <!-- Start::Crate Quiz Form -->
            <div class="row">
                {{-- Sidebar kiri: All Results --}}
                <div class="col-lg-4 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white">
                            <h6 class="mb-0">All Participants</h6>
                        </div>
                        <ul class="list-group list-group-flush">
                            @if (empty($allResults))
                                <li class="list-group-item text-center text-muted">
                                    Belum ada hasil.
                                </li>
                            @else
                                @foreach ($allResults as $r)
                                    <li
                                        class="list-group-item d-flex justify-content-between align-items-center
                    {{ $r['participantName'] === $me ? 'list-group-item-primary' : '' }}">
                                        <div>
                                            <strong>{{ $r['participantName'] }}</strong><br>
                                            <small>Progress: {{ $r['progress'] }}/{{ $r['progress'] }}</small>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge bg-light text-dark">
                                                ✔️ {{ $r['correctCount'] }}
                                            </span><br>
                                            <small>{{ number_format($r['accuracy'] * 100, 0) }}%</small>
                                        </div>
                                    </li>
                                @endforeach
                            @endif
                        </ul>
                    </div>
                </div>

                {{-- Konten utama: soal atau hasil akhir --}}
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-body">

                            @if (array_key_exists('result', $question))
                                {{-- Game selesai: tampilkan hasil personal & pesan akhir --}}
                                <h5 class="card-title mb-3">🔔 Game Over!</h5>

                                @if ($myResult)
                                    <div
                                        class="mb-4 p-3 border rounded {{ $myResult['participantName'] === $me ? 'bg-primary text-white' : '' }}">
                                        <h6>Your Result</h6>
                                        <p class="mb-1"><strong>Ranking:</strong> {{ $myResult['ranking'] }}</p>
                                        <p class="mb-1"><strong>Correct:</strong> {{ $myResult['correctCount'] }}</p>
                                        <p class="mb-0"><strong>Time:</strong> {{ $myResult['time'] }}s</p>
                                    </div>
                                @endif

                                <p class="fs-5">{{ $question['result'] }}</p>
                            @else
                                {{-- Masih ada soal: tampilkan form seperti biasa --}}
                                <h5 class="card-title mb-3">Question {{ $question['questionNo'] }}</h5>
                                <p class="fs-5">{{ $question['question'] }}</p>

                                <form action="{{ route('submit-answer', ['sessionId' => $sessionId]) }}" method="POST">
                                    @csrf
                                    <input type="hidden" name="gametaskId" value="{{ $question['id'] }}">

                                    @foreach (['A', 'B', 'C', 'D'] as $opt)
                                        @php $txt = $question['option'.$opt]; @endphp
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="radio" name="selectedAnswer"
                                                id="opt{{ $opt }}" value="{{ $txt }}" required>
                                            <label class="form-check-label" for="opt{{ $opt }}">
                                                {{ $txt }}
                                            </label>
                                        </div>
                                    @endforeach

                                    <button type="submit" class="btn btn-success mt-4 w-100">
                                        Submit Answer
                                    </button>
                                </form>
                            @endif

                        </div>
                    </div>
                </div>
                <!--End::Crate Quiz Form -->

            </div>
        </div>
        <!-- End::app-content -->
    @endsection
