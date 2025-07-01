<?php

namespace App\Http\Controllers;

use Exception;
use Throwable;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

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

    public function indexUserHome(Request $request)
    {
        // 1) Check we have an API token in session
        if (! $request->session()->has('api_token')) {
            abort(401, 'Unauthorized');
        }

        // 2) If we get here, the user is “logged in”
        return view('user.home', [
            'title' => 'User Home'
        ]);
    }

    // public function authentication(Request $request)
    // {
    //     $validated = $request->validate([
    //         'username' => 'required|string',
    //         'password' => 'required|string',
    //     ]);

    //     $now = now()->toIso8601String();
    //     $userDto = [
    //         'id'             => 0,
    //         'username'       => $validated['username'],
    //         'password'       => $validated['password'],
    //         'email'          => '',
    //         'rememberToken'  => '',
    //         'tokenExpiredAt' => $now,
    //         'createdAt'      => $now,
    //         'deletedAt'      => $now,
    //         'games'          => [],
    //     ];

    //     $loginRes = Http::withHeaders([
    //         'Accept'       => 'application/json',
    //         'Content-Type' => 'application/json',
    //     ])
    //         ->withoutVerifying() // only for localhost self-signed certs
    //         ->withBody(json_encode($userDto), 'application/json')
    //         ->post(env('SYSTEM_DEFAULT_URL') . '/api/auth/login');

    //     if (! $loginRes->successful()) {
    //         $errors = $this->parseApiErrors($loginRes);
    //         return back()
    //             ->withInput()
    //             ->with('error_list', $errors ?: null)
    //             ->with('error', $errors ? null : 'Login failed. Please check your credentials.');
    //     }

    //     $loginJson = $loginRes->json();
    //     $token = $loginJson['token'] ?? $loginJson['rememberToken'] ?? null;

    //     if (! $token) {
    //         return back()->withInput()->with('error', 'No authentication token returned.');
    //     }

    //     session([
    //         'api_token' => $token,
    //         'api_user'  => $loginJson,    
    //     ]);

    //     $valRes = Http::withHeaders([
    //         'Accept' => 'application/json',
    //         'token'  => $token,
    //     ])
    //         ->withoutVerifying()
    //         ->get(env('SYSTEM_DEFAULT_URL') . '/api/auth/validate');

    //     if (! $valRes->successful()) {
    //         session()->forget('api_token');
    //         $errors = $this->parseApiErrors($valRes);
    //         return back()
    //             ->withInput()
    //             ->with('error_list', $errors ?: null)
    //             ->with('error', $errors ? null : 'Token validation failed.');
    //     }

    //     return redirect()->route('user-home')
    //         ->with('success', 'Logged in successfully!');
    // }

    public function authentication(Request $request)
    {
        // 1) Validate form inputs
        $validated = $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        // 2) Build the User DTO for login
        $now = now()->toIso8601String();
        $userDto = [
            'id'             => 0,
            'username'       => $validated['username'],
            'password'       => $validated['password'],
            'email'          => '',
            'rememberToken'  => '',
            'tokenExpiredAt' => $now,
            'createdAt'      => $now,
            'deletedAt'      => $now,
            'games'          => [],
        ];

        // 3) Call /api/auth/login
        $loginRes = Http::withHeaders([
            'Accept'       => 'application/json',
            'Content-Type' => 'application/json',
        ])
            ->withoutVerifying()
            ->withBody(json_encode($userDto), 'application/json')
            ->post(env('SYSTEM_DEFAULT_URL') . '/api/auth/login');

        if (! $loginRes->successful()) {
            $errors = $this->parseApiErrors($loginRes);
            return back()
                ->withInput()
                ->with('error_list', $errors ?: null)
                ->with('error', $errors ? null : 'Login failed. Please check your credentials.');
        }

        // 4) Grab token
        $loginJson = $loginRes->json();
        $token     = $loginJson['token'] ?? null;

        if (! $token) {
            return back()->withInput()->with('error', 'Authentication token not returned.');
        }

        // 5) Store token in session
        session(['api_token' => $token]);

        // 6) Call /api/auth/validate to get the user object
        $valRes = Http::withHeaders([
            'Accept' => 'application/json',
            'token'  => $token,
        ])
            ->withoutVerifying()
            ->get(env('SYSTEM_DEFAULT_URL') . '/api/auth/validate');

        if (! $valRes->successful()) {
            // validation failed—clear token
            session()->forget('api_token');
            $errors = $this->parseApiErrors($valRes);
            return back()
                ->withInput()
                ->with('error_list', $errors ?: null)
                ->with('error', $errors ? null : 'Session validation failed.');
        }

        // 7) Pull the user object from the validate response
        $user = $valRes->json();
        //    If your API nests the user under some key, adjust:
        //    $user = $user['data'] ?? $user;

        // 8) Store the user in session
        session(['api_user' => $user]);

        // 9) Redirect to protected home
        return redirect()->route('user-home')
            ->with('success', 'Logged in successfully!');
    }


    public function userLogout()
    {
        session()->forget('api_token');
        return redirect()->route('signin-page')
            ->with('success', 'Logged out successfully!');
    }

    protected function parseApiErrors($response): array
    {
        try {
            $json = $response->json();
            if (! empty($json['errors']) && is_array($json['errors'])) {
                return collect($json['errors'])->flatten()->toArray();
            }
            if (isset($json['title'])) {
                return [$json['title']];
            }
        } catch (Throwable $e) {
            // ignore parse errors
        }
        return [];
    }

    // SIGN UP PROCESS - FUNCTION - OK
    public function signUpProcess(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|string|max:255',
            'email'    => 'required|email|max:255',
            'password' => 'required|string|min:6',
        ]);

        $now = now()->toIso8601String();
        $userData = [
            "id"              => 0,
            "username"        => $validated['username'],
            "password"        => $validated['password'],
            "email"           => $validated['email'],
            "rememberToken"   => Str::random(40),
            "tokenExpiredAt"  => $now,
            "createdAt"       => $now,
            "deletedAt"       => null,
            "games"           => []
        ];

        $response = Http::withHeaders([
            'Accept'       => 'application/json',
            'Content-Type' => 'application/json',
        ])
            ->withoutVerifying()
            ->withBody(json_encode($userData), 'application/json')
            ->post(env('SYSTEM_DEFAULT_URL') . '/api/auth/register');

        if ($response->successful()) {
            return redirect()
                ->route('signin-page')
                ->with('success', 'Registration successful! Please sign in.');
        } else {
            $errorMessage = 'Registration failed.';
            $errorList    = [];

            try {
                $json = $response->json();

                if (isset($json['title'])) {
                    $errorMessage = $json['title'];
                }

                if (!empty($json['errors']) && is_array($json['errors'])) {
                    $errorList = collect($json['errors'])->flatten()->toArray();
                }
            } catch (Throwable $e) {
                logger()->error('API error parsing failed', [
                    'status' => $response->status(),
                    'body'   => $response->body(),
                ]);
            }
            return back()
                ->withInput()
                ->with([
                    'error_list' => $errorList,
                    'error'      => $errorList ? null : $errorMessage,
                ]);
        }
    }
}
