<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        DB::table('admins')->where('id', 1)->update([
            'username' => 'admin',
            'email' => 'admin@site.com',
            'password' => Hash::make('12345678'),
            'updated_at' => now(),
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Não reverter por segurança
    }
};
