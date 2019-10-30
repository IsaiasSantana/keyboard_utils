package br.com.keyboard_utils.utils

import android.app.Activity

/**
 * Created by Wilson Martins on 2019-10-30.
 */
fun Int.toDp(activity: Activity): Int = (this / activity.resources.displayMetrics.density).toInt()