# NutriScan

NutriScan es una aplicación móvil que utiliza un modelo de TensorFlow Lite para clasificar 9 tipos de frutas distintas: uvas, manzanas, peras, sandías, melones, piñas, guayabas, plátanos y papayas. La aplicación permite al usuario tomar una foto o seleccionar una imagen de la galería, procesarla en el dispositivo móvil y devolver el nombre de la fruta detectada, así como una imagen original con recuadros delimitando dónde se encuentra la fruta en la imagen. Además, proporciona información sobre las calorías y macronutrientes que la fruta aporta si se consume 100 gramos de la misma.

## Funcionamiento

### Pantalla 1: Inicio de Sesión

En esta pantalla se controla el inicio de sesión, aunque esta funcionalidad aún no está implementada. Se muestra información breve sobre el funcionamiento de la aplicación móvil.

### Pantalla 2: Selección de Imagen

En esta pantalla, el usuario puede seleccionar una imagen de la galería de su dispositivo o tomar una foto al instante.

### Después de Ingresada la Imagen

Una vez que se selecciona o toma la imagen, la aplicación procesa la imagen en el dispositivo y detecta la fruta presente en la imagen.

### Pantalla 3: Información de la Fruta

En esta pantalla, se muestra información detallada sobre la fruta detectada. El usuario puede desplazarse verticalmente para acceder a más información.

### Añadir Cantidad Consumida

El usuario tiene la opción de añadir la cantidad consumida de la fruta. Esta información se utiliza para calcular las calorías y macronutrientes.

### Pantalla 4: Base de Datos de Consumo

La cantidad y tipo de fruta consumida se añade a una base de datos dentro del dispositivo móvil. Esta base de datos guarda de forma persistente todo lo que el usuario ha consumido.

## Requisitos

- Dispositivo móvil con sistema operativo Android.
- Acceso a la cámara del dispositivo y a la galería de imágenes.
