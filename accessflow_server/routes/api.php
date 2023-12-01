<?php

use App\Http\Controllers\Api\CardController;
use App\Http\Controllers\Api\StudentController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

//LOAD AUTHENTICATED USER
Route::get('users', [UserController ::class, 'getData']);
//LOGIN
Route::post('users', [UserController ::class, 'authenticate']);
//GET CARD DATA OF AUTHENTICATED USER
Route::get('cards', [CardController ::class, 'readCardData']);
//INSERT CARD DATA OF AUTHENTICATED USER
Route::post('cards', [CardController ::class, 'insertCardData']);
//DELETE CARD DATA OF AUTHENTICATED USER
Route::delete('cards', [CardController ::class, 'deleteCardData']);