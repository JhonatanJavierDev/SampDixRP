# SampDixRP
Gamemode de mi proyecto cerrado SampDix RP esta gm es una base de srp de adri1, cuenta con bastante trabajo de mi parte apesar de que claramente mantiene su estructura general
es un buen proyectaso muy completo que facilmente te puede conducir al exito en sa-mp ya que tiene todo para triunfar como servidor


# Como se instala la GM?

*Pues muy sencillo lo primero que debemos hacer es ubicar el archivo mysql_db.ini una vez lo encontremos procedemos a abrirlo
*Ya dentro debemos modificar los siguientes parametros

*Esto es lo que saldra dentro del archivo*
hostname = localhost
username = root
database = mibd
auto_reconnect = false

Nosotros lo que haremos sera cambiar estos datos por los de nuestra base de datos
sencillo hostname lo dejaremos asi, username es root(si esta por defecto osea si no cambiaste nada y dejaste el xampp como viene normal)
en database pondremos el nombre de nuestra base de datos.
cabe aclarar que si lo subes a un host deberas crear un dictamen especial llamado password = TUCONTRASEÑA

*Ejemplo en LocalHost*
hostname = localhost
username = root
database = ServerBasedatos
auto_reconnect = false

*Ejemplo en un Host*
hostname = localhost
username = USUARIO_BD_DE_TU_HOST
database = Base
passowrd = CONTRASEÑA_BD_DE_TU_HOST
auto_reconnect = false
