package com.greenfox.ui

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.greenfox.databinding.ActivityOtpVerificationBinding
import com.greenfox.utils.PreferenceHelper

class OtpVerificationActivity : AppCompatActivity() {

    private lateinit var binding: ActivityOtpVerificationBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityOtpVerificationBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val phoneNumber = intent.getStringExtra("phone_number")

        binding.btnVerify.setOnClickListener {
            val code = binding.editOtp.text.toString().trim()

            // 🔐 Mock verification logic for now
            if (code == "123456") {
                PreferenceHelper.setToken(this, "mock-jwt-token")
                startActivity(Intent(this, MainActivity::class.java))
                finishAffinity() // Prevent back navigation
            } else {
                binding.editOtp.error = "Invalid code"
            }
        }
    }
}
