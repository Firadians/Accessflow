<?php

namespace App\Http\Controllers\Api;

use App\Models\Card; // Import the Card model
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CardController extends Controller
{

    public function readCardData(Request $request)
    {
        $header = $request->header('Authorization');
        $validation = User::where('remember_token', $header)->first();

        if ($validation) {
            //Mengatur Apakah header menampilkan data exist, draft, atau Histori
            if ($request->Header('rules') == 'load_exist_access_card') {

                $auth = $request->header('owner');
                $cardData = Card::where('owner', $auth)
                    ->where('card_type', 'Access Card')
                    ->where('card_status', 4)
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'cards' => $cardData,
                ];

                return response()->json($responseData, $responseStatus);
            } else if ($request->Header('rules') == 'load_exist_id_card') {
                $auth = $request->header('owner');
                $cardData = Card::where('owner', $auth)
                    ->where('card_type', 'ID Card')
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'data' => $cardData,
                ];

                return response()->json($responseData);
            } else if ($request->Header('rules') == 'load_exist_akses_perumdin') {
                $auth = $request->header('owner');
                $cardData = Card::where('owner', $auth)
                    ->where('card_type', 'Akses Perumdin')
                    ->where('card_status', 4)
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'cards' => $cardData,
                ];

                return response()->json($responseData, $responseStatus);
            } else if ($request->Header('rules') == 'load_draft') {
                $owner = $request->header('owner');
                $cardData = Card::where('owner', $owner)
                    ->where('card_status', 0)
                    ->orderBy('create_date', 'desc')
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'cards' => $cardData,
                ];

                return response()->json($responseData, $responseStatus);
            }
            //
            else if ($request->Header('rules') == 'load_submit') {
                $auth = $request->header('owner');
                $cardData = Card::where('owner', $auth)
                    ->where('card_status', '!=', 0)
                    ->orderBy('create_date', 'desc')
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'cards' => $cardData,
                ];

                return response()->json($responseData, $responseStatus);
            }
            //
            else if ($request->Header('rules') == 'check_user_available') {

                $auth = $request->header('name');
                $owner = $request->header('owner');
                $cardData = Card::where('owner', $owner)
                ->where('name', $auth)
                    ->get();

                if ($cardData->isEmpty()) {
                    $responseStatus = 404;
                    $message = 'No cards found';
                } else {
                    $responseStatus = 200;
                    $message = 'Cards found';
                }

                // Build the response data
                $responseData = [
                    'status' => $responseStatus,
                    'message' => $message,
                    'cards' => $cardData,
                ];

                return response()->json($responseData, $responseStatus);
            }

            $username = $request->header('name');

            // Query the cards table to retrieve data based on the username
            $cardData = Card::where('name', $username)->get();

            if ($cardData->isEmpty()) {
                $responseStatus = 404;
                $message = 'No cards found';
            } else {
                $responseStatus = 200;
                $message = 'Cards found';
            }

            // Build the response data
            $responseData = [
                'status' => $responseStatus,
                'message' => $message,
                'cards' => $cardData,

            ];

            return response()->json($responseData, $responseStatus);
        } else {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized: Missing Authorization header'
            ], 401);
        }
    }



    //WORKED
    public function insertCardData(Request $request)
    {
        $header = $request->header('Authorization');
        $validation = User::where('remember_token', $header)->first();
        // Verify the presence of specific headers
        if ($validation) {
            // Check if the card data already exists based on some identifier (e.g., 'id')
            $isDraft = Card::where('id', $request->input('id'))
            ->where('card_status', 0)
            ->first();

            if ($isDraft) {
                // If the card data exists, use the HTTP PUT method to completely replace it
                $isDraft->update($request->all());

                return response()->json([
                    'status' => 200,
                    'message' => 'Data updated successfully'
                ], 200);
            } else {
                // If the card data doesn't exist, use the HTTP POST method to create a new card
                $validator = Validator::make($request->all(), [
                    'name' => 'string|max:191',
                    'card_status' => 'required|integer|max:191',
                    'card_credential' => 'string|max:191',
                    'card_sub_type' => 'string|max:191',
                    'card_type' => 'string|max:191',
                    'checklist_status' => 'boolean|max:191',
                    'create_date' => 'required|date_format:Y-m-d H:i:s|max:191',
                    'ktp_number' => 'string|max:191',
                    'photo' => 'string',
                    'reason' => 'string|max:191'
                ]);

                if ($validator->fails()) {
                    return response()->json([
                        'status' => 422,
                        'errors' => $validator->messages()
                    ], 422);
                } else {
                    // Create a new Card instance and populate it with the request data
                    $card = new Card();
                    $card->fill($request->all());

                    // Save the card data to the database
                    $card->save();

                    return response()->json([
                        'status' => 200,
                        'message' => 'Data inserted successfully'
                    ], 200);
                }
            }
        }
        return response()->json([
            'status' => 401,
            'message' => 'Unauthorized: Missing Authorization header',
        ], 401);
    }

    public function deleteCardData(Request $request)
    {
        $header = $request->header('Authorization');
        $validation = User::where('remember_token', $header)->first();
        $owner = $request->header('owner');
        $id = $request->header('id');

        if (!$validation) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized: Missing Authorization header',
            ], 401);
        }

        // Find the card with the specified ID and check if it exists
        $card = Card::find($id);

        if (!$card) {
            return response()->json([
                'status' => 404,
                'message' => 'Card not found',
            ], 404);
        }

        // Delete the card
        $card->delete();

        return response()->json([
            'status' => 200,
            'message' => 'Card deleted successfully',
        ], 200);
    }

}
