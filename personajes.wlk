class Personaje {
    const property fuerza
    const inteligencia
    var rol
    method rol(nuevoRol) {rol = nuevoRol}

    method potencialOfensivo() = fuerza * 10 + rol.potencialOfensivoExtra()

    method esGroso() = self.esInteligente() or rol.esGroso(self)

    method esInteligente()
}

class Humano inherits Personaje {
    override method esInteligente() = inteligencia > 50
}

class Orco inherits Personaje {
    override method potencialOfensivo() = if(rol.toString() == brujo.toString()) super() * 1.1 else super()
    override method esInteligente() = false
}


object guerrero {
    method potencialOfensivoExtra() = 100
    method esGroso(unPersonaje) = unPersonaje.fuerza() > 50
}

class Cazador {
    const mascota

    method potencialOfensivoExtra() = mascota.potencialOfensivoExtra()
    method esGroso(unPersonaje) = mascota.esLongeva()
}

object brujo {
    method potencialOfensivoExtra() = 0
    method esGroso(unPersonaje) = true
}

class Mascota {
    var edad
    const fuerza
    const tieneGarras
    method potencialOfensivoExtra() = if(tieneGarras) fuerza * 2 else fuerza

    method esLongeva() = edad > 10
    method cumpleAños() {edad += 1}
}

object mascotant{
    method potencialOfensivoExtra() = 0
}

class Localidad {
    var ejercito
    const habitantes
    method cantHabitantes() = habitantes.size()
    method añadirALaCiudad(unPersonaje)

    method capacidadDefensivo() = ejercito.poderOfensivo()

    method serOcupada(unEjercito)
}

class Ciudad inherits Localidad {
    
    override method capacidadDefensivo() = super() + 300
    override method serOcupada(unEjercito) {ejercito = unEjercito}
}

class Aldea inherits Localidad {
    const maxPoblacion

    override method serOcupada(unEjercito) {
        if(maxPoblacion < unEjercito.tamaño()) {
            ejercito = new Ejercito(soldados = unEjercito.ejercitoMasFuerte())
            unEjercito.quitarLosMasFuertes()
        }
    }
    
    method initialize() {
        if(maxPoblacion < 10) {
            self.error("Deben haber al menos 10 habitantes")
        }
    }
}

class Ejercito {
    const soldados
    method poderOfensivo() = soldados.sum{x=>x.poderOfensivo()}
    method invadir(unaLocalidad) {
        if(self.puedeInvadir(unaLocalidad)) {
            unaLocalidad.serOcupada(self)
        }
    }
    method puedeInvadir(unaLocalidad) = self.poderOfensivo() > unaLocalidad.poderDefensivo()

    method tamaño() = soldados.size()

    method ejercitoMasFuerte() = self.ordenadosPorPoder().take(10)
    method ordenadosPorPoder() = soldados.sortBy{a,b=>a.potencialOfensivo() > b.potencialOfensivo()}
    method quitarLosMasFuertes() {soldados.removeAll(self.ejercitoMasFuerte())}

    method initialize() {
        if(self.tamaño() <= 10) {
            self.error("Un ejército debe estar conformado por al menos 11 integrantes")
        }
    }
}