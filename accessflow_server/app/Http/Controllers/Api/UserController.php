<?php

namespace App\Http\Controllers\Api;

use Illuminate\Support\Str;
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function authenticate(Request $request)
    {
        // Validate the incoming request data
        $request->validate([
            'ktp' => 'required',
            'password' => 'required',
        ]);
    
        // Get the input values
        $ktp = $request->input('ktp');
        $password = $request->input('password');
    
        // Perform a database query to check if the user exists
        $user = User::where('ktp', $ktp)->first();
    
        // Check if the user exists and if the provided password matches
        if ($user && $password === $user->password) {
    
            // Generate a new remember_token and update it in the user model
            $newRememberToken = Str::random(60); // Generate a new token
            $user->update(['remember_token' => $newRememberToken]);
    
            $data = [
                'status' => 200,
                'message' => 'Authentication successful',
                'data' => $user
            ];
        } else {
            // Authentication failed
            $data = [
                'status' => 401, // Unauthorized
                'message' => 'Authentication failed',
            ];
        }
    
        return response()->json($data);
    }
    
    public function getData(Request $request)
    {
        $header = $request->header('Authorization');
        $validation = User::where('remember_token', $header)->first();
        // Validate the incoming request data
        if ($validation) {
            $userData = User::where('remember_token', $header)
                ->get();

            if ($userData->isEmpty()) {
                $data = [
                    'status' => 404, // Unauthorized
                    'message' => 'Failed to retrieve data',
                ];
            } else {
                $data = [
                    'status' => 200,
                    'message' => 'Data successfully retrieve',
                    'data' => $userData
                ];
            }

            return response()->json($data);
        }
        else {
            $data = [
                'status' => 404, // Unauthorized
                'message' => 'Failed to retrieve data',
            ];
            return response()->json($data);
        }
    }
}
