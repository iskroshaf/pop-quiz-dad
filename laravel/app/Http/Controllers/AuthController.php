<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function indexSignIn()
    {
        try {
            return view('auth.signin', [
                'title' => 'Sign In'
            ]);
        } catch (Exception $e) {
            abort(500, $e->getMessage());
        }
    }

    public function indexSignUp()
    {
        try {
            return view('auth.signup', [
                'title' => 'Sign Up'
            ]);
        } catch (Exception $e) {
            abort(500, $e->getMessage());
        }
    }

    public function authentication(Request $request)
    {
        try {
            dd($request->all());
        } catch (Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }

    public function signUpProcess(Request $request)
    {
        try {
            dd($request->all());
        } catch (Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }
}
