package br.com.keyboard_utils

import android.annotation.TargetApi
import android.app.Activity
import android.graphics.Point
import android.graphics.Rect
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.CountDownTimer
import android.util.DisplayMetrics
import android.view.Display
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.PopupWindow

/**
 * Created by Wilson Martins on 2019-10-25.
 */

class KeyboardManager(private val activity: Activity) : PopupWindow(activity) {
    // View utilizada para calcular a altura do teclado
    private val tecladoView: View

    // View pai(corresponde à toda tela.
    private val parentView: View

    // Ação disparada quando o teclado estiver aberto
    private var acaoTecladoAberto: (altura: Int) -> Unit? = {}

    // Ação disparada quando o teclado estiver aberto
    private var acaoTecladoFechado: () -> Unit? = {}

    private var alturas = arrayListOf<Int>()

    private var timer: CountDownTimer? = null

    private var tecladoAberto: Boolean = false

    private var ultimaAltura = 0

    init {
        val inflator = activity.getSystemService(Activity.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        this.tecladoView = inflator.inflate(R.layout.teclado_popup, null, false)
        contentView = tecladoView

        softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE or WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE
        inputMethodMode = PopupWindow.INPUT_METHOD_NEEDED

        parentView = activity.findViewById(android.R.id.content)

        width = 0
        height = WindowManager.LayoutParams.MATCH_PARENT

        timer = object : CountDownTimer(150, 1) {
            override fun onFinish() {
                alturas.max()?.let {
                    if (it > 0 && ultimaAltura != it) {
                        acaoTecladoAberto(it)
                        ultimaAltura = -1
                    } else if (it == 0) {
                        acaoTecladoFechado()
                    }
                    tecladoAberto = false
                    timer?.cancel()
                    alturas.clear()
                    ultimaAltura = it
                }
            }

            override fun onTick(millisUntilFinished: Long) {
                val alturaTecladoCalculada = calcularAlturaTeclado()
                alturas.add(alturaTecladoCalculada)
            }
        }

        tecladoView?.viewTreeObserver?.addOnGlobalLayoutListener {
            if (!tecladoAberto || alturas.size == 0 && tecladoAberto) {
                tecladoAberto = true
                timer?.start()
            }
        }
    }

    fun start() {
        if (!isShowing && parentView.windowToken != null) {
            setBackgroundDrawable(ColorDrawable(0))
            showAtLocation(parentView, Gravity.NO_GRAVITY, 0, 0)
        }
    }

    // Calcula a altura do teclado baseado na altura real do dispositivo
    private fun calcularAlturaTeclado(): Int {
        val dimensoesTeclado = Rect()
        tecladoView.getWindowVisibleDisplayFrame(dimensoesTeclado)
        val alturaRealDispositivo = calcularAlturaRealDispositivo()
        val alturaBotoesFisicos = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            calcularAlturaBotoes()
        } else {
            0
        }

        return (alturaRealDispositivo - dimensoesTeclado.bottom) - alturaBotoesFisicos
    }

    private fun calcularAlturaRealDispositivo(): Int {
        val dimensoesReais = Point()
        Display::class.java.getMethod("getRealSize", Point::class.java).invoke(activity.windowManager.defaultDisplay, dimensoesReais)
        return dimensoesReais.y
    }

    // Calcula a altura do frame onde estão aos botões de "Home" e "Voltar"
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun calcularAlturaBotoes(): Int {
        val metrics = DisplayMetrics()
        activity.windowManager.defaultDisplay.getMetrics(metrics)
        val usableHeight = metrics.heightPixels
        activity.windowManager.defaultDisplay.getRealMetrics(metrics)

        return metrics.heightPixels - usableHeight
    }

    // Callback utilizado para alterar a ação quando o teclado estiver aberto
    fun tecladoAberto(acao: (altura: Int) -> Unit) {
        acaoTecladoAberto = acao
    }

    // Callback utilizado para alterar a ação quando o teclado estiver fechado
    fun tecladoFechado(acao: () -> Unit) {
        acaoTecladoFechado = acao
    }
}