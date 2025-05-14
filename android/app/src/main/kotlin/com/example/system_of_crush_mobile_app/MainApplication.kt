package com.example.system_of_crush_mobile_app

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("025faeb8-1c99-412c-9efe-3d3f3909f229") 
        MapKitFactory.setLocale("ru_RU")
    }
}
