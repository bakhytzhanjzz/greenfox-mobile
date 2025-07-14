package com.greenfox.model

data class OtpVerifyRequest(
    val phoneNumber: String,
    val code: String
)
