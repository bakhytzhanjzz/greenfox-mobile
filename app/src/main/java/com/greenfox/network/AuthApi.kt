package com.greenfox.network

import com.greenfox.model.*
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface AuthApi {

    @POST("auth/request-otp")
    suspend fun requestOtp(@Body request: OtpRequest): Response<Unit>

    @POST("auth/verify-otp")
    suspend fun verifyOtp(@Body request: OtpVerifyRequest): Response<AuthResponse>
}
