package com.greenfox.utils

import android.content.Context
import android.content.SharedPreferences

object PreferenceHelper {

    private const val PREF_NAME = "greenfox_prefs"
    private const val KEY_ROLE = "user_role"
    private const val KEY_JWT = "jwt_token"

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    }

    // Role
    fun setRole(context: Context, role: String) {
        getPrefs(context).edit().putString(KEY_ROLE, role).apply()
    }

    fun getRole(context: Context): String? {
        return getPrefs(context).getString(KEY_ROLE, null)
    }

    // JWT Token
    fun setToken(context: Context, token: String) {
        getPrefs(context).edit().putString(KEY_JWT, token).apply()
    }

    fun getToken(context: Context): String? {
        return getPrefs(context).getString(KEY_JWT, null)
    }

    // Optional: clear all
    fun clearAll(context: Context) {
        getPrefs(context).edit().clear().apply()
    }
}
