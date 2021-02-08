package com.DevAsh.RMart

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  private val CHANNEL = "NativeChannel"
  private var paymentResultCallback: Callback? = null
    private var getAccessCallback: Callback? = null

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
       if (call.method == "pay") {
           paymentResultCallback = object : Callback {
               override fun result(resultMap: Map<String, String>) {
                   result.success(resultMap)
               }
           }
           var amount: Int? = call.argument("amount")
           val myIntent = Intent()
           myIntent.putExtra("amount", "$amount")
           myIntent.setClassName("com.DevAsh.rPay", "com.DevAsh.recwallet.rMart.GetAccess")
           startActivityForResult(myIntent, 600)
       } else if (call.method == "getAccess") {
           getAccessCallback = object : Callback {
               override fun result(resultMap: Map<String, String>) {
                   result.success(resultMap)
               }
           }
           val myIntent = Intent()
           myIntent.putExtra("getAccess", true)
           myIntent.setClassName("com.DevAsh.rPay", "com.DevAsh.recwallet.rMart.GetAccess")
           startActivityForResult(myIntent, 500)
       }
    }
  }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 600) {
            if (resultCode == Activity.RESULT_OK) {
                val name = data?.getStringExtra("name")!!
                val email = data?.getStringExtra("email")!!
                var number = data?.getStringExtra("phoneNumber")!!
                val password = data?.getStringExtra("password")!!
                val token = data?.getStringExtra("token")!!
                number = number?.replace("+", "")
                paymentResultCallback?.result(mapOf<String, String>(
                        "message" to "Success",
                        "password" to password,
                        "name" to name,
                        "token" to token,
                        "email" to email,
                        "number" to number
                ))
            } else if (resultCode == Activity.RESULT_CANCELED) {
                paymentResultCallback?.result(mapOf<String, String>(
                        "message" to "Failed"
                ))
            }
        } else if (requestCode == 500) {
            if (resultCode == Activity.RESULT_OK) {
                val name = data?.getStringExtra("name")!!
                val email = data?.getStringExtra("email")!!
                var number = data?.getStringExtra("phoneNumber")!!
                number = number?.replace("+", "")
                getAccessCallback?.result(mapOf<String, String>(
                        "message" to "Success",
                        "name" to name,
                        "email" to email,
                        "number" to number
                ))
            } else if (resultCode == Activity.RESULT_CANCELED) {
                getAccessCallback?.result(mapOf<String, String>(
                        "message" to "Failed"
                ))
            }
        }
    }
}

interface Callback {
    fun result(result: Map<String, String>)
}
