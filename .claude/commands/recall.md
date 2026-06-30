Reconstruye el contexto de la última sesión de trabajo en este proyecto.

Pasos:
1. Lista los archivos .jsonl en `C:\Users\alvaro\.claude\projects\C--proyectos-outbound-whatsapp\` ordenados por fecha de modificación (más reciente primero). Usa PowerShell: `Get-ChildItem "C:\Users\alvaro\.claude\projects\C--proyectos-outbound-whatsapp\*.jsonl" | Sort-Object LastWriteTime -Descending | Select-Object -First 3 FullName, LastWriteTime`
2. Lee el archivo más reciente (o el segundo si el más reciente es la sesión actual con <5 mensajes). Usa PowerShell para leer las últimas 200 líneas: `Get-Content "<path>" -Tail 200`
3. Extrae del JSON cada línea con `"role":"user"` o `"role":"assistant"` y reconstruye un resumen de:
   - Qué problema/tarea se trabajó
   - Qué se implementó o cambió
   - Dónde quedó (estado final, próximos pasos mencionados)
4. Presenta resumen conciso en español caveman: qué hicimos, dónde quedamos, qué falta.
