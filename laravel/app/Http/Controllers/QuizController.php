<?php

namespace App\Http\Controllers;

use Throwable;
use Carbon\Carbon;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Session;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class QuizController extends Controller
{

    // public function createQuiz(Request $request)
    // {
    //     $v = $request->validate([
    //         'quizTitle'       => 'required|string|max:255',
    //         'quizDescription' => 'nullable|string',
    //         'quizStartTime'   => 'required|date',
    //         'quizEndTime'     => 'required|date|after_or_equal:quizStartTime',
    //     ]);

    //     // Build DTO
    //     $dto = [
    //         'id'          => 0,
    //         'userId'      => Session::get('api_user.id', 0),
    //         'title'       => $v['quizTitle'],
    //         'startTime'   => Carbon::parse($v['quizStartTime'])->toIso8601String(),
    //         'endTime'     => Carbon::parse($v['quizEndTime'])->toIso8601String(),
    //         'status'      => true,
    //         'description' => $v['quizDescription'] ?? '',
    //         // these will be filled by the API:
    //         'uniqueId'    => '',
    //         'domainUrl'   => '',
    //         'gameTasks'   => [],
    //         'participants' => [],
    //         'user'        => null,
    //     ];

    //     // Call the .NET API
    //     $res = Http::withHeaders([
    //         'Accept'       => 'application/json',
    //         'Content-Type' => 'application/json',
    //         'token'        => Session::get('api_token'),
    //     ])
    //         ->withoutVerifying()
    //         ->withBody(json_encode($dto), 'application/json')
    //         ->post(env('SYSTEM_DEFAULT_URL') . '/api/Games');

    //     dd($res->body()); // Debugging line, remove in production
    //     if (!$res->successful()) {
    //         $errors = $this->parseApiErrors($res);
    //         return back()
    //             ->withInput()
    //             ->with('error_list', $errors)
    //             ->with('error', $errors ? null : 'Could not create quiz.');
    //     }

    //     // Success → grab uniqueId and redirect
    //     $quiz = $res->json();
    //     $uniqueId = $quiz['uniqueId'];

    //     return redirect()
    //         ->route('show-quiz', ['uniqueId' => $uniqueId])
    //         ->with('quiz_data', $quiz);
    // }

    // public function createQuiz(Request $request)
    // {
    //     // 1) Validate
    //     $v = $request->validate([
    //         'quizTitle'       => 'required|string|max:255',
    //         'quizDescription' => 'nullable|string',
    //         'quizStartTime'   => 'nullable|date',
    //         'quizEndTime'     => 'nullable|date|after_or_equal:quizStartTime',
    //     ]);

    //     // 2) Prep data
    //     $uniqueId  = Str::random(8);
    //     $baseApi   = rtrim(env('SYSTEM_DEFAULT_URL'), '/');
    //     $domainUrl = "{$baseApi}/api/Games/{$uniqueId}";

    //     $user = session('api_user'); // the full User object you saved on login
    //     // dd($user); // Debugging line, remove in production

    //     $dto = [
    //         'id'          => 0,
    //         'userId'      => 0,
    //         'title'       => $v['quizTitle'],
    //         'startTime'   => Carbon::parse($v['quizStartTime'])->toIso8601String(),
    //         'endTime'     => Carbon::parse($v['quizEndTime'])->toIso8601String(),
    //         'status'      => true,
    //         'description' => $v['quizDescription'] ?? '',
    //         'uniqueId'    => $uniqueId,
    //         'domainUrl'   => $domainUrl,  // empty until players join
    //         'user'        => $user,     // include the full user object
    //     ];

    //     // 3) Call Create
    //     $res = Http::withHeaders([
    //         'Accept'       => 'application/json',
    //         'Content-Type' => 'application/json',
    //         'token'        => session('api_token'),
    //     ])
    //         ->withoutVerifying()
    //         ->withBody(json_encode($dto), 'application/json')
    //         ->post("{$baseApi}/api/Games");
    //     dd(session('api_token')); // Debugging line, remove in production

    //     // 4) Errors?
    //     if (! $res->successful()) {
    //         $errors = $this->parseApiErrors($res);
    //         return back()
    //             ->withInput()
    //             ->with('error_list', $errors)
    //             ->with('error',      $errors ? null : 'Could not create quiz.');
    //     }

    //     // 5) Success
    //     $quiz = $res->json(); // full Game object
    //     return redirect()
    //         ->route('show-quiz', ['uniqueId' => $quiz['uniqueId']])
    //         ->with('quiz_data', $quiz);
    // }

    public function createQuiz(Request $request)
    {
        // 1) Laravel‐side validation
        $v = $request->validate([
            'quizTitle'       => 'required|string|max:255',
            'quizDescription' => 'nullable|string',
            'quizStartTime'   => 'required|date',
            'quizEndTime'     => 'required|date|after_or_equal:quizStartTime',
        ]);

        // 2) Static gameTasks array (10 questions)
        $gameTasks = [
            [
                "question" => "What does REST stand for?",
                "optionA"  => "Remote Execution Standard Transfer",
                "optionB"  => "Representational State Transfer",
                "optionC"  => "Reliable Endpoint Secure Transport",
                "optionD"  => "Request Event Session Transfer",
                "answer"   => "Representational State Transfer",
            ],
            [
                "question" => "Which HTTP method is typically used to retrieve data?",
                "optionA"  => "POST",
                "optionB"  => "PUT",
                "optionC"  => "GET",
                "optionD"  => "DELETE",
                "answer"   => "GET",
            ],
            [
                "question" => "Which HTTP status code indicates a successful request?",
                "optionA"  => "200",
                "optionB"  => "400",
                "optionC"  => "404",
                "optionD"  => "500",
                "answer"   => "200",
            ],
            [
                "question" => "What is the correct HTTP method to update a resource?",
                "optionA"  => "GET",
                "optionB"  => "DELETE",
                "optionC"  => "POST",
                "optionD"  => "PUT",
                "answer"   => "PUT",
            ],
            [
                "question" => "Which status code indicates resource not found?",
                "optionA"  => "403",
                "optionB"  => "404",
                "optionC"  => "201",
                "optionD"  => "500",
                "answer"   => "404",
            ],
            [
                "question" => "Which of the following formats is commonly used in REST APIs for data exchange?",
                "optionA"  => "XML",
                "optionB"  => "CSV",
                "optionC"  => "JSON",
                "optionD"  => "HTML",
                "answer"   => "JSON",
            ],
            [
                "question" => "What does the POST method usually do in REST?",
                "optionA"  => "Retrieves a resource",
                "optionB"  => "Deletes a resource",
                "optionC"  => "Updates a resource",
                "optionD"  => "Creates a resource",
                "answer"   => "Creates a resource",
            ],
            [
                "question" => "Which HTTP method is idempotent?",
                "optionA"  => "GET",
                "optionB"  => "PUT",
                "optionC"  => "DELETE",
                "optionD"  => "All of the above",
                "answer"   => "All of the above",
            ],
            [
                "question" => "What status code is returned after creating a resource?",
                "optionA"  => "200",
                "optionB"  => "201",
                "optionC"  => "202",
                "optionD"  => "204",
                "answer"   => "201",
            ],
            [
                "question" => "Which principle is NOT part of REST?",
                "optionA"  => "Stateless interactions",
                "optionB"  => "Client-server architecture",
                "optionC"  => "Multiple layered architecture",
                "optionD"  => "Server-side session tracking",
                "answer"   => "Server-side session tracking",
            ],
        ];

        // 3) Build the payload
        $joinPrefix = rtrim(env('SYSTEM_DEFAULT_URL').'/Games/join', '/');

        $dto = [
            'title'       => $v['quizTitle'],
            'startTime'   => Carbon::parse($v['quizStartTime'])->toIso8601String(),
            'endTime'     => Carbon::parse($v['quizEndTime'])->toIso8601String(),
            'description' => $v['quizDescription'] ?? '',
            'domainUrl'   => rtrim($joinPrefix, '/'),
            'gameTasks'   => $gameTasks,
        ];

        // 4) Call the Create Game API
        $baseApi = rtrim(env('SYSTEM_DEFAULT_URL'), '/');
        $res = Http::withHeaders([
            'Accept'       => 'application/json',
            'Content-Type' => 'application/json',
            'token'        => session('api_token'),
        ])
            ->withoutVerifying()
            ->withBody(json_encode($dto), 'application/json')
            ->post("{$baseApi}/api/Games");

        // 5) Handle errors
        if (! $res->successful()) {
            $errors = $this->parseApiErrors($res);
            return back()
                ->withInput()
                ->with('error_list', $errors)
                ->with('error',      $errors ? null : 'Could not create quiz.');
        }

        // 6) Success: full Game object returned
        $quiz = $res->json();

        // 7) Generate QR code linking to join URL
        $joinUrl = "{$dto['domainUrl']}";
        $png     = QrCode::format('png')->size(200)->generate($joinUrl);
        $qr      = base64_encode($png);

        // 8) Flash quiz + qr to session and redirect to show

        return back()->with('success', 'Quiz created successfully!');
        return redirect()
            ->route('show-quiz')
            ->with([
                'quiz_data' => $quiz,
                'qr_code'   => $qr,
            ]);
    }



    public function showQuiz(Request $request, $uniqueId)
    {
        // Option A: use the flashed data if available
        if ($request->session()->has('quiz_data')) {
            $quiz = $request->session()->get('quiz_data');
        } else {
            // Option B: fetch from API again
            $res = Http::withHeaders([
                'Accept' => 'application/json',
                'token'  => Session::get('api_token'),
            ])
                ->withoutVerifying()
                ->get(env('SYSTEM_DEFAULT_URL') . "/api/Games/{$uniqueId}");

            if (! $res->successful()) {
                abort(404, 'Quiz not found.');
            }
            $quiz = $res->json();
        }

        // Build domain URL & QR
        $domainUrl = rtrim(env('SYSTEM_DEFAULT_URL'), '/') . "/api/Games/{$uniqueId}";
        $png = QrCode::format('png')->size(200)->generate($domainUrl);
        $qr  = base64_encode($png);

        return view('user.show-quiz', compact('quiz', 'domainUrl', 'qr'));
    }

    protected function parseApiErrors($res): array
    {
        try {
            $json = $res->json();
            if (! empty($json['errors'])) {
                return collect($json['errors'])->flatten()->toArray();
            }
            if (isset($json['title'])) {
                return [$json['title']];
            }
        } catch (Throwable $e) {
        }
        return [];
    }
}
