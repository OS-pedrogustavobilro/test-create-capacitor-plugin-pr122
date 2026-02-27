package com.mycompany.plugins.example

import com.getcapacitor.Logger

class CapacitorJavaToKotlin {
    fun echo(value: String?): String? {
        Logger.info("Echo", value)
        return value
    }
}
