<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\QuizController;


Route::get('/', function () {
    return redirect()->route('signin-page');});

Route::get('/signin', [AuthController::class, 'indexSignIn'])->name('signin-page');
Route::get('/signup', [AuthController::class, 'indexSignUp'])->name('signup-page');

// REGISTER USER
Route::post('/signup-process', [AuthController::class, 'signUpProcess'])->name('signup-user');

// LOGIN & LOGOUT USER
Route::post('/authentication', [AuthController::class, 'authentication'])->name('auth-user');
Route::get('/user-logout', [AuthController::class, 'userLogout'])->name('user-logout');

// USER CREATE QUIZ [INITIALLY HOME]
Route::get('/user-create-quiz', [AuthController::class, 'indexUserHome'])->name('user-home');

//CREATE QUIZ
Route::post('/create-quiz', [QuizController::class, 'createQuiz'])->name('create-quiz');
Route::get('/show-quiz-{uniqueId}', [QuizController::class, 'showQuiz'])->name('show-quiz');






