package com.greenfox.ui

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.greenfox.databinding.ActivityOtpVerificationBinding
import com.greenfox.model.OtpVerifyRequest
import com.greenfox.network.RetrofitClient
import com.greenfox.utils.PreferenceHelper
import kotlinx.coroutines.launch

class OtpVerificationActivity : AppCompatActivity() {

    private lateinit var binding: ActivityOtpVerificationBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityOtpVerificationBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val phoneNumber = intent.getStringExtra("phone_number") ?: ""

        binding.btnVerify.setOnClickListener {
            val code = binding.editOtp.text.toString().trim()

            if (code.isEmpty()) {
                binding.editOtp.error = "Enter the code"
                return@setOnClickListener
            }

            val api = RetrofitClient.instance.create(com.greenfox.network.AuthApi::class.java)

            lifecycleScope.launch {
                try {
                    val response = api.verifyOtp(OtpVerifyRequest(phoneNumber, code))
                    if (response.isSuccessful) {
                        val auth = response.body()
                        PreferenceHelper.setToken(this@OtpVerificationActivity, auth?.token ?: "")
                        startActivity(Intent(this@OtpVerificationActivity, MainActivity::class.java))
                        finishAffinity()
                    } else {
                        binding.editOtp.error = "Invalid code"
                    }
                } catch (e: Exception) {
                    Toast.makeText(this@OtpVerificationActivity, "Network error", Toast.LENGTH_SHORT).show()
                    e.printStackTrace()
                }
            }
        }
    }
}
