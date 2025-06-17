<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return redirect()->route('signin-page');
});

Route::get('/signin', [AuthController::class, 'indexSignIn'])->name('signin-page');
Route::get('/signup', [AuthController::class, 'indexSignUp'])->name('signup-page');
Route::post('/authentication', [AuthController::class, 'authentication'])->name('auth-user');


