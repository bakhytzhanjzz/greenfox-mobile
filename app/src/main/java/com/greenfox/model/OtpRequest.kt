package com.greenfox.model

data class OtpRequest(
    val phoneNumber: String,
    val role: String = "CLIENT" // or "PARTNER"
)
