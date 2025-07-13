package com.greenfox.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.greenfox.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Show token just for mock
        val token = com.greenfox.utils.PreferenceHelper.getToken(this)
        binding.textWelcome.text = "Welcome to GreenFox!\nToken: $token"
    }
}
