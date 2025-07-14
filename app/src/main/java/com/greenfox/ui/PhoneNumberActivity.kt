package com.greenfox.ui

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.greenfox.databinding.ActivityPhoneNumberBinding
import com.greenfox.model.OtpRequest
import com.greenfox.network.RetrofitClient
import kotlinx.coroutines.launch

class PhoneNumberActivity : AppCompatActivity() {

    private lateinit var binding: ActivityPhoneNumberBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPhoneNumberBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnContinue.setOnClickListener {
            val phone = binding.editPhone.text.toString().trim()

            if (phone.isEmpty()) {
                binding.editPhone.error = "Enter phone number"
                return@setOnClickListener
            }

            val api = RetrofitClient.instance.create(com.greenfox.network.AuthApi::class.java)

            lifecycleScope.launch {
                try {
                    val response = api.requestOtp(OtpRequest(phoneNumber = phone, role = "CLIENT"))
                    if (response.isSuccessful) {
                        val intent = Intent(this@PhoneNumberActivity, OtpVerificationActivity::class.java)
                        intent.putExtra("phone_number", phone)
                        startActivity(intent)
                    } else {
                        Toast.makeText(this@PhoneNumberActivity, "Server error: ${response.code()}", Toast.LENGTH_SHORT).show()
                    }
                } catch (e: Exception) {
                    Toast.makeText(this@PhoneNumberActivity, "Connection failed", Toast.LENGTH_SHORT).show()
                    e.printStackTrace()
                }
            }
        }
    }
}
