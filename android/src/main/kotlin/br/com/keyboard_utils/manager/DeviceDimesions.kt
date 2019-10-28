package br.com.keyboard_utils.manager

import android.annotation.TargetApi
import android.app.Activity
import android.graphics.Point
import android.graphics.Rect
import android.os.Build
import android.util.DisplayMetrics
import android.view.Display
import android.view.View

/**
 * Created by Wilson Martins on 2019-10-25.
 */

interface DeviceDimesions {
    fun keyboardHeight(): Int

    fun getRealDeviceHeight(): Int

    fun getNavigationBarHeight(): Int
}

class DeviceDimesionsImpl(
    private val activity: Activity,
    private val keyboardView: View
) : DeviceDimesions {
    override fun keyboardHeight(): Int {
        val keyboardRect = Rect()
        keyboardView.getWindowVisibleDisplayFrame(keyboardRect)
        val realHeight = getRealDeviceHeight()
        val phisicalNavigationButton = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            getNavigationBarHeight()
        } else {
            0
        }

        return (realHeight - keyboardRect.bottom) - phisicalNavigationButton
    }

    override fun getRealDeviceHeight(): Int {
        val dimensoesReais = Point()
        Display::class.java.getMethod("getRealSize", Point::class.java).invoke(
                activity.windowManager.defaultDisplay, dimensoesReais)
        return dimensoesReais.y
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    override fun getNavigationBarHeight(): Int {
        val metrics = DisplayMetrics()
        activity.windowManager.defaultDisplay.getMetrics(metrics)
        val usableHeight = metrics.heightPixels
        activity.windowManager.defaultDisplay.getRealMetrics(metrics)

        return metrics.heightPixels - usableHeight
    }
}