package com.greenfox.ui

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.greenfox.databinding.ActivityRoleSelectionBinding
import com.greenfox.utils.PreferenceHelper

class RoleSelectionActivity : AppCompatActivity() {

    private lateinit var binding: ActivityRoleSelectionBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRoleSelectionBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupListeners()
    }

    private fun setupListeners() {
        binding.btnClient.setOnClickListener {
            PreferenceHelper.setRole(this, "CLIENT")
            navigateToPhoneInput()
        }

        binding.btnPartner.setOnClickListener {
            PreferenceHelper.setRole(this, "PARTNER")
            navigateToPhoneInput()
        }
    }

    private fun navigateToPhoneInput() {
        startActivity(Intent(this, PhoneNumberActivity::class.java))
        finish()
    }
}
