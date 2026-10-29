package com.example.myapplication.ui



import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.myapplication.data.local.AppDatabase
import com.example.myapplication.data.repository.PsicologoRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class LoginUiState(
    val usuario: String = "",
    val contrasena: String = "",
    val error: String? = null,
    val cargando: Boolean = false,
    val loginExitoso: Boolean = false
)

class LoginViewModel(application: Application) : AndroidViewModel(application) {

    private val repositorio = PsicologoRepository(
        AppDatabase.obtenerBaseDeDatos(application).psicologoDao()
    )

    private val _estado = MutableStateFlow(LoginUiState())
    val estado: StateFlow<LoginUiState> = _estado.asStateFlow()

    init {
        viewModelScope.launch { repositorio.crearPsicologoDemoSiNoHay() }
    }

    fun onUsuarioCambia(valor: String) {
        _estado.update { it.copy(usuario = valor, error = null) }
    }

    fun onContrasenaCambia(valor: String) {
        _estado.update { it.copy(contrasena = valor, error = null) }
    }

    fun iniciarSesion() {
        val actual = _estado.value
        if (actual.usuario.isBlank() || actual.contrasena.isBlank()) {
            _estado.update { it.copy(error = "Ingresa usuario y contraseña") }
            return
        }
        viewModelScope.launch {
            _estado.update { it.copy(cargando = true, error = null) }
            val ok = repositorio.iniciarSesion(actual.usuario, actual.contrasena)
            _estado.update {
                it.copy(
                    cargando = false,
                    loginExitoso = ok,
                    error = if (ok) null else "Usuario o contraseña incorrectos"
                )
            }
        }
    }

    fun consumirLoginExitoso() {
        _estado.update { it.copy(loginExitoso = false) }
    }
}