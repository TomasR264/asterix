class Persona{
	var fuerza
	var resistencia
	
	method poder() = fuerza * resistencia
	
	method tomarPocion(pocion) = pocion.efecto(self)
	
	method estaFueraDeCombate() = resistencia == 0
	
	method aumentarFuerza(cantFuerza){
		fuerza += cantFuerza
	}
	
	method aumentarResistencia(cantResistencia){
		resistencia += cantResistencia
	}
	
	method volverAlCombate(cantResistencia){
		resistencia = cantResistencia
	}
	
	method resistencia() = resistencia
	
	method disminuirResistencia(cantResistencia){
		resistencia -= cantResistencia
	}
	
	method recibirDanio(cantDanio){
		resistencia -= cantDanio.max(0)
	}
	
	
}


class Pocion{
	var ingredientes = []
	
	
	method efecto(persona) = ingredientes.forEach({unIngrediente => unIngrediente.efectoIngrediente(persona,self)})

    method cantIngredientes() = ingredientes.size()
}

object dulceDeLeche{
	method efectoIngrediente(persona,pocion){
		if(persona.estaFueraDeCombate()){
			persona.volverAlCombate(2)
			persona.aumentarFuerza(10)
		}
		else{
			persona.aumentarFuerza(10)
		}
	}
}

class PuniadoDeHongos{
	var cantHongos
	
	method efectoIngrediente(persona,pocion){
		if(self.hayMasDe5Hongos()){
			persona.aumentarFuerza(cantHongos)
			persona.disminuirResistencia(persona.resistencia() * 0.5)
		}
		else{
			persona.aumentarFuerza(cantHongos)
		}
	}
	method hayMasDe5Hongos() = cantHongos > 5
}

class Grog{
	method efectoIngrediente(persona,pocion){
		persona.aumentarFuerza(pocion.cantIngrendientes())
	}
}

object grogXD inherits Grog{
	override method efectoIngrediente(persona,pocion){
		super(persona,pocion)
		persona.aumentarResitencia(persona.resistencia())
	}
}


class Ejercito{
	var integrantes = []
	
	
	method poder() = self.losQueEstanEnCombate().sum({unIntegrante => unIntegrante.poder()})
	
	method losQueEstanEnCombate() = integrantes.filter({unIntegrante => not(unIntegrante.estaFueraDeCombate())})


    method recibirDanio(cantDanio) = self.cuantosAdelante(10).forEach({unIntegrante => unIntegrante.recibirDanio(self.danioPorIntegrante(cantDanio,10))})
    
    method cuantosAdelante(cantAdelante) = self.losQueVanAdelante(cantAdelante)

    method danioPorIntegrante(danio,cant) = danio / (self.losQueVanAdelante(cant).size())

    method losQueVanAdelante(cant){
    	if(self.losQueEstanEnCombate().size() > cant){
    		return (self.losQueEstanEnCombate().sortedBy({unIntegrante => unIntegrante.poder()}).take(cant))
    	}
    	else{
    		return integrantes
    	}
    }
    method estaFueraDeCombate() = self.losQueEstanEnCombate().size() == 0
    
    
    method pelear(enemigo){
    	if(not(enemigo.estaFueraDeCombate()) or not(self.estaFueraDeCombate())){
    		self.elMenosPoderosoRecibeDanio(enemigo)
    	}
        else{
        	self.error("No se puede llevar a cabo la pelea")
        }
    
    }
    
    method elMenosPoderosoRecibeDanio(enemigo) = self.elMenosPoderoso(enemigo).recibirDanio((self.diferenciaDePoderes(enemigo).abs()))
    	
    	
    method diferenciaDePoderes(enemigo) = enemigo.poder() - self.poder()
    
    
    
    method elMenosPoderoso(enemigo){
    	if(enemigo.poder() > self.poder()){
    		return self
    	}
    	else{
    		return enemigo
    	}
    	
    }
   
}

class Legion inherits Ejercito{
	var formacion 
	
	
	method cambiarFormacion(nuevaFormacion){
		formacion = nuevaFormacion
	}
	
    override method poder() = formacion.poder()
    
    override method recibirDanio(danio) = formacion.recibirDanio(danio)
	
}



object tortuga inherits Ejercito{
	
	override method poder() = 0
	
	//override method recibirDanio(danio){ // No se por que me dice que el que esta sobreescribiendo retorna 
		
	//}
}

class Cuadro inherits Ejercito{
	const cantAdelanteCuadro
	
	override method cuantosAdelante(cantAdelante) = self.losQueVanAdelante(cantAdelanteCuadro)
}

object frontemAllargate inherits Ejercito{
	override method poder() = super() + super() * 0.1
	
	override method cuantosAdelante(cantAdelante) = self.losQueVanAdelante(5)
	
	override method recibirDanio(danio) = 2.times(super(danio))
	
}




















