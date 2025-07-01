<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;


Route::get('/', function () {
    return redirect()->route('signin-page');});

Route::get('/signin', [AuthController::class, 'indexSignIn'])->name('signin-page');
Route::get('/signup', [AuthController::class, 'indexSignUp'])->name('signup-page');

Route::post('/authentication', [AuthController::class, 'authentication'])->name('auth-user');
Route::post('/signup-process', [AuthController::class, 'signUpProcess'])->name('signup-user');

Route::get('/home', [AuthController::class, 'indexUserHome'])->name('user-home');
Route::get('/user-logout', [AuthController::class, 'userLogout'])->name('user-logout');





