package com.mycompany.plugins.example

import android.util.Log

class CapacitorKotlin {

    fun echo(value: String?): String? {
        Log.i("Echo", value ?: "null")

        return value
    }
}
