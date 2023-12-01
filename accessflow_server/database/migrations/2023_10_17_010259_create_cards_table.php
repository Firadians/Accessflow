<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cards', function (Blueprint $table) {
            $table->bigIncrements('id')->change();
            $table->String('owner');
            $table->integer('card_status')->nullable();
            $table->String('card_credential')->nullable();
            $table->String('card_type')->nullable();
            $table->String('card_sub_type')->nullable();
            $table->boolean('checklist_status')->nullable();
            $table->timestamp('create_date')->nullable();
            $table->String('ktp_number')->nullable();
            $table->text('photo')->nullable();
            $table->String('reason')->nullable();
            $table->String('name')->nullable();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cards');
    }
};
