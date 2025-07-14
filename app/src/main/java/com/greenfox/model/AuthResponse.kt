package com.greenfox.model

data class AuthResponse(
    val id: Long,
    val fullName: String?,
    val email: String?,
    val phoneNumber: String,
    val profileImageUrl: String?,
    val role: String,
    val verified: Boolean,
    val token: String
)
