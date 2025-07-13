package com.greenfox.ui

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.greenfox.databinding.ActivityPhoneNumberBinding

class PhoneNumberActivity : AppCompatActivity() {

    private lateinit var binding: ActivityPhoneNumberBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPhoneNumberBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnContinue.setOnClickListener {
            val phone = binding.editPhone.text.toString().trim()
            // (Later: Add validation)

            val intent = Intent(this, OtpVerificationActivity::class.java)
            intent.putExtra("phone_number", phone)
            startActivity(intent)
        }
    }
}
