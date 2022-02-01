#### ENVIRONMENT
Para plasmar la idea de lo que representa el ambiente se creo un nuevo tipo de datos llamado ENV. Su principal característica es que sus funciones constructoras son en su mayoría listas de tuplas de Int que permiten determinar las posiciones del agente u elemento del ambiente que representan. El tipo ENV tiene como funciones constructoras las siguientes: 

- rows :: Int : Esta funcion permite conocer el numero de filas del ambiente
- columns :: Int : Esta funcion permite conocer el numero de columnas del ambiente
- kids :: [(Int,Int)] : Es una funcion utilizada para mantener las posiciones de los niños.
- obstc :: [(Int,Int)] : Se utiliza para mantener las posiciones de los obstáculos.
- dirt :: [(Int,Int)] : Devuelve una lista con las posiciones de las celdas del ambiente sucias.
- playpen :: [(Int,Int)] : Devuelve una lista con las posiciones que ocupa el corral.
- robots :: [(Int,Int)] : lista con las posiciones que ocupa cada agente de limpieza en el ambiente. 

- carryingKid :: [Bool] : Devuelve una lista indicando que el i-esimo agente se encuentra cargando un niño. 

- playpenTaken :: [(Int,Int)] : lista indicando las posiciones del corral que han sido tomadas. 

Trabajar con un ambiente que se materializa a través del tipo Env nos fue muy beneficioso ya que cuando alguna función necesitaba modificar el ambiente recibía un ENV que podía cambiar agregándole nuevas listas con posiciones cambiadas o boleanos distintos, y este pasaba a ser el nuevo ambiente actual. 
Por otra parte podemos agregar que resulta totalmente escalable esta solución ya que si en una instancia futuro queremos agregar nuevos elementos al ambiente(díganse baches, mascotas, etc) solo debemos agregar otras funciones constructoras con las posiciones de dichos elementos.



#### Módulo Dirt

Este modulo alberga la función encargada de generar la suciedad tras el movimiento de un niño. La idea es que cuando un niño se mueve se analice la cuadricula de $3$x$3$ que tiene como centro su antigua posición. Luego nuestra función generateDirt recibe los niños encontrados en la cuadricula, la lista con las posibles posiciones a ensuciar(celdas libres)  de la cuadricula de $3$x$3$ y dos generadores. Esto nos sirve para, según la cantidad de niños en la cuadricula, escoger aleatoriamente la cantidad que se va a ensuciar, atendiendo los limites establecidos en el proyecto, y cuales de dichas posibles celdas a ensuciar serán tomadas de forma aleatoria. Tener en cuenta que la cantidad a ensuciar puede ser mayor que las celdas disponibles. En ese caso se ensuciaran las que se pueda solamente.

